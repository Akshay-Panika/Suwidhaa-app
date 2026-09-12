import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:untitled/core/widget/flutter_toast.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import '../../controller/ott_controller.dart';

class PlayMovieScreen extends StatefulWidget {
  final int contentId;
  final String contentType;

  const PlayMovieScreen({
    super.key,
    required this.contentId,
    required this.contentType,
  });

  @override
  State<PlayMovieScreen> createState() => _PlayMovieScreenState();
}

class _PlayMovieScreenState extends State<PlayMovieScreen> {
  final OttController controller = Get.find<OttController>();

  // 🔹 Session-level cache: videoId -> resolved stream URL (avoids re-fetching manifest)
  static final Map<String, String> _streamUrlCache = {};

  VideoPlayerController? _videoController;
  bool _isVideoLoading = false;
  bool _hasVideoError = false;
  bool _isFullScreen = false;

  // 🔹 Custom controls state
  bool _showControls = true;
  bool _isMuted = false;
  Timer? _hideControlsTimer;

  @override
  void initState() {
    super.initState();
    controller.fetchContentDetail(
      id: widget.contentId,
      contentType: widget.contentType,
    );
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    _videoController?.removeListener(_onVideoTick);
    _videoController?.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _onVideoTick() {
    // Rebuild to keep progress bar / play-pause icon in sync
    if (mounted) setState(() {});
  }

  /// 🔹 Extract YouTube video ID from any YouTube URL
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

  /// 🔹 Fetch stream URL (cached) via youtube_explode_dart and init video_player
  Future<void> _initVideo(String videoUrl) async {
    final videoId = _extractYouTubeId(videoUrl);
    if (videoId == null) {
      setState(() => _hasVideoError = true);
      return;
    }

    setState(() {
      _isVideoLoading = true;
      _hasVideoError = false;
    });

    try {
      String? resolvedUrl = _streamUrlCache[videoId];

      if (resolvedUrl == null) {
        final yt = YoutubeExplode();
        try {
          final manifest = await yt.videos.streamsClient.getManifest(videoId);

          // 🔹 Pick a lighter stream (max 720p) instead of the absolute
          // highest bitrate — much faster to start & buffer smoothly.
          final muxedStreams = manifest.muxed.sortByVideoQuality();
          final streamInfo = muxedStreams.firstWhere(
                (s) => (s.videoResolution.height) <= 720,
            orElse: () => muxedStreams.first, // fallback: best available
          );

          resolvedUrl = streamInfo.url.toString();
          _streamUrlCache[videoId] = resolvedUrl;
        } finally {
          yt.close();
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

  /// 🔹 Seek forward/backward by given offset (clamped within video bounds)
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

  @override
  Widget build(BuildContext context) {
    if (_isFullScreen) {
      return _buildFullScreenPlayer();
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(),
      body: Obx(() {
        if (controller.isDetailLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.red),
          );
        }

        final content = controller.selectedContent.value;

        if (content == null) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, color: Colors.grey, size: 60),
                SizedBox(height: 12),
                Text(
                  'Failed to load content',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                  image: (_videoController == null && !_isVideoLoading)
                      ? DecorationImage(
                    image: NetworkImage(content.thumbnailHorizontal),
                    fit: BoxFit.cover,
                    onError: (_, __) {},
                  )
                      : null,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _buildPlayerArea(content),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        content.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _chip(Icons.star, content.rating, Colors.amber),
                          if (content.duration != null &&
                              content.duration!.isNotEmpty)
                            _chip(Icons.access_time, content.duration!,
                                Colors.white),
                          if (content.language != null &&
                              content.language!.isNotEmpty)
                            _chip(Icons.language,
                                content.language!.toUpperCase(), Colors.white),
                          if (content.releaseDate != null &&
                              content.releaseDate!.isNotEmpty)
                            _chip(Icons.calendar_today,
                                content.releaseDate!, Colors.white),
                          _chip(Icons.category,
                              content.contentType.toUpperCase(), Colors.white),
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (content.description != null &&
                          content.description!.isNotEmpty) ...[
                        Row(
                          spacing: 10,
                          children: [
                            Container(color: Colors.red, height: 14, width: 3),
                            const Text(
                              'Overview',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          content.description!,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),
                      Row(
                        spacing: 10,
                        children: [
                          Container(color: Colors.red, height: 14, width: 3),
                          const Text(
                            'Details',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _detailRow('Content Type', content.contentType),
                      if (content.language != null &&
                          content.language!.isNotEmpty)
                        _detailRow('Language', content.language!),
                      if (content.duration != null &&
                          content.duration!.isNotEmpty)
                        _detailRow('Duration', content.duration!),
                      if (content.releaseDate != null &&
                          content.releaseDate!.isNotEmpty)
                        _detailRow('Release Date', content.releaseDate!),
                      _detailRow('Rating', content.rating),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  /// Player area: thumbnail+play button -> loading -> video (with full controls)
  Widget _buildPlayerArea(dynamic content) {
    if (_hasVideoError) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Container(color: Colors.grey.shade200,),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 40),
              const SizedBox(height: 8),
              const Text(
                'Failed to load video',
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  final url = content.videoUrl;
                  if (url != null && url.isNotEmpty) {
                    _initVideo(url);
                  }
                },
                child: const Text('Retry'),
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

    // Thumbnail + Play button (initial state)
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
              final url = content.videoUrl;
              if (url == null || url.isEmpty) {
                FlutterToast.error("No video URL available");
                return;
              }

              final id = _extractYouTubeId(url);
              if (id == null) {
                FlutterToast.error("Not a valid YouTube URL");
                return;
              }

              _initVideo(url);
            },
            icon: const Icon(
              Icons.play_circle_fill,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  /// 🔹 Full custom control set: rewind/forward, play/pause, seek bar, time, mute, fullscreen
  Widget _buildVideoWithControls({required bool isFullScreen}) {
    final value = _videoController!.value;
    final isBuffering = value.isBuffering;

    return GestureDetector(
      onTap: _toggleControlsVisibility,
      onDoubleTapDown: (details) {
        // 🔹 Double-tap left half = rewind 10s, right half = forward 10s
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

          // Video (pinch-to-zoom)
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


          // Dark gradient + controls overlay (fades in/out)
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
                    // Top row: mute button
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

                    // Center: rewind - play/pause - forward
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          iconSize: isFullScreen ? 44 : 34,
                          onPressed: () =>
                              _seekBy(const Duration(seconds: -10)),
                          icon: const Icon(
                            Icons.replay_10,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: isFullScreen ? 24 : 16),

                        isBuffering ?CircularProgressIndicator(color: Colors.red,):
                        IconButton(
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
                          onPressed: () =>
                              _seekBy(const Duration(seconds: 10)),
                          icon: const Icon(
                            Icons.forward_10,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),

                    // Bottom: seek bar + time + fullscreen
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
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
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                _formatDuration(value.duration),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
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

  /// 🔹 Fullscreen landscape player screen (with rotation + pinch zoom + controls)
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
          Icon(icon, size: 14, color: iconColor),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey[500], fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(8),
            ),
            child:  Text(
              '${widget.contentType}',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
    );
  }
}