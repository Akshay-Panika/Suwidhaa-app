import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart'; // ✅ Added Shimmer Import
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

  // ✅ Common Refresh Function
  Future<void> _handleRefresh() async {
    await controller.fetchReels();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: Colors.red,              // Spinner color
        backgroundColor: Colors.black,  // Spinner background color
        child: Obx(() {
          // 1. LOADING STATE (SHIMMER)
          if (controller.isLoading.value && controller.reels.isEmpty) {
            return _buildShimmerReel();
          }

          // 2. EMPTY STATE
          if (controller.reels.isEmpty) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.movie_creation_outlined, size: 50, color: Colors.grey),
                      const SizedBox(height: 12),
                      const Text(
                        "No Reels",
                        style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 16),
                      // Extra refresh button for empty state
                      ElevatedButton.icon(
                        onPressed: _handleRefresh,
                        icon: const Icon(Icons.refresh),
                        label: const Text("Refresh"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }

          // 3. PAGE VIEW (VIDEOS)
          return PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            physics: const AlwaysScrollableScrollPhysics(), // ✅ Pull to refresh enable karta hai
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
      ),
    );
  }

  // ==================== SHIMMER REEL (SKELETON) ====================
  Widget _buildShimmerReel() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.85, // Fill most of the screen
        child: Shimmer.fromColors(
          baseColor: Colors.grey[900]!,
          highlightColor: Colors.grey[700]!,
          child: Container(
            color: Colors.black, // Background
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Mock Video Area (Full Screen)
                Container(
                  color: Colors.white, // Gets masked by shimmer
                ),
                // Mock Play Icon in center
                const Center(
                  child: Icon(
                    Icons.play_arrow,
                    color: Colors.black12,
                    size: 70,
                  ),
                ),
                // Mock Title Text at bottom left (same layout as real reel)
                Positioned(
                  left: 14,
                  right: 70,
                  bottom: 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
      actions: [
        // ✅ AppBar me manual refresh button (web/desktop ke liye best)
        IconButton(
          onPressed: _handleRefresh,
          icon: const Icon(Icons.refresh, color: Colors.white),
          tooltip: 'Refresh Reels',
        ),
      ],
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
          // Reel ke andar ka loading state (Sirf video init hone tak)
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