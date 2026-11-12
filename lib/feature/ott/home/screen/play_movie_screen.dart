import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:untitled/core/widget/flutter_toast.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../../../router/app_routes.dart';
import '../../ads/controller/ott_ads_controller.dart';
import '../../ads/model/ott_ads_model.dart';
import '../../content/controller/ott_content_controller.dart';
import '../../content/model/ott_content_model.dart';

class PlayMovieScreen extends StatefulWidget {
  final OttContentModel content;

  const PlayMovieScreen({
    super.key,
    required this.content,
  });

  @override
  State<PlayMovieScreen> createState() => _PlayMovieScreenState();
}

class _PlayMovieScreenState extends State<PlayMovieScreen> {
  final OttContentController contentCtrl = Get.find<OttContentController>();
  final OttAdsController adsCtrl = Get.find<OttAdsController>();

  VideoPlayerController? _videoController;
  bool _isVideoLoading = false;
  bool _hasVideoError = false;
  bool _isFullScreen = false;

  bool _showControls = true;
  bool _isMuted = false;
  Timer? _hideControlsTimer;
  static final Map<String, String> _streamUrlCache = {};

  // ================= AD STATES =================
  Timer? _adCountdownTimer;
  Timer? _skipTimer;
  OttAdsModel? _activeAd;
  int _adSecondsRemaining = 15;
  bool _wasPlayingBeforeAd = false;

  // Ad video
  VideoPlayerController? _adVideoController;
  bool _adVideoLoading = false;
  bool _adVideoError = false;
  bool _adMuted = false;

  // Skip button visibility
  bool _canSkipAd = false;

  // 🆕 Dynamic mid-roll thresholds (computed from video duration)
  List<double> _thresholds = [];
  bool _thresholdsReady = false;
  int _nextThresholdIndex = 0;
  DateTime? _lastAdEndTime;

  // 🆕 Guards to prevent double-trigger
  bool _adStarting = false;

  bool _isNavigating = false;

  // ── ALL ads (is_home true & false both) ──
  List<OttAdsModel> get _allAds => adsCtrl.ads;

  OttAdsModel? _pickRandomAd() {
    final list = _allAds;
    if (list.isEmpty) return null;
    return list[Random().nextInt(list.length)];
  }

