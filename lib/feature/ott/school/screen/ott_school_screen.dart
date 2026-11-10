import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../controller/record_video_controller.dart';
import '../model/record_video_model.dart';

class OttSchoolScreen extends StatefulWidget {
  const OttSchoolScreen({super.key});

  @override
  State<OttSchoolScreen> createState() => _OttSchoolScreenState();
}

class _OttSchoolScreenState extends State<OttSchoolScreen> {
  final RecordVideoController controller = Get.put(RecordVideoController());

  // ================= VIDEO PLAYER STATE =================
  RecordVideoModel? _currentlyPlayingVideo;
  bool _isPlayerLoading = false;

  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  YoutubePlayerController? _ytController;

  @override
  void dispose() {
    _disposePlayer();
    super.dispose();
  }

  void _disposePlayer() {
    _videoController?.dispose();
    _chewieController?.dispose();
    _ytController?.close();
    _videoController = null;
    _chewieController = null;
    _ytController = null;
  }

  Future<void> _playVideo(RecordVideoModel video) async {
    // 1. UI update karo loading state ke sath
    setState(() {
      _currentlyPlayingVideo = video;
      _isPlayerLoading = true;
    });

    final url = video.videoUrl;
    final isYouTube = url.contains('youtube.com') || url.contains('youtu.be');

    try {
      if (isYouTube) {
        final videoId = YoutubePlayerController.convertUrlToId(url) ?? '';
        if (videoId.isEmpty) throw Exception("Invalid YouTube URL");

        // Agar pehle se YouTube player chal raha hai, to sirf naya video load karo
        if (_ytController != null) {
          // ✅ FIXED: loadVideoById ki jagah loadVideo use kiya
          await _ytController!.loadVideo(videoId);
          if (mounted) setState(() => _isPlayerLoading = false);
        } else {
          // Agar pehli baar YouTube play ho raha hai ya MP4 se switch hua hai
          _disposePlayer(); // Purana MP4 player dispose karo

          _ytController = YoutubePlayerController.fromVideoId(
            videoId: videoId,
            autoPlay: true,
            params: const YoutubePlayerParams(
              showFullscreenButton: true,
              showControls: true,
              // ✅ FIXED: useHybridComposition hata diya gaya hai
            ),
          );
          if (mounted) setState(() => _isPlayerLoading = false);
        }
      } else {
        // MP4 / Other Network Videos
        _disposePlayer();

        _videoController = VideoPlayerController.networkUrl(Uri.parse(url));
        await _videoController!.initialize();

        _chewieController = ChewieController(
          videoPlayerController: _videoController!,
          autoPlay: true,
          looping: false,
          aspectRatio: _videoController!.value.aspectRatio,
          errorBuilder: (context, errorMessage) {
            return Center(
              child: Text(errorMessage, style: const TextStyle(color: Colors.white)),
            );
          },
        );
        if (mounted) setState(() => _isPlayerLoading = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isPlayerLoading = false;
          _currentlyPlayingVideo = null;
        });
      }
      Get.snackbar(
        'Error',
        'Failed to load video. Invalid URL.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        final isClassSelected = controller.selectedClass.value != null;

        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
            leading: isClassSelected
                ? IconButton(
              onPressed: () {
                setState(() {
                  _currentlyPlayingVideo = null;
                });
                _disposePlayer();
                controller.clearSelection();
              },
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            )
                : null,
            automaticallyImplyLeading: false,
            title: Text(
              isClassSelected
                  ? '🎓 ${controller.selectedClass.value!.name}'
                  : '🎓 School',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: isClassSelected
              ? _buildVideoScreen(controller)
              : _buildClassSelection(controller),
        );
      }),
    );
  }

  // ==================== UI 1: CLASS SELECTION ====================
  Widget _buildClassSelection(RecordVideoController controller) {
    if (controller.isLoadingClasses.value) {
      return const Center(child: CircularProgressIndicator(color: Colors.orange));
    }

    if (controller.classes.isEmpty) {
      return Center(
        child: Text(
          "No Classes Found",
          style: TextStyle(color: Colors.grey[500], fontSize: 16),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Select Your Class',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Choose a class to see subject-wise videos',
              style: TextStyle(color: Colors.grey[500], fontSize: 13),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.1,
              ),
              itemCount: controller.classes.length,
              itemBuilder: (context, index) {
                final classItem = controller.classes[index];
                final isPrePrimary = index < 3;
                final isPrimary = index >= 3 && index < 8;
                final isMiddle = index >= 8 && index < 11;

                Color cardColor;
                IconData icon;
                if (isPrePrimary) {
                  cardColor = Colors.pink;
                  icon = Icons.child_care;
                } else if (isPrimary) {
                  cardColor = Colors.orange;
                  icon = Icons.school;
                } else if (isMiddle) {
                  cardColor = Colors.blue;
                  icon = Icons.menu_book;
                } else {
                  cardColor = Colors.purple;
                  icon = Icons.workspace_premium;
                }

                return GestureDetector(
                  onTap: () => controller.selectClass(classItem),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          cardColor.withOpacity(0.3),
                          cardColor.withOpacity(0.1),
                        ],
                      ),
                      border: Border.all(color: cardColor.withOpacity(0.5), width: 1.5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(icon, color: cardColor, size: 32),
                        const SizedBox(height: 8),
                        Text(
                          classItem.name,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${classItem.videoCount} videos',
                          style: TextStyle(color: Colors.grey[400], fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ==================== UI 2: VIDEO SCREEN ====================
  Widget _buildVideoScreen(RecordVideoController controller) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_currentlyPlayingVideo != null) _buildPlayerWidget(),
          const SizedBox(height: 16),
          _buildSubjectChips(controller),
          const SizedBox(height: 16),
          _buildVideoGrid(controller),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ==================== INLINE VIDEO PLAYER ====================
  Widget _buildPlayerWidget() {
    if (_currentlyPlayingVideo == null) return const SizedBox.shrink();

    final isYouTube = _currentlyPlayingVideo!.videoUrl.contains('youtube.com') ||
        _currentlyPlayingVideo!.videoUrl.contains('youtu.be');

    return Container(
      color: Colors.black,
      width: double.infinity,
      child: Column(
        children: [
          // Player Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _currentlyPlayingVideo!.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _currentlyPlayingVideo = null;
                    });
                    _disposePlayer();
                  },
                  icon: const Icon(Icons.close, color: Colors.white),
                )
              ],
            ),
          ),

          // Player Body
          _isPlayerLoading
              ? const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator(color: Colors.orange)),
          )
              : isYouTube
              ? (_ytController != null
              ? LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxWidth * (9 / 16), // 16:9 ratio
                child: YoutubePlayer(
                  controller: _ytController!,
                ),
              );
            },
          )
              : const SizedBox(
            height: 200,
            child: Center(child: Text("YouTube Player Error", style: TextStyle(color: Colors.red))),
          ))
              : (_videoController != null && _chewieController != null
              ? AspectRatio(
            aspectRatio: _videoController!.value.aspectRatio,
            child: Chewie(controller: _chewieController!),
          )
              : const SizedBox(
            height: 200,
            child: Center(child: Text("Video Player Error", style: TextStyle(color: Colors.red))),
          )),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSubjectChips(RecordVideoController controller) {
    if (controller.isLoadingSubjects.value) {
      return const Center(child: Padding(
        padding: EdgeInsets.all(8.0),
        child: CircularProgressIndicator(color: Colors.orange),
      ));
    }

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: controller.subjects.length + 1,
        itemBuilder: (context, index) {
          final isAll = index == 0;
          final subject = isAll ? null : controller.subjects[index - 1];
          final isSelected = isAll
              ? controller.selectedSubjectId.value == null
              : controller.selectedSubjectId.value == subject?.id;

          return GestureDetector(
            onTap: () => controller.selectSubject(isAll ? null : subject?.id),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.orange : Colors.grey[900],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? Colors.orange : Colors.grey[800]!,
                  width: 1,
                ),
              ),
              child: Text(
                isAll ? "All" : subject!.name,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVideoGrid(RecordVideoController controller) {
    if (controller.isLoadingVideos.value) {
      return const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(child: CircularProgressIndicator(color: Colors.orange)),
      );
    }

    if (controller.videos.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.video_library, color: Colors.grey[700], size: 64),
              const SizedBox(height: 16),
              Text(
                'No videos found',
                style: TextStyle(color: Colors.grey[500], fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.8,
        ),
        itemCount: controller.videos.length,
        itemBuilder: (context, index) {
          final video = controller.videos[index];
          final isPlaying = _currentlyPlayingVideo?.id == video.id;

          return GestureDetector(
            onTap: () => _playVideo(video),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.orange.shade800.withOpacity(0.2),
                    Colors.deepOrange.shade800.withOpacity(0.2),
                  ],
                ),
                border: Border.all(
                  color: isPlaying ? Colors.orange : Colors.orange.shade600.withOpacity(0.3),
                  width: isPlaying ? 2 : 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      child: Stack(
                        children: [
                          Image.network(
                            video.thumbnail,
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                height: 160,
                                width: double.infinity,
                                color: Colors.grey[900],
                                child: const Center(
                                  child: CircularProgressIndicator(color: Colors.orange),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 160,
                                width: double.infinity,
                                color: Colors.grey[800],
                                child: const Icon(
                                  Icons.play_circle_outline,
                                  color: Colors.orange,
                                  size: 50,
                                ),
                              );
                            },
                          ),
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color: isPlaying ? Colors.orange.withOpacity(0.3) : Colors.black.withOpacity(0.3),
                                borderRadius:
                                const BorderRadius.vertical(top: Radius.circular(12)),
                              ),
                              child: Center(
                                child: Icon(
                                  isPlaying ? Icons.pause_circle_filled : Icons.play_circle_outline,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            left: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                video.subjectName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '⏱ ${video.duration}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          video.title,
                          style: TextStyle(
                            color: isPlaying ? Colors.orange : Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              video.rating.toString(),
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  video.className,
                                  style: const TextStyle(
                                    color: Colors.orangeAccent,
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
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
          );
        },
      ),
    );
  }
}