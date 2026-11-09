import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:untitled/core/widget/flutter_toast.dart'; // Apne project ka path check kar lein
import 'package:video_player/video_player.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import '../../../../router/app_routes.dart';
import '../../ads/controller/ott_ads_controller.dart';
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

  // Video Player State
  VideoPlayerController? _videoController;
  bool _isVideoLoading = false;
  bool _hasVideoError = false;
  bool _isFullScreen = false;

  // Custom controls state
  bool _showControls = true;
  bool _isMuted = false;
  Timer? _hideControlsTimer;

  // YouTube Stream Cache
  static final Map<String, String> _streamUrlCache = {};

  @override
  void initState() {
    super.initState();

    // Agar ads load nahi hue hain toh fetch karein
    if (adsCtrl.ads.isEmpty) {
      adsCtrl.fetchAds();
    }

    // Video ko auto-play karein agar URL present hai
    if (widget.content.videoUrl.isNotEmpty) {
      _initVideo(widget.content.videoUrl);
    }
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    _videoController?.removeListener(_onVideoTick);
    _videoController?.dispose();

    // Screen dispose hone par orientation wapas portrait karein
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    super.dispose();
  }

  void _onVideoTick() {
    if (mounted) setState(() {});
  }

  // ==================== YOUTUBE LOGIC ====================
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

    setState(() {
      _isVideoLoading = true;
      _hasVideoError = false;
    });

    try {
      String resolvedUrl = videoUrl;

      // Agar YouTube URL hai toh youtube_explode_dart se stream resolve karein
      if (videoId != null) {
        String? cachedUrl = _streamUrlCache[videoId];
        if (cachedUrl != null) {
          resolvedUrl = cachedUrl;
        } else {
          final yt = YoutubeExplode();
          try {
            final manifest = await yt.videos.streamsClient.getManifest(videoId);
            final muxedStreams = manifest.muxed.sortByVideoQuality();
            // 720p ya usse kam quality choose karein taaki fast load ho
            final streamInfo = muxedStreams.firstWhere(
                  (s) => (s.videoResolution.height) <= 720,
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
      newController.setLooping(false);
      newController.setVolume(_isMuted ? 0 : 1);
      newController.play();
      newController.addListener(_onVideoTick);

      if (!mounted) {
        newController.dispose();
        return;
      }

      _videoController?.removeListener(_onVideoTick);
      _videoController?.dispose();

      setState(() {
        _videoController = newController;
        _isVideoLoading = false;
      });

      _startHideControlsTimer();
    } catch (e) {
      debugPrint('Video load error: $e');
      if (mounted) {
        setState(() {
          _hasVideoError = true;
          _isVideoLoading = false;
        });
      }
    }
  }

  // ==================== CONTROLS LOGIC ====================
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
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }

    setState(() => _isFullScreen = !_isFullScreen);
  }

  String _formatDuration(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);
    if (hours > 0) {
      return '${two(hours)}:${two(minutes)}:${two(seconds)}';
    }
    return '${two(minutes)}:${two(seconds)}';
  }

  // ==================== BUILD ====================
  @override
  Widget build(BuildContext context) {
    if (_isFullScreen) {
      return _buildFullScreenPlayer();
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Get.offAllNamed(AppRoutes.ottDashboard);
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(toolbarHeight: 0, backgroundColor: Colors.black),
        body: Column(
          children: [
            // Top Video Area
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
                        image: NetworkImage(widget.content.thumbnailHorizontal),
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
                  Positioned(
                    top: 20,
                    left: 20,
                    child: IconButton(
                      onPressed: () => Get.offAllNamed(AppRoutes.ottDashboard),
                      icon: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white),
                        ),
                        child: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Details Area
            Expanded(
              flex: 2,
              child: Container(
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
                      Text(
                        widget.content.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Description
                      if (widget.content.description.isNotEmpty)
                        ReadMoreText(
                          widget.content.description,
                          trimLines: 3,
                          colorClickableText: Colors.blue,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: 'Read more',
                          trimExpandedText: ' Show less',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            height: 1.5,
                          ),
                          moreStyle: const TextStyle(
                            color: Colors.blue,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          lessStyle: const TextStyle(
                            color: Colors.blue,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      const SizedBox(height: 12),

                      // Chips
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          if (widget.content.videoDuration.isNotEmpty)
                            _chip(Icons.access_time, widget.content.videoDuration, Colors.white),
                          if (widget.content.releaseDate.isNotEmpty)
                            _chip(Icons.calendar_today, widget.content.releaseDate, Colors.white),
                          _chip(Icons.category, widget.content.categoryName.toUpperCase(), Colors.white),
                          if (widget.content.isFamily) _chip(Icons.family_restroom, 'Family', Colors.green),
                          if (widget.content.isLock) _chip(Icons.lock, 'Premium', Colors.amber),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // ==================== ADS API SECTION ====================
                      Obx(() {
                        final activeAds = adsCtrl.ads.where((a) => a.isActive).toList();
                        if (activeAds.isEmpty) return const SizedBox.shrink();

                        // Pick an ad to show
                        final ad = activeAds.first;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: GestureDetector(
                            onTap: () {
                              if (ad.navigateScreen != null && ad.navigateScreen!.isNotEmpty) {
                                Get.snackbar('Navigate', 'Go to ${ad.navigateScreen}', backgroundColor: Colors.white, colorText: Colors.black);
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
                                    BlendMode.darken,
                                  ),
                                )
                                    : null,
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        'SPONSORED',
                                        style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 8,
                                    left: 12,
                                    right: 12,
                                    child: Text(
                                      ad.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),

                      // ==================== SIMILAR CONTENT ====================
                      Row(
                        spacing: 10,
                        children: [
                          Container(color: Colors.red, height: 14, width: 3),
                          const Text(
                            'Similar Content',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Suggestions from OttContentController
                      Obx(() {
                        // Same category ka content filter karein, current ko chhod kar
                        final similar = contentCtrl.contents
                            .where((c) => c.categoryId == widget.content.categoryId && c.id != widget.content.id)
                            .toList();

                        if (similar.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('No similar content found', style: TextStyle(color: Colors.grey, fontSize: 12)),
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
                                onTap: () {
                                  // Naye content ke sath screen replace karein
                                  Get.off(() => PlayMovieScreen(content: item));
                                },
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
                                            item.thumbnailVertical.isNotEmpty ? item.thumbnailVertical : item.thumbnailHorizontal,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            errorBuilder: (_, __, ___) => Container(
                                              color: Colors.grey[900],
                                              child: const Center(child: Icon(Icons.movie, color: Colors.white24)),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(color: Colors.white, fontSize: 12),
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerArea() {
    if (_hasVideoError) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Container(color: Colors.grey.shade200),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 40),
              const SizedBox(height: 8),
              const Text('Failed to load video', style: TextStyle(color: Colors.white)),
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
        ],
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

    // Initial state thumbnail + play button
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
    final isBuffering = value.isBuffering;

    return GestureDetector(
      onTap: _toggleControlsVisibility,
      onDoubleTapDown: (details) {
        final box = context.findRenderObject() as RenderBox?;
        if (box == null) return;
        final tapX = details.localPosition.dx;
        final width = box.size.width;

        if (tapX < width / 2) {
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
                        isBuffering
                            ? const CircularProgressIndicator(color: Colors.red)
                            : IconButton(
                          iconSize: isFullScreen ? 64 : 48,
                          onPressed: _togglePlayPause,
                          icon: Icon(
                            value.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
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
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                              ),
                              const Spacer(),
                              Text(
                                _formatDuration(value.duration),
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: _toggleFullScreen,
                                icon: Icon(
                                  isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
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
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: iconColor),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}