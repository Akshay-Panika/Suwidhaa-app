import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import '../../controller/ott_reel_controller.dart';
import '../../model/ott_reel_model.dart';

class OttReelScreen extends StatefulWidget {
  const OttReelScreen({super.key});

  @override
  State<OttReelScreen> createState() => _OttReelScreenState();
}

class _OttReelScreenState extends State<OttReelScreen> {
  final OttReelController controller = Get.put(OttReelController());
  final PageController _pageController = PageController();
  final RxInt currentIndex = 0.obs;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(),
      body: Obx(() {
        if (controller.isLoading.value && controller.reels.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        if (controller.reels.isEmpty) {
          return const Center(
            child: Text(
              'No reels available',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        return PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          itemCount: controller.reels.length,
          onPageChanged: (index) {
            currentIndex.value = index;
          },
          itemBuilder: (context, index) {
            final OttReelData reel = controller.reels[index];
            return Obx(
                  () => ReelPlayerItem(
                key: ValueKey(reel.id),
                youtubeUrl: reel.youtubeUrl,
                title: reel.title,
                isActive: currentIndex.value == index,
              ),
            );
          },
        );
      }),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      title: const Text(
        'Reels',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      automaticallyImplyLeading: false,
    );
  }
}

class ReelPlayerItem extends StatefulWidget {
  final String youtubeUrl;
  final String title;
  final bool isActive;

  const ReelPlayerItem({
    super.key,
    required this.youtubeUrl,
    required this.title,
    required this.isActive,
  });

  @override
  State<ReelPlayerItem> createState() => _ReelPlayerItemState();
}

class _ReelPlayerItemState extends State<ReelPlayerItem> {
  VideoPlayerController? _videoController;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadVideo();
  }

  Future<void> _loadVideo() async {
    try {
      final yt = YoutubeExplode();
      final videoId = _extractVideoId(widget.youtubeUrl);

      if (videoId == null) {
        setState(() => _hasError = true);
        return;
      }

      final manifest = await yt.videos.streamsClient.getManifest(videoId);
      final streamInfo = manifest.muxed.withHighestBitrate();

      yt.close();

      if (!mounted) return;

      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(streamInfo.url.toString()),
      );

      await _videoController!.initialize();
      _videoController!.setLooping(true);

      // 🔹 Listen for play/pause/buffering changes to update the overlay icon
      _videoController!.addListener(_onVideoTick);

      if (!mounted) return;

      setState(() => _isLoading = false);

      if (widget.isActive) {
        _videoController!.play();
      }
    } catch (e) {
      debugPrint('Video load error: $e');
      if (mounted) setState(() => _hasError = true);
    }
  }

  void _onVideoTick() {
    // Rebuild so the play/pause icon overlay stays in sync
    if (mounted) setState(() {});
  }

  @override
  void didUpdateWidget(covariant ReelPlayerItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isActive != widget.isActive &&
        _videoController != null &&
        _videoController!.value.isInitialized) {
      if (widget.isActive) {
        _videoController!.play();
      } else {
        _videoController!.pause();
      }
    }
  }

  String? _extractVideoId(String url) {
    final shortsReg = RegExp(r'shorts\/([a-zA-Z0-9_-]{6,})');
    final watchReg = RegExp(r'[?&]v=([a-zA-Z0-9_-]{6,})');
    final shortUrlReg = RegExp(r'youtu\.be\/([a-zA-Z0-9_-]{6,})');

    final m1 = shortsReg.firstMatch(url);
    if (m1 != null) return m1.group(1);

    final m2 = watchReg.firstMatch(url);
    if (m2 != null) return m2.group(1);

    final m3 = shortUrlReg.firstMatch(url);
    if (m3 != null) return m3.group(1);

    return null;
  }

  @override
  void dispose() {
    _videoController?.removeListener(_onVideoTick);
    _videoController?.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_videoController == null || !_videoController!.value.isInitialized) {
      return;
    }
    setState(() {
      _videoController!.value.isPlaying
          ? _videoController!.pause()
          : _videoController!.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isPlaying = _videoController?.value.isPlaying ?? false;
    final isInitialized = _videoController?.value.isInitialized ?? false;

    return GestureDetector(
      onTap: _togglePlayPause,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(color: Colors.black),
          if (_hasError)
            const Center(
              child: Text(
                'Video load failed',
                style: TextStyle(color: Colors.white),
              ),
            )
          else if (_isLoading || _videoController == null)
            const Center(
              child: CircularProgressIndicator(color: Colors.red),
            )
          else
            Center(
              child: AspectRatio(
                aspectRatio: _videoController!.value.aspectRatio,
                child: VideoPlayer(_videoController!),
              ),
            ),

          // 🔹 Play/Pause icon overlay — shown whenever the video is paused
          if (isInitialized && !isPlaying && !_hasError)
            const Center(
              child: Icon(
                Icons.play_arrow,
                color: Colors.white70,
                size: 70,
              ),
            ),

          Positioned(
            left: 14,
            right: 70,
            bottom: 24,
            child: Text(
              widget.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}