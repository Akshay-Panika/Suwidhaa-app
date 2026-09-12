// lib/feature/ott_platform/screen/play_webseries_screen.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:untitled/core/widget/flutter_toast.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../controller/webseries_controller.dart';
import '../../model/webseries_model.dart';

class PlayWebSeriesScreen extends StatefulWidget {
  final int contentId;
  final String contentType;

  const PlayWebSeriesScreen({
    super.key,
    required this.contentId,
    required this.contentType,
  });

  @override
  State<PlayWebSeriesScreen> createState() => _PlayWebSeriesScreenState();
}

class _PlayWebSeriesScreenState extends State<PlayWebSeriesScreen> {
  final WebseriesController controller = Get.find<WebseriesController>();

  // 🔹 Session-level cache: videoId -> resolved stream URL
  static final Map<String, String> _streamUrlCache = {};

  VideoPlayerController? _videoController;
  bool _isVideoLoading = false;
  bool _hasVideoError = false;
  bool _isFullScreen = false;

  // 🔹 Custom controls state
  bool _showControls = true;
  bool _isMuted = false;
  Timer? _hideControlsTimer;

  // 🔹 Currently selected episode
  Episode? _currentEpisode;

  // 🔹 Prevent double auto-advance
  bool _advancing = false;

  @override
  void initState() {
    super.initState();
    controller.fetchWebseries();
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

  // =========================================================
  // VIDEO HELPERS (unchanged)
  // =========================================================

  void _onVideoTick() {
    if (!mounted) return;

    final v = _videoController?.value;
    if (v != null &&
        v.isInitialized &&
        !v.isPlaying &&
        v.position >= v.duration &&
        v.duration > Duration.zero &&
        !_advancing) {
      _playNextEpisode();
    }

    setState(() {});
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

  String? _youtubeThumbnail(String videoUrl) {
    final id = _extractYouTubeId(videoUrl);
    if (id == null) return null;
    return 'https://img.youtube.com/vi/$id/hqdefault.jpg';
  }

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
          final muxedStreams = manifest.muxed.sortByVideoQuality();
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
        _advancing = false;
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
    if (hours > 0) return '${two(hours)}:${two(minutes)}:${two(seconds)}';
    return '${two(minutes)}:${two(seconds)}';
  }

  // =========================================================
  // PLAYLIST LOGIC
  // =========================================================

  List<Episode> _allEpisodes(Webseries ws) {
    final list = <Episode>[];
    for (final s in ws.seasons) {
      list.addAll(s.episodes);
    }
    return list;
  }

  void _playEpisode(Episode episode, {bool showToast = true}) {
    if (episode.videoUrl.isEmpty) {
      FlutterToast.error('No video URL for this episode');
      return;
    }

    final id = _extractYouTubeId(episode.videoUrl);
    if (id == null) {
      FlutterToast.error('Not a valid YouTube URL');
      return;
    }

    setState(() => _currentEpisode = episode);
    _initVideo(episode.videoUrl);

    // if (showToast) {
    //   FlutterToast.success(
    //     'Now playing: S${_seasonNumberOf(episode)}E${episode.episodeNumber}',
    //   );
    // }
  }

  int _seasonNumberOf(Episode ep) {
    final ws = controller.getById(widget.contentId);
    if (ws == null) return 0;
    for (final s in ws.seasons) {
      if (s.id == ep.season) return s.seasonNumber;
    }
    return 0;
  }

  void _playNextEpisode() {
    if (_advancing) return;
    final ws = controller.getById(widget.contentId);
    if (ws == null || _currentEpisode == null) return;

    final all = _allEpisodes(ws);
    final currentIdx = all.indexWhere((e) => e.id == _currentEpisode!.id);
    if (currentIdx == -1 || currentIdx == all.length - 1) return;

    _advancing = true;
    final next = all[currentIdx + 1];
    _playEpisode(next, showToast: true);
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    if (_isFullScreen) return _buildFullScreenPlayer();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(),
      body: Obx(() {
        if (controller.isLoading.value && controller.webseriesList.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        final webseries = controller.getById(widget.contentId);

        if (webseries == null) {
          return const Center(
            child: Text(
              'Webseries not found',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        final episodes = _allEpisodes(webseries);

        if (_currentEpisode == null && episodes.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && _currentEpisode == null) {
              setState(() => _currentEpisode = episodes.first);
            }
          });
        }

        return Column(
          children: [
            // ✅ CHANGED: Player area — Movie-style card with rounded corners
            Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _buildPlayerArea(),
                ),
              ),
            ),

            // 📺 Now Playing bar
            _buildNowPlayingBar(webseries),

            // 📜 Playlist
            Expanded(
              flex: 2,
              child: RefreshIndicator(
                onRefresh: controller.refresh,
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 24),
                  children: [
                    if (webseries.description.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                        child: Text(
                          webseries.description,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),
                      ),

                    const SizedBox(height: 12),

                    if (webseries.seasons.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(
                          child: Text(
                            'No seasons available',
                            style: TextStyle(color: Colors.white54),
                          ),
                        ),
                      )
                    else
                      ...webseries.seasons.map(
                            (season) => _buildSeasonSection(season, webseries),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  // =========================================================
  // UI WIDGETS
  // =========================================================

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
            child: Text(
              widget.contentType.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 12),
          if (_currentEpisode != null)
            Expanded(
              child: Text(
                _currentEpisode!.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// 🎬 Player area — same as before, but inside rounded card
  Widget _buildPlayerArea() {
    if (_hasVideoError) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Container(color: Colors.grey.shade900),
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
                  if (_currentEpisode != null) {
                    _initVideo(_currentEpisode!.videoUrl);
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

    // Initial — thumbnail + play button
    final ws = controller.getById(widget.contentId);
    final epThumb = _currentEpisode != null
        ? _youtubeThumbnail(_currentEpisode!.videoUrl)
        : null;
    final thumb = epThumb ?? ws?.thumbnailHorizontal;

    return Stack(
      fit: StackFit.expand,
      children: [
        // ✅ CHANGED: Thumbnail via DecorationImage (Movie-style)
        if (thumb != null && thumb.isNotEmpty)
          DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(thumb),
                fit: BoxFit.cover,
                onError: (_, __) {},
              ),
            ),
          )
        else
          Container(color: Colors.grey[900]),

        Container(color: Colors.black.withOpacity(0.35)),

        Center(
          child: IconButton(
            iconSize: 70,
            onPressed: () {
              final ep = _currentEpisode ??
                  (_allEpisodes(ws!).isNotEmpty
                      ? _allEpisodes(ws).first
                      : null);
              if (ep == null) {
                FlutterToast.error('No episodes available');
                return;
              }
              _playEpisode(ep);
            },
            icon: const Icon(
              Icons.play_circle_fill,
              color: Colors.white,
            ),
          ),
        ),

        if (_currentEpisode != null)
          Positioned(
            left: 12,
            right: 12,
            bottom: 10,
            child: Text(
              'S${_seasonNumberOf(_currentEpisode!)} · '
                  'E${_currentEpisode!.episodeNumber} · '
                  '${_currentEpisode!.title}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                shadows: [Shadow(blurRadius: 4, color: Colors.black)],
              ),
            ),
          ),
      ],
    );
  }

  /// 🎥 Video with custom controls (unchanged)
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
                          onPressed: () =>
                              _seekBy(const Duration(seconds: -10)),
                          icon: const Icon(
                            Icons.replay_10,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: isFullScreen ? 24 : 16),
                        isBuffering
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
                          onPressed: () =>
                              _seekBy(const Duration(seconds: 10)),
                          icon: const Icon(
                            Icons.forward_10,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),

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

  /// 📺 Now Playing bar (unchanged)
  Widget _buildNowPlayingBar(Webseries ws) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: Colors.black,
      child: Row(
        children: [
          Container(width: 3, height: 32, color: Colors.red),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _currentEpisode == null
                      ? ws.title
                      : 'S${_seasonNumberOf(_currentEpisode!)} · '
                      'E${_currentEpisode!.episodeNumber}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _currentEpisode?.title ?? 'Select an episode to play',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          if (_currentEpisode != null)
            Builder(builder: (_) {
              final all = _allEpisodes(ws);
              final idx =
              all.indexWhere((e) => e.id == _currentEpisode!.id);
              final hasNext = idx != -1 && idx < all.length - 1;
              if (!hasNext) return const SizedBox.shrink();
              return IconButton(
                tooltip: 'Next episode',
                onPressed: _playNextEpisode,
                icon: const Icon(
                  Icons.skip_next,
                  color: Colors.white,
                  size: 28,
                ),
              );
            }),
        ],
      ),
    );
  }

  /// 📜 Season section (unchanged)
  Widget _buildSeasonSection(Season season, Webseries ws) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(width: 3, height: 16, color: Colors.red),
                const SizedBox(width: 8),
                Text(
                  season.title ?? 'Season ${season.seasonNumber}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '(${season.episodes.length} episodes)',
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ...season.episodes.map((ep) => _buildEpisodeTile(ep, season, ws)),
        ],
      ),
    );
  }

  /// 🎞️ Episode tile with VIDEO THUMBNAIL (unchanged)
  Widget _buildEpisodeTile(Episode episode, Season season, Webseries ws) {
    final isCurrent = _currentEpisode?.id == episode.id;

    final ytThumb = _youtubeThumbnail(episode.videoUrl);
    final thumb = ytThumb ?? ws.thumbnailHorizontal;

    return InkWell(
      onTap: () => _playEpisode(episode),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isCurrent
              ? Colors.grey.withOpacity(0.10)
              : Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isCurrent ? Colors.grey : Colors.white12,
            width: isCurrent ? 0.6 : 0.8,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🖼️ VIDEO THUMBNAIL (16:9)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 120,
                  height: 68,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (thumb != null && thumb.isNotEmpty)
                        Image.network(
                          thumb,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey[900],
                            child: const Icon(
                              Icons.movie_outlined,
                              color: Colors.white30,
                              size: 28,
                            ),
                          ),
                        )
                      else
                        Container(
                          color: Colors.grey[900],
                          child: const Icon(
                            Icons.movie_outlined,
                            color: Colors.white30,
                            size: 28,
                          ),
                        ),

                      Container(
                        color: isCurrent
                            ? Colors.red.withOpacity(0.20)
                            : Colors.black.withOpacity(0.35),
                      ),

                      Center(
                        child: Icon(
                          isCurrent
                              ? Icons.play_circle_fill
                              : Icons.play_circle_outline,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),

                      Positioned(
                        top: 4,
                        left: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: isCurrent ? Colors.red : Colors.black87,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'E${episode.episodeNumber}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      if (episode.duration.isNotEmpty)
                        Positioned(
                          bottom: 4,
                          right: 4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              episode.duration,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),

                      if (isCurrent)
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.equalizer,
                                    color: Colors.white, size: 10),
                                SizedBox(width: 2),
                                Text(
                                  'NOW',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'S${season.seasonNumber}E${episode.episodeNumber}',
                      style: TextStyle(
                        color: isCurrent ? Colors.red : Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      episode.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isCurrent ? Colors.red : Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (episode.description != null &&
                        episode.description!.isNotEmpty)
                      Text(
                        episode.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                          height: 1.3,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}