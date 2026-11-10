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
import '../../content/controller/ott_tvshows_controller.dart';
import '../../content/model/ott_content_model.dart';
import '../../content/model/ott_tvshows_model.dart';

class PlayTvshowsScreen extends StatefulWidget {
  final OttContentModel content;

  const PlayTvshowsScreen({
    super.key,
    required this.content,
  });

  @override
  State<PlayTvshowsScreen> createState() => _PlayTvshowsScreenState();
}

class _PlayTvshowsScreenState extends State<PlayTvshowsScreen> {
  final OttContentController contentCtrl = Get.find<OttContentController>();
  final OttAdsController adsCtrl = Get.find<OttAdsController>();

  // per-screen TV Shows controller (unique tag)
  late final OttTvShowsController tvCtrl;
  late final String _tvTag;

  VideoPlayerController? _videoController;
  bool _isVideoLoading = false;
  bool _hasVideoError = false;
  bool _isFullScreen = false;

  bool _showControls = true;
  bool _isMuted = false;
  Timer? _hideControlsTimer;
  static final Map<String, String> _streamUrlCache = {};

  // current video url (retry ke liye) + race condition token
  String _currentVideoUrl = '';
  int _initToken = 0;

  // ================= AD STATES =================
  Timer? _adScheduleTimer;
  Timer? _adCountdownTimer;
  OttAdsModel? _activeAd;
  int _adSecondsRemaining = 60;
  bool _wasPlayingBeforeAd = false;

  // double tap / fast tap se bachne ke liye
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();

    // Unique tag: same content dobara khule to bhi controller conflict na ho
    _tvTag = 'tv_${widget.content.id}_${DateTime.now().microsecondsSinceEpoch}';
    tvCtrl = Get.put<OttTvShowsController>(
      OttTvShowsController(),
      tag: _tvTag,
    );
    tvCtrl.fetchTvShowDetail(widget.content.id);

    if (adsCtrl.ads.isEmpty) adsCtrl.fetchAds();

    _currentVideoUrl = widget.content.videoUrl;
    if (_currentVideoUrl.isNotEmpty) _initVideo(_currentVideoUrl);

    // Ad scheduler start
    _scheduleNextAd();
  }

  @override
  void dispose() {
    Get.delete<OttTvShowsController>(tag: _tvTag, force: true);

    _hideControlsTimer?.cancel();
    _adScheduleTimer?.cancel();
    _adCountdownTimer?.cancel();
    _videoController?.removeListener(_onVideoTick);
    _videoController?.dispose();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  // ================= MORE TV SHOWS PLAY (FIXED) =================
  Future<void> _playSimilar(OttContentModel item) async {
    if (_isNavigating) return;
    _isNavigating = true;

    _hideControlsTimer?.cancel();
    _adScheduleTimer?.cancel();
    _adCountdownTimer?.cancel();
    _videoController?.pause();

    // MAIN FIX: GetX same route ko duplicate samajh ke ignore kar deta tha.
    // preventDuplicates: false se har baar play hoga.
    await Get.off(
          () => PlayTvshowsScreen(
        key: ValueKey('play_tv_${item.id}_${DateTime.now().microsecondsSinceEpoch}'),
        content: item,
      ),
      preventDuplicates: false,
      transition: Transition.fadeIn,
      duration: const Duration(milliseconds: 250),
    );

    _isNavigating = false;
  }

  // ================= AD LOGIC =================
  void _scheduleNextAd() {
    _adScheduleTimer?.cancel();
    // Random gap: 60 se 120 seconds
    final randomSeconds = 60 + Random().nextInt(61);

    _adScheduleTimer = Timer(Duration(seconds: randomSeconds), () {
      if (!mounted) return;
      _playRandomAd();
    });
  }

  void _playRandomAd() {
    final activeAds = adsCtrl.ads.where((a) => a.isActive).toList();
    if (activeAds.isEmpty) {
      _scheduleNextAd();
      return;
    }

    final randomAd = activeAds[Random().nextInt(activeAds.length)];

    _wasPlayingBeforeAd = _videoController?.value.isPlaying ?? false;

    setState(() {
      _activeAd = randomAd;
      _adSecondsRemaining = 60;
    });

    if (_videoController != null && _videoController!.value.isPlaying) {
      _videoController!.pause();
      _hideControlsTimer?.cancel();
    }

    _adCountdownTimer?.cancel();
    _adCountdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
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

  void _endAd() {
    _adCountdownTimer?.cancel();
    if (!mounted) return;
    setState(() {
      _activeAd = null;
    });

    if (_wasPlayingBeforeAd &&
        _videoController != null &&
        !_videoController!.value.isPlaying) {
      _videoController!.play();
      _startHideControlsTimer();
    }

    _scheduleNextAd();
  }

  // ================= VIDEO LOGIC =================
  void _onVideoTick() {
    if (mounted) setState(() {});
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
          if (idx + 1 < uri.pathSegments.length) return uri.pathSegments[idx + 1];
        }
        if (uri.queryParameters.containsKey('v')) return uri.queryParameters['v'];
        if (uri.pathSegments.contains('embed')) {
          final idx = uri.pathSegments.indexOf('embed');
          if (idx + 1 < uri.pathSegments.length) return uri.pathSegments[idx + 1];
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<void> _initVideo(String videoUrl) async {
    final myToken = ++_initToken; // naya request, purane ko ignore karne ke liye
    _currentVideoUrl = videoUrl;
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
            final manifest = await yt.videos.streamsClient.getManifest(videoId);
            final muxedStreams = manifest.muxed.sortByVideoQuality();
            final streamInfo = muxedStreams.firstWhere(
                  (s) => s.videoResolution.height <= 720,
              orElse: () => muxedStreams.first,
            );
            resolvedUrl = streamInfo.url.toString();
            _streamUrlCache[videoId] = resolvedUrl;
          } finally {
            yt.close();
          }
        }
      }

      final newController = VideoPlayerController.networkUrl(
        Uri.parse(resolvedUrl),
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );
      await newController.initialize();

      // Screen band ho gayi ya koi naya episode select ho gaya
      if (!mounted || myToken != _initToken) {
        newController.dispose();
        return;
      }

      newController.setLooping(false);
      newController.setVolume(_isMuted ? 0 : 1);
      newController.addListener(_onVideoTick);

      // Agar ad chal raha hai to video peeche play na ho
      if (_activeAd != null) {
        _wasPlayingBeforeAd = true;
      } else {
        newController.play();
      }

      _videoController?.removeListener(_onVideoTick);
      _videoController?.dispose();

      setState(() {
        _videoController = newController;
        _isVideoLoading = false;
      });
      if (_activeAd == null) _startHideControlsTimer();
    } catch (e) {
      if (mounted && myToken == _initToken) {
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

  // Play episode from list
  void _playEpisode(OttTvShowsEpisodeModel ep) {
    if (ep.videoUrl.isEmpty) {
      FlutterToast.error('No video URL for this episode');
      return;
    }
    tvCtrl.setCurrentEpisode(ep);
    _initVideo(ep.videoUrl);
  }

  // ================= BUILD =================
  @override
  Widget build(BuildContext context) {
    // Ad chal raha hai to poori screen par ad dikhao
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
                            border: Border.all(color: Colors.white),
                          ),
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
    return Stack(
      fit: StackFit.expand,
      children: [
        if (_activeAd!.image != null && _activeAd!.image!.isNotEmpty)
          Image.network(
            _activeAd!.image!,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const Center(
                child: Icon(Icons.image_not_supported,
                    color: Colors.white54, size: 50)),
          )
        else
          const Center(
              child: Icon(Icons.image_not_supported,
                  color: Colors.white54, size: 50)),

        Container(color: Colors.black.withOpacity(0.4)),

        // Timer badge (top right)
        Positioned(
          top: MediaQuery.of(context).padding.top + 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),

        // Ad details (bottom)
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
                child: const Text('SPONSORED',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 10),
              Text(
                _activeAd!.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Colors.black, blurRadius: 10)],
                ),
              ),
              if (_activeAd!.navigateScreen != null &&
                  _activeAd!.navigateScreen!.isNotEmpty) ...[
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

        // Tap area (poori screen cover karta hai)
        GestureDetector(
          onTap: () {
            if (_activeAd!.navigateScreen != null &&
                _activeAd!.navigateScreen!.isNotEmpty) {
              Get.snackbar('Navigate', 'Go to ${_activeAd!.navigateScreen}',
                  backgroundColor: Colors.white, colorText: Colors.black);
            }
          },
          child: Container(color: Colors.transparent),
        ),
      ],
    );
  }

  // ================= DETAILS =================
  Widget _buildDetails() {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
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
                _chip(Icons.category, widget.content.categoryName.toUpperCase(),
                    Colors.white),
                if (widget.content.isFamily)
                  _chip(Icons.family_restroom, 'Family', Colors.green),
                if (widget.content.isLock)
                  _chip(Icons.lock, 'Premium', Colors.amber),
              ],
            ),
            const SizedBox(height: 20),

            // ── Sponsored Banner Ad ──
            Obx(() {
              final activeAds = adsCtrl.ads.where((a) => a.isActive).toList();
              if (activeAds.isEmpty) return const SizedBox.shrink();
              final ad = activeAds.first;
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: GestureDetector(
                  onTap: () {
                    if (ad.navigateScreen != null &&
                        ad.navigateScreen!.isNotEmpty) {
                      Get.snackbar('Navigate', 'Go to ${ad.navigateScreen}');
                    }
                  },
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white12),
                      image: ad.image != null && ad.image!.isNotEmpty
                          ? DecorationImage(
                        image: NetworkImage(ad.image!),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.4),
                            BlendMode.darken),
                      )
                          : null,
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text('SPONSORED',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Positioned(
                          bottom: 8,
                          left: 12,
                          right: 12,
                          child: Text(ad.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),

            const SizedBox(height: 12),

            // ── Seasons / Episodes ──
            Obx(() => _buildSeasonsSection()),

            const SizedBox(height: 20),

            // ── More TV Shows ──
            Row(
              spacing: 10,
              children: [
                Container(color: Colors.red, height: 14, width: 3),
                const Text('More TV Shows',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
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
                  child: Text('No other TV shows found',
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
                      // FIXED: ab har baar play hoga
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
                            Text(item.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12)),
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

  // ================= SEASONS / EPISODES UI =================
  Widget _buildSeasonsSection() {
    if (tvCtrl.isLoading.value && tvCtrl.tvShow.value == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.red),
          ),
        ),
      );
    }

    if (tvCtrl.errorMessage.value.isNotEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(tvCtrl.errorMessage.value,
                  style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ),
            TextButton(
              onPressed: () => tvCtrl.fetchTvShowDetail(widget.content.id),
              child: const Text('Retry',
                  style: TextStyle(color: Colors.red, fontSize: 12)),
            ),
          ],
        ),
      );
    }

    final show = tvCtrl.tvShow.value;
    if (show == null || show.seasons.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          'No episodes available yet.',
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(color: Colors.red, height: 14, width: 3),
            const SizedBox(width: 6),
            const Text('Episodes',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            Text(
              '${show.seasons.length} season${show.seasons.length > 1 ? "s" : ""} · ${show.totalEpisodes} episodes',
              style: const TextStyle(color: Colors.grey, fontSize: 11),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Season tabs (only if > 1 season)
        if (show.seasons.length > 1)
          SizedBox(
            height: 34,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: show.seasons.length,
              itemBuilder: (_, i) {
                final s = show.seasons[i];
                final isSelected =
                    s.seasonNumber == tvCtrl.selectedSeason.value;
                return GestureDetector(
                  onTap: () => tvCtrl.selectSeason(s.seasonNumber),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.red : Colors.grey[800],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Season ${s.seasonNumber}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        if (show.seasons.length > 1) const SizedBox(height: 10),

        // Episode cards
        SizedBox(
          height: 155,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: tvCtrl.currentSeasonEpisodes.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, i) {
              final ep = tvCtrl.currentSeasonEpisodes[i];
              return _buildEpisodeCard(ep);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEpisodeCard(OttTvShowsEpisodeModel ep) {
    final isPlaying = tvCtrl.currentEpisode.value?.id == ep.id;
    return GestureDetector(
      onTap: () => _playEpisode(ep),
      child: SizedBox(
        width: 140,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isPlaying ? Colors.red : Colors.transparent,
                      width: isPlaying ? 2 : 0,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (ep.thumbnail != null && ep.thumbnail!.isNotEmpty)
                        Image.network(
                          ep.thumbnail!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey[900],
                            child: const Center(
                              child: Icon(Icons.movie,
                                  color: Colors.white24, size: 32),
                            ),
                          ),
                        )
                      else
                        Container(
                          color: Colors.grey[900],
                          child: const Center(
                            child: Icon(Icons.movie,
                                color: Colors.white24, size: 32),
                          ),
                        ),
                      Container(
                        color: Colors.black.withOpacity(0.25),
                        child: Center(
                          child: Icon(
                            isPlaying
                                ? Icons.graphic_eq
                                : Icons.play_circle_fill,
                            color: isPlaying ? Colors.red : Colors.white70,
                            size: 32,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 6,
                        left: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'E${ep.episodeNumber}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              ep.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isPlaying ? Colors.red : Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(ep.duration,
                style: const TextStyle(color: Colors.grey, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  // ================= PLAYER UI =================
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
                if (_currentVideoUrl.isNotEmpty) {
                  _initVideo(_currentVideoUrl);
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
              if (_currentVideoUrl.isEmpty) {
                FlutterToast.error("No video URL available");
                return;
              }
              _initVideo(_currentVideoUrl);
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
                          onPressed: () => _seekBy(const Duration(seconds: -10)),
                          icon: const Icon(Icons.replay_10, color: Colors.white),
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
                          icon: const Icon(Icons.forward_10, color: Colors.white),
                        ),
                      ],
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                              Text(_formatDuration(value.position),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 12)),
                              const Spacer(),
                              Text(_formatDuration(value.duration),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 12)),
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
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: iconColor),
          const SizedBox(width: 5),
          Text(label,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}