  @override
  void initState() {
    super.initState();

    // Ads load in background (only needed for mid-rolls now)
    if (adsCtrl.ads.isEmpty) {
      adsCtrl.fetchAds();
    }

    // ✅ Video plays immediately — no pre-roll
    if (widget.content.videoUrl.isNotEmpty) {
      _initVideo(widget.content.videoUrl);
    }
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    _adCountdownTimer?.cancel();
    _skipTimer?.cancel();
    _videoController?.removeListener(_onVideoTick);
    _videoController?.dispose();
    _adVideoController?.removeListener(_onAdVideoTick);
    _adVideoController?.dispose();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  // ================= THRESHOLD COMPUTATION =================
  /// Compute how many mid-rolls to show based on video length
  List<double> _computeThresholds(Duration dur) {
    final sec = dur.inSeconds;
    if (sec < 30) return []; // too short
    if (sec < 60) return [50]; // 1 ad at halfway
    if (sec < 180) return [33, 66]; // 2 ads
    return [20, 40, 60, 80]; // 4 ads evenly
  }

  void _ensureThresholds() {
    if (_thresholdsReady) return;
    final vc = _videoController;
    if (vc == null || !vc.value.isInitialized) return;
    _thresholds = _computeThresholds(vc.value.duration);
    _thresholdsReady = true;
  }

  // ================= MID-ROLL CHECKER =================
  void _checkForMidRollAd() {
    if (_adStarting) return;
    if (_activeAd != null) return;

    _ensureThresholds();
    if (_nextThresholdIndex >= _thresholds.length) return;

    final vc = _videoController;
    if (vc == null || !vc.value.isInitialized) return;

    final dur = vc.value.duration;
    if (dur.inMilliseconds < 1000) return;

    // Cooldown: at least 3 sec of content between ads
    if (_lastAdEndTime != null &&
        DateTime.now().difference(_lastAdEndTime!).inSeconds < 3) {
      return;
    }

    final pos = vc.value.position;
    final pct = (pos.inMilliseconds / dur.inMilliseconds) * 100;
    final threshold = _thresholds[_nextThresholdIndex];

    // User seeked far past → skip this threshold silently
    if (pct > threshold + 15) {
      _nextThresholdIndex++;
      return;
    }

    if (pct >= threshold) {
      _nextThresholdIndex++;
      final ad = _pickRandomAd();
      if (ad != null) _startAd(ad);
    }
  }

  // ================= START AD (guaranteed pause) =================
  Future<void> _startAd(OttAdsModel ad) async {
    if (_adStarting) return;
    _adStarting = true;

    try {
      // 1. Capture whether content was playing (for resume)
      _wasPlayingBeforeAd = _videoController?.value.isPlaying ?? false;

      // 2. ✅ Pause the main video FIRST and await it
      _hideControlsTimer?.cancel();
      final vc = _videoController;
      if (vc != null && vc.value.isInitialized) {
        try {
          await vc.pause();
        } catch (_) {}
      }

      // 3. Bail if unmounted
      if (!mounted) return;

      // 4. Show ad overlay
      _disposeAdVideo();
      setState(() {
        _activeAd = ad;
        _canSkipAd = false;
        _adSecondsRemaining = 15;
      });

      // 5. Skip button appears after 6 sec
      _skipTimer?.cancel();
      _skipTimer = Timer(const Duration(seconds: 6), () {
        if (mounted && _activeAd != null) {
          setState(() => _canSkipAd = true);
        }
      });

      // 6. Load ad media
      if (ad.hasVideo) {
        _initAdVideo(ad.videoUrl!);
      } else {
        _startAdCountdown(15);
      }
    } finally {
      _adStarting = false;
    }
  }

  void _startAdCountdown(int seconds) {
    _adCountdownTimer?.cancel();
    if (mounted) setState(() => _adSecondsRemaining = seconds);

    _adCountdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || _activeAd == null) {
        timer.cancel();
        return;
      }
      if (_adSecondsRemaining > 1) {
        setState(() => _adSecondsRemaining--);
      } else {
        _endAd();
      }
    });
  }

  Future<void> _initAdVideo(String videoUrl) async {
    final videoId = _extractYouTubeId(videoUrl);
    if (mounted) {
      setState(() {
        _adVideoLoading = true;
        _adVideoError = false;
      });
    }

    try {
      String resolvedUrl = videoUrl;
      if (videoId != null) {
        final cacheKey = 'ad_$videoId';
        final cached = _streamUrlCache[cacheKey];
        if (cached != null) {
          resolvedUrl = cached;
        } else {
          final yt = YoutubeExplode();
          try {
            final manifest =
            await yt.videos.streamsClient.getManifest(videoId);
            final muxed = manifest.muxed.sortByVideoQuality();
            final stream = muxed.firstWhere(
                    (s) => s.videoResolution.height <= 720,
                orElse: () => muxed.first);
            resolvedUrl = stream.url.toString();
            _streamUrlCache[cacheKey] = resolvedUrl;
          } finally {
            yt.close();
          }
        }
      }

      final ctrl = VideoPlayerController.networkUrl(
        Uri.parse(resolvedUrl),
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );
      await ctrl.initialize();

      if (!mounted || _activeAd == null) {
        await ctrl.dispose();
        return;
      }

      ctrl.setLooping(false);
      ctrl.setVolume(_adMuted ? 0 : 1);
      await ctrl.play();

      final videoSec = ctrl.value.duration.inSeconds + 1;
      ctrl.addListener(_onAdVideoTick);

      _adVideoController?.dispose();
      if (mounted) {
        setState(() {
          _adVideoController = ctrl;
          _adVideoLoading = false;
        });
        _startAdCountdown(videoSec);
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _adVideoError = true;
          _adVideoLoading = false;
        });
        _startAdCountdown(15);
      }
    }
  }

  void _onAdVideoTick() {
    if (!mounted || _activeAd == null) return;
    final vc = _adVideoController;
    if (vc == null) return;
    final v = vc.value;
    if (!v.isInitialized) return;

    if (!_canSkipAd && v.position.inSeconds >= 6) {
      setState(() => _canSkipAd = true);
    }

    if (v.duration > Duration.zero &&
        v.position >= v.duration - const Duration(milliseconds: 500) &&
        !v.isPlaying) {
      _endAd();
    }
  }

  void _disposeAdVideo() {
    _adVideoController?.removeListener(_onAdVideoTick);
    _adVideoController?.dispose();
    _adVideoController = null;
    _adVideoLoading = false;
    _adVideoError = false;
  }

  // ================= END AD (guaranteed resume) =================
  void _endAd() {
    _adCountdownTimer?.cancel();
    _skipTimer?.cancel();
    _disposeAdVideo();
    if (!mounted) return;

    _lastAdEndTime = DateTime.now();

    final shouldResume = _wasPlayingBeforeAd;
    _wasPlayingBeforeAd = false;

    setState(() {
      _activeAd = null;
      _canSkipAd = false;
    });

    // Resume content if it was playing before ad
    if (shouldResume &&
        _videoController != null &&
        _videoController!.value.isInitialized &&
        !_videoController!.value.isPlaying) {
      _videoController!.play();
      _startHideControlsTimer();
    }
  }

  void _skipAd() {
    if (!_canSkipAd) return;
    _endAd();
    FlutterToast.success('Ad skipped');
  }

  void _toggleAdMute() {
    setState(() => _adMuted = !_adMuted);
    _adVideoController?.setVolume(_adMuted ? 0 : 1);
  }

  // ================= SIMILAR CONTENT =================
  Future<void> _playSimilar(OttContentModel item) async {
    if (_isNavigating) return;
    _isNavigating = true;

    _hideControlsTimer?.cancel();
    _adCountdownTimer?.cancel();
    _skipTimer?.cancel();
    _videoController?.pause();

    await Get.off(
          () => PlayMovieScreen(
        key: ValueKey(
            'play_${item.id}_${DateTime.now().microsecondsSinceEpoch}'),
        content: item,
      ),
      preventDuplicates: false,
      transition: Transition.fadeIn,
      duration: const Duration(milliseconds: 250),
    );

    _isNavigating = false;
  }

  // ================= VIDEO LOGIC =================
  void _onVideoTick() {
    if (!mounted) return;
    if (_activeAd != null) return; // skip while ad is showing
    setState(() {});
    _checkForMidRollAd();
  }

  String? _extractYouTubeId(String url) {
    try {
      final uri = Uri.parse(url);
      if (uri.host.contains('youtu.be')) {
        return uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
      }
      if (uri.host.contains('youtube.com')) {
        if (uri.pathSegments.contains('shorts')) {
          final idx = uri.pathSegments.indexOf('shorts');
          if (idx + 1 < uri.pathSegments.length) {
            return uri.pathSegments[idx + 1];
          }
        }
        if (uri.queryParameters.containsKey('v')) {
          return uri.queryParameters['v'];
        }
        if (uri.pathSegments.contains('embed')) {
          final idx = uri.pathSegments.indexOf('embed');
          if (idx + 1 < uri.pathSegments.length) {
            return uri.pathSegments[idx + 1];
          }
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<void> _initVideo(String videoUrl) async {
    final videoId = _extractYouTubeId(videoUrl);
    if (mounted) {
      setState(() {
        _isVideoLoading = true;
        _hasVideoError = false;
      });
    }

    try {
      String resolvedUrl = videoUrl;
      if (videoId != null) {
        String? cachedUrl = _streamUrlCache[videoId];
        if (cachedUrl != null) {
          resolvedUrl = cachedUrl;
        } else {
          final yt = YoutubeExplode();
          try {
            final manifest =
            await yt.videos.streamsClient.getManifest(videoId);
            final muxedStreams = manifest.muxed.sortByVideoQuality();
            final streamInfo = muxedStreams.firstWhere(
                    (s) => s.videoResolution.height <= 720,
                orElse: () => muxedStreams.first);
            resolvedUrl = streamInfo.url.toString();
            _streamUrlCache[videoId] = resolvedUrl;
          } finally {
            yt.close();
          }
        }
      }

      final newController = VideoPlayerController.networkUrl(
          Uri.parse(resolvedUrl),
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true));
      await newController.initialize();

      if (!mounted) {
        newController.dispose();
        return;
      }

      newController.setLooping(false);
      newController.setVolume(_isMuted ? 0 : 1);
      newController.addListener(_onVideoTick);

      // ✅ Always auto-play (no pre-roll gating)
      newController.play();

      _videoController?.removeListener(_onVideoTick);
      _videoController?.dispose();

      setState(() {
        _videoController = newController;
        _isVideoLoading = false;
        _thresholdsReady = false; // recompute on new video
      });
      _startHideControlsTimer();
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasVideoError = true;
          _isVideoLoading = false;
        });
      }
    }
  }

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && (_videoController?.value.isPlaying ?? false)) {
        setState(() => _showControls = false);
      }
    });
  }

  void _toggleControlsVisibility() {
    setState(() => _showControls = !_showControls);
    if (_showControls) _startHideControlsTimer();
  }

  void _togglePlayPause() {
    if (_videoController == null) return;
    setState(() {
      if (_videoController!.value.isPlaying) {
        _videoController!.pause();
        _hideControlsTimer?.cancel();
      } else {
        _videoController!.play();
        _startHideControlsTimer();
      }
    });
  }

  void _toggleMute() {
    if (_videoController == null) return;
    setState(() {
      _isMuted = !_isMuted;
      _videoController!.setVolume(_isMuted ? 0 : 1);
    });
  }

  void _seekBy(Duration offset) {
    if (_videoController == null) return;
    final current = _videoController!.value.position;
    final total = _videoController!.value.duration;
    var newPosition = current + offset;
    if (newPosition < Duration.zero) {
      newPosition = Duration.zero;
    } else if (newPosition > total) {
      newPosition = total;
    }
    _videoController!.seekTo(newPosition);
    if (_showControls) _startHideControlsTimer();
  }

  Future<void> _toggleFullScreen() async {
    if (_videoController == null || !_videoController!.value.isInitialized) {
      return;
    }
    if (!_isFullScreen) {
      await SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      await SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
    if (mounted) setState(() => _isFullScreen = !_isFullScreen);
  }

  String _formatDuration(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    if (d.inHours > 0) {
      return '${two(d.inHours)}:${two(d.inMinutes.remainder(60))}:${two(d.inSeconds.remainder(60))}';
    }
    return '${two(d.inMinutes)}:${two(d.inSeconds.remainder(60))}';
  }

  @override
  Widget build(BuildContext context) {
    if (_activeAd != null) {
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) {
            FlutterToast.warning("Please wait for the ad to finish");
          }
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          body: _buildFullScreenAdOverlay(),
        ),
      );
    }

    if (_isFullScreen) return _buildFullScreenPlayer();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) Get.offAllNamed(AppRoutes.ottDashboard);
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(toolbarHeight: 0, backgroundColor: Colors.black),
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade700,
                      borderRadius: BorderRadius.circular(12),
                      image: (_videoController == null && !_isVideoLoading)
                          ? DecorationImage(
                        image: NetworkImage(
                            widget.content.thumbnailHorizontal),
                        fit: BoxFit.cover,
                        onError: (_, __) {},
                      )
                          : null,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: _buildPlayerArea(),
                    ),
                  ),
                  if (_videoController == null ||
                      !_videoController!.value.isPlaying)
                    Positioned(
                      top: 20,
                      left: 20,
                      child: IconButton(
                        onPressed: () =>
                            Get.offAllNamed(AppRoutes.ottDashboard),
                        icon: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white)),
                          child: const Icon(Icons.arrow_back_ios,
                              color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(flex: 2, child: _buildDetails()),
          ],
        ),
      ),
    );
  }

  // ================= FULL SCREEN AD OVERLAY =================
  Widget _buildFullScreenAdOverlay() {
    final ad = _activeAd!;
    final hasVideo = ad.hasVideo;

    return Stack(
      fit: StackFit.expand,
      children: [
        if (hasVideo) _buildAdVideo() else _buildAdImage(ad),

        Container(color: Colors.black.withOpacity(0.25)),

        // Ad mute button (top-left)
        if (hasVideo && !_adVideoError && _adVideoController != null)
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: GestureDetector(
              onTap: _toggleAdMute,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white24),
                ),
                child: Icon(
                  _adMuted ? Icons.volume_off : Icons.volume_up,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),

        // Skip button / countdown (top-right)
        Positioned(
          top: MediaQuery.of(context).padding.top + 16,
          right: 16,
          child: _canSkipAd
              ? GestureDetector(
            onTap: _skipAd,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.75),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white54),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Skip Ad',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.skip_next, color: Colors.white, size: 16),
                ],
              ),
            ),
          )
              : Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white24),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                      color: Colors.amber, strokeWidth: 2),
                ),
                const SizedBox(width: 8),
                Text(
                  'Ad ends in ${_adSecondsRemaining}s',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Bottom info
        Positioned(
          bottom: MediaQuery.of(context).padding.bottom + 40,
          left: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(4)),
                child: const Text(
                  'SPONSORED',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                ad.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Colors.black, blurRadius: 10)],
                ),
              ),
              if (ad.navigateScreen != null &&
                  ad.navigateScreen!.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  'Tap to know more',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                      fontStyle: FontStyle.italic),
                ),
              ]
            ],
          ),
        ),

        GestureDetector(
          onTap: () {
            if (ad.navigateScreen != null && ad.navigateScreen!.isNotEmpty) {
              Get.snackbar('Navigate', 'Go to ${ad.navigateScreen}',
                  backgroundColor: Colors.white, colorText: Colors.black);
            }
          },
          child: Container(color: Colors.transparent),
        ),
      ],
    );
  }

  Widget _buildAdVideo() {
    if (_adVideoLoading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: Colors.amber),
            const SizedBox(height: 12),
            Text('Loading ad...',
                style: TextStyle(color: Colors.white.withOpacity(0.8))),
          ],
        ),
      );
    }
    if (_adVideoError || _adVideoController == null) {
      return _buildAdImage(_activeAd!);
    }
    final v = _adVideoController!.value;
    if (!v.isInitialized) return _buildAdImage(_activeAd!);

    return Center(
      child: AspectRatio(
        aspectRatio: v.aspectRatio,
        child: VideoPlayer(_adVideoController!),
      ),
    );
  }

  Widget _buildAdImage(OttAdsModel ad) {
    if (ad.image != null && ad.image!.isNotEmpty) {
      return Image.network(
        ad.image!,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => const Center(
            child: Icon(Icons.image_not_supported,
                color: Colors.white54, size: 50)),
      );
    }
    return const Center(
        child:
        Icon(Icons.image_not_supported, color: Colors.white54, size: 50));
  }

  // ================= DETAILS =================
  Widget _buildDetails() {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.grey[900], borderRadius: BorderRadius.circular(12)),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.content.title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            if (widget.content.description.isNotEmpty)
              ReadMoreText(
                widget.content.description,
                trimLines: 3,
                colorClickableText: Colors.blue,
                trimMode: TrimMode.Line,
                trimCollapsedText: 'Read more',
                trimExpandedText: ' Show less',
                style: const TextStyle(
                    color: Colors.white70, fontSize: 13, height: 1.5),
                moreStyle: const TextStyle(
                    color: Colors.blue,
                    fontSize: 13,
                    fontWeight: FontWeight.w600),
                lessStyle: const TextStyle(
                    color: Colors.blue,
                    fontSize: 13,
                    fontWeight: FontWeight.w600),
              ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                if (widget.content.videoDuration.isNotEmpty)
                  _chip(Icons.access_time, widget.content.videoDuration,
                      Colors.white),
                if (widget.content.releaseDate.isNotEmpty)
                  _chip(Icons.calendar_today, widget.content.releaseDate,
                      Colors.white),
                _chip(Icons.category,
                    widget.content.categoryName.toUpperCase(), Colors.white),
                if (widget.content.isFamily)
                  _chip(Icons.family_restroom, 'Family', Colors.green),
                if (widget.content.isLock)
                  _chip(Icons.lock, 'Premium', Colors.amber),
              ],
            ),
            const SizedBox(height: 20),

            Obx(() {
              final ads = adsCtrl.ads;
              if (ads.isEmpty) return const SizedBox.shrink();
              final ad = ads.first;
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: _BottomBannerAd(
                  key: ValueKey('banner_${ad.id}'),
                  ad: ad,
                  onTap: () {
                    if (ad.navigateScreen != null &&
                        ad.navigateScreen!.isNotEmpty) {
                      Get.snackbar('Navigate', 'Go to ${ad.navigateScreen}');
                    }
                  },
                ),
              );
            }),

            Row(
              spacing: 10,
              children: [
                Container(color: Colors.red, height: 14, width: 3),
                const Text('Similar Content',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold))
              ],
            ),
            const SizedBox(height: 12),
            Obx(() {
              final similar = contentCtrl.contents
                  .where((c) =>
              c.categoryId == widget.content.categoryId &&
                  c.id != widget.content.id)
                  .toList();
              if (similar.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('No similar content found',
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                );
              }
              return SizedBox(
                height: 180,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: similar.length,
                  itemBuilder: (context, index) {
                    final item = similar[index];
                    return GestureDetector(
                      onTap: () => _playSimilar(item),
                      child: Container(
                        width: 120,
                        margin: const EdgeInsets.only(right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  item.thumbnailVertical.isNotEmpty
                                      ? item.thumbnailVertical
                                      : item.thumbnailHorizontal,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  errorBuilder: (_, __, ___) => Container(
                                    color: Colors.grey[900],
                                    child: const Center(
                                      child: Icon(Icons.movie,
                                          color: Colors.white24),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerArea() {
    if (_hasVideoError) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 40),
            const SizedBox(height: 8),
            const Text('Failed to load video',
                style: TextStyle(color: Colors.white)),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                if (widget.content.videoUrl.isNotEmpty) {
                  _initVideo(widget.content.videoUrl);
                }
              },
              child: const Text('Retry', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }
    if (_isVideoLoading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Colors.red),
            SizedBox(height: 10),
            Text('Loading video...', style: TextStyle(color: Colors.red)),
          ],
        ),
      );
    }
    if (_videoController != null && _videoController!.value.isInitialized) {
      return _buildVideoWithControls(isFullScreen: false);
    }

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        Center(
          child: IconButton(
            iconSize: 60,
            onPressed: () {
              if (widget.content.videoUrl.isEmpty) {
                FlutterToast.error("No video URL available");
                return;
              }
              _initVideo(widget.content.videoUrl);
            },
            icon: const Icon(Icons.play_circle_fill, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildVideoWithControls({required bool isFullScreen}) {
    final value = _videoController!.value;
    return GestureDetector(
      onTap: _toggleControlsVisibility,
      onDoubleTapDown: (details) {
        final box = context.findRenderObject() as RenderBox?;
        if (box == null) return;
        if (details.localPosition.dx < box.size.width / 2) {
          _seekBy(const Duration(seconds: -10));
        } else {
          _seekBy(const Duration(seconds: 10));
        }
        if (!_showControls) {
          setState(() => _showControls = true);
          _startHideControlsTimer();
        }
      },
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          Container(color: Colors.black),
          Center(
            child: InteractiveViewer(
              minScale: 1.0,
              maxScale: 4.0,
              child: AspectRatio(
                aspectRatio: value.aspectRatio,
                child: VideoPlayer(_videoController!),
              ),
            ),
          ),
          AnimatedOpacity(
            opacity: _showControls ? 1 : 0,
            duration: const Duration(milliseconds: 200),
            child: IgnorePointer(
              ignoring: !_showControls,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.35),
                      Colors.transparent,
                      Colors.black.withOpacity(0.55),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: _toggleMute,
                            icon: Icon(
                              _isMuted ? Icons.volume_off : Icons.volume_up,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          iconSize: isFullScreen ? 44 : 34,
                          onPressed: () =>
                              _seekBy(const Duration(seconds: -10)),
                          icon: const Icon(Icons.replay_10,
                              color: Colors.white),
                        ),
                        SizedBox(width: isFullScreen ? 24 : 16),
                        value.isBuffering
                            ? const CircularProgressIndicator(color: Colors.red)
                            : IconButton(
                          iconSize: isFullScreen ? 64 : 48,
                          onPressed: _togglePlayPause,
                          icon: Icon(
                            value.isPlaying
                                ? Icons.pause_circle_filled
                                : Icons.play_circle_fill,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: isFullScreen ? 24 : 16),
                        IconButton(
                          iconSize: isFullScreen ? 44 : 34,
                          onPressed: () => _seekBy(const Duration(seconds: 10)),
                          icon: const Icon(Icons.forward_10,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          VideoProgressIndicator(
                            _videoController!,
                            allowScrubbing: true,
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            colors: const VideoProgressColors(
                              playedColor: Colors.red,
                              bufferedColor: Colors.white38,
                              backgroundColor: Colors.white24,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                _formatDuration(value.position),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                              const Spacer(),
                              Text(
                                _formatDuration(value.duration),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: _toggleFullScreen,
                                icon: Icon(
                                  isFullScreen
                                      ? Icons.fullscreen_exit
                                      : Icons.fullscreen,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullScreenPlayer() {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _toggleFullScreen();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: _buildVideoWithControls(isFullScreen: true),
        ),
      ),
    );
  }

  Widget _chip(IconData icon, String label, Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: Colors.grey[800], borderRadius: BorderRadius.circular(6)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: iconColor),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// BOTTOM BANNER AD CARD
// ═══════════════════════════════════════════════════════════════
class _BottomBannerAd extends StatefulWidget {
  final OttAdsModel ad;
  final VoidCallback onTap;

  const _BottomBannerAd({
    super.key,
    required this.ad,
    required this.onTap,
  });

  @override
  State<_BottomBannerAd> createState() => _BottomBannerAdState();
}

class _BottomBannerAdState extends State<_BottomBannerAd> {
  VideoPlayerController? _video;
  bool _videoReady = false;
  bool _videoFailed = false;
  bool _isMuted = true;
  bool _userPaused = false;

  static final Map<String, String> _streamCache = {};

  @override
  void initState() {
    super.initState();
    if (widget.ad.hasVideo) {
      _initVideo(widget.ad.videoUrl!);
    }
  }

  Future<void> _initVideo(String rawUrl) async {
    final ytId = _extractYoutubeId(rawUrl);
    var resolved = rawUrl;

    if (ytId != null) {
      final cacheKey = 'banner_$ytId';
      final cached = _streamCache[cacheKey];
      if (cached != null) {
        resolved = cached;
      } else {
        try {
          final yt = YoutubeExplode();
          try {
            final manifest = await yt.videos.streamsClient.getManifest(ytId);
            final muxed = manifest.muxed.sortByVideoQuality();
            final stream = muxed.firstWhere(
                    (s) => s.videoResolution.height <= 720,
                orElse: () => muxed.first);
            resolved = stream.url.toString();
            _streamCache[cacheKey] = resolved;
          } finally {
            yt.close();
          }
        } catch (_) {
          if (mounted) setState(() => _videoFailed = true);
          return;
        }
      }
    }

    final ctrl = VideoPlayerController.networkUrl(
      Uri.parse(resolved),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );

    try {
      await ctrl.initialize();
      if (!mounted) {
        await ctrl.dispose();
        return;
      }
      ctrl.setLooping(true);
      ctrl.setVolume(_isMuted ? 0 : 1);
      await ctrl.play();
      if (mounted) {
        setState(() {
          _video = ctrl;
          _videoReady = true;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _videoFailed = true);
    }
  }

  String? _extractYoutubeId(String url) {
    try {
      final uri = Uri.parse(url);
      if (uri.host.contains('youtu.be')) {
        return uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
      }
      if (uri.host.contains('youtube.com')) {
        if (uri.pathSegments.contains('shorts')) {
          final idx = uri.pathSegments.indexOf('shorts');
          if (idx + 1 < uri.pathSegments.length) {
            return uri.pathSegments[idx + 1];
          }
        }
        if (uri.queryParameters.containsKey('v')) {
          return uri.queryParameters['v'];
        }
        if (uri.pathSegments.contains('embed')) {
          final idx = uri.pathSegments.indexOf('embed');
          if (idx + 1 < uri.pathSegments.length) {
            return uri.pathSegments[idx + 1];
          }
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  void _togglePlayPause() {
    if (_video == null) return;
    setState(() => _userPaused = !_userPaused);
    if (_userPaused) {
      _video!.pause();
    } else {
      _video!.play();
    }
  }

  void _toggleMute() {
    if (_video == null) return;
    setState(() => _isMuted = !_isMuted);
    _video!.setVolume(_isMuted ? 0 : 1);
  }

  @override
  void dispose() {
    _video?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasVideo = widget.ad.hasVideo && _videoReady && _video != null;
    final hasImageOnly = !widget.ad.hasVideo && widget.ad.hasImage;
    final imageFallback =
        widget.ad.hasVideo && !hasVideo && widget.ad.hasImage;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white12),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (hasVideo)
              FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _video!.value.size.width,
                  height: _video!.value.size.height,
                  child: VideoPlayer(_video!),
                ),
              )
            else if (hasImageOnly || imageFallback)
              Image.network(
                widget.ad.image!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: Colors.black),
              )
            else
              Container(color: Colors.black),

            Container(color: Colors.black.withOpacity(0.25)),

            if (hasVideo)
              Positioned(
                top: 8,
                left: 8,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _roundBtn(
                      icon: _userPaused
                          ? Icons.play_arrow_rounded
                          : Icons.pause_rounded,
                      onTap: _togglePlayPause,
                    ),
                    const SizedBox(width: 6),
                    _roundBtn(
                      icon: _isMuted
                          ? Icons.volume_off_rounded
                          : Icons.volume_up_rounded,
                      onTap: _toggleMute,
                    ),
                  ],
                ),
              ),

            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'SPONSORED',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: 8,
              left: 12,
              right: 12,
              child: Text(
                widget.ad.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _roundBtn({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 14),
      ),
    );
  }
}