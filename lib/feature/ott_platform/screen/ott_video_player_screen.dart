// lib/screens/ott/ott_video_player_screen.dart
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class OttVideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  final String title;

  const OttVideoPlayerScreen({
    super.key,
    required this.videoUrl,
    required this.title,
  });

  @override
  State<OttVideoPlayerScreen> createState() => _OttVideoPlayerScreenState();
}

class _OttVideoPlayerScreenState extends State<OttVideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _showControls = true;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
    );

    _controller.addListener(() {
      setState(() {
        _currentPosition = _controller.value.position;
        _totalDuration = _controller.value.duration;
      });
    });

    _controller.initialize().then((_) {
      setState(() {
        _isInitialized = true;
        _isPlaying = true;
        _totalDuration = _controller.value.duration;
      });
      _controller.play();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
      _isPlaying = !_isPlaying;
    });
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  String _formatDuration(Duration duration) {
    if (duration == Duration.zero) return "00:00";
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isInitialized
          ? GestureDetector(
        onTap: _toggleControls,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Video Player
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),

            // Controls Overlay
            if (_showControls) ...[
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.5),
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withOpacity(0.5),
                    ],
                    stops: const [0.0, 0.3, 0.7, 1.0],
                  ),
                ),
              ),

              // Top Controls
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 24),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.cast_rounded, color: Colors.white),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Center Play/Pause Button
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: _togglePlayPause,
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom Controls
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Progress Bar
                        Row(
                          children: [
                            Text(
                              _formatDuration(_currentPosition),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            Expanded(
                              child: Slider(
                                value: _totalDuration.inMilliseconds > 0
                                    ? _currentPosition.inMilliseconds / _totalDuration.inMilliseconds
                                    : 0,
                                onChanged: (value) {
                                  final newPosition = _totalDuration * value;
                                  _controller.seekTo(newPosition);
                                },
                                activeColor: const Color(0xFFDB2777),
                                inactiveColor: Colors.white.withOpacity(0.3),
                              ),
                            ),
                            Text(
                              _formatDuration(_totalDuration),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Bottom Controls Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Left Controls
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.repeat_rounded, color: Colors.white, size: 22),
                                  onPressed: () {
                                    setState(() {
                                      _controller.setLooping(!_controller.value.isLooping);
                                    });
                                  },
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: const Icon(Icons.volume_up_rounded, color: Colors.white, size: 22),
                                  onPressed: () {},
                                ),
                              ],
                            ),

                            // Center Controls
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.skip_previous_rounded, color: Colors.white, size: 28),
                                  onPressed: () {},
                                ),
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFDB2777),
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                    onPressed: _togglePlayPause,
                                    padding: EdgeInsets.zero,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.skip_next_rounded, color: Colors.white, size: 28),
                                  onPressed: () {},
                                ),
                              ],
                            ),

                            // Right Controls
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.fullscreen_rounded, color: Colors.white, size: 22),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  icon: const Icon(Icons.more_horiz_rounded, color: Colors.white, size: 22),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      )
          : const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Color(0xFFDB2777),
            ),
            SizedBox(height: 16),
            Text(
              'Loading Video...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}