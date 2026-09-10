import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../controller/ott_controller.dart';
import '../../search/screen/search_movie_screen.dart';

class PlayListScreen extends StatefulWidget {
  final int contentId;
  final String contentType;

  const PlayListScreen({
    super.key,
    required this.contentId,
    required this.contentType,
  });

  @override
  State<PlayListScreen> createState() => _PlayListScreenState();
}

class _PlayListScreenState extends State<PlayListScreen> {
  final OttController controller = Get.find<OttController>();

  // 🔹 YouTube controller — created locally, no GetX needed
  YoutubePlayerController? _ytController;

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
    _ytController?.close();
    super.dispose();
  }

  /// 🔹 Extract YouTube video ID from any YouTube URL
  String? _extractYouTubeId(String url) {
    try {
      final uri = Uri.parse(url);

      // Case 1: https://youtu.be/VIDEO_ID
      if (uri.host.contains('youtu.be')) {
        return uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
      }

      // Case 2: https://www.youtube.com/watch?v=VIDEO_ID
      if (uri.host.contains('youtube.com')) {
        return uri.queryParameters['v'];
      }

      // Case 3: https://www.youtube.com/embed/VIDEO_ID
      if (uri.pathSegments.contains('embed')) {
        final idx = uri.pathSegments.indexOf('embed');
        if (idx + 1 < uri.pathSegments.length) {
          return uri.pathSegments[idx + 1];
        }
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  /// 🔹 Initialize the YouTube controller from content.videoUrl
  void _initYouTube(String videoUrl) {
    final videoId = _extractYouTubeId(videoUrl);
    if (videoId == null) return;

    _ytController = YoutubePlayerController.fromVideoId(
      videoId: videoId,
      autoPlay: true,
      params: const YoutubePlayerParams(
        // ✅ Supported in youtube_player_iframe 6.x
        showControls: true,
        showFullscreenButton: true,

        // ❌ Hide what we CAN hide
        enableCaption: false,         // CC button hidden
        strictRelatedVideos: true,    // Related videos restricted
        privacyEnhancedMode: true,    // Uses youtube-nocookie.com (no tracking)

        interfaceLanguage: 'en',
        color: 'white',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(context),
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
            // -------------------------------------------------
            // TOP AREA — Play button OR YouTube player
            // -------------------------------------------------
            Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                  image: _ytController == null
                      ? DecorationImage(
                    image: NetworkImage(content.thumbnailHorizontal),
                    fit: BoxFit.cover,
                    onError: (_, __) {},
                  )
                      : null,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _ytController != null
                  // 🔹 YouTube player (branding hidden)
                      ? YoutubePlayer(
                    controller: _ytController!,
                    aspectRatio: 16 / 9,
                  )
                  // 🔹 Thumbnail + Play button
                      : Stack(
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
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                const SnackBar(
                                  content:
                                  Text('No video URL available'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            final id = _extractYouTubeId(url);
                            if (id == null) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Not a valid YouTube URL'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            // 🔹 Start playing
                            setState(() {
                              _initYouTube(url);
                            });
                          },
                          icon: const Icon(
                            Icons.play_circle_fill,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // -------------------------------------------------
            // DETAILS
            // -------------------------------------------------
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
                        const Text(
                          'Overview',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
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
                      const Text(
                        'Details',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
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

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'OTT',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(8),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchMovieScreen(),
                    ),
                  );
                },
                child: const Row(
                  children: [
                    SizedBox(width: 12),
                    Icon(Icons.search, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Search...',
                      style: TextStyle(color: Colors.white, fontSize: 14),
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
}