import 'package:flutter/material.dart';
import 'package:untitled/core/utils/app_color.dart';

class OttPlatformReelScreen extends StatefulWidget {
  const OttPlatformReelScreen({super.key});

  @override
  State<OttPlatformReelScreen> createState() => _OttPlatformReelScreenState();
}

class _OttPlatformReelScreenState extends State<OttPlatformReelScreen> {
  // Sample reel data
  final List<Map<String, dynamic>> reels = [
    {
      'username': 'netflix_official',
      'title': 'Stranger Things Behind the Scenes',
      'likes': '15.2K',
      'comments': '1.2K',
      'image': 'https://picsum.photos/seed/reel1/400/700',
    },
    {
      'username': 'prime_video',
      'title': 'The Boys - New Season Teaser',
      'likes': '12.8K',
      'comments': '890',
      'image': 'https://picsum.photos/seed/reel2/400/700',
    },
    {
      'username': 'disney_plus',
      'title': 'Marvel Studios - Behind the Magic',
      'likes': '18.5K',
      'comments': '2.1K',
      'image': 'https://picsum.photos/seed/reel3/400/700',
    },
    {
      'username': 'hbo_max',
      'title': 'House of Dragons - Cast Interview',
      'likes': '9.8K',
      'comments': '654',
      'image': 'https://picsum.photos/seed/reel4/400/700',
    },
    {
      'username': 'ott_platform',
      'title': 'Top 10 Movies This Month',
      'likes': '22.3K',
      'comments': '3.4K',
      'image': 'https://picsum.photos/seed/reel5/400/700',
    },
  ];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.white,
        title: Text(
          "Reels",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.more_vert, color: Colors.black, size: 24),
          ),
        ],
      ),
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: reels.length,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return _buildReelItem(reels[index], index);
        },
      ),
    );
  }

  Widget _buildReelItem(Map<String, dynamic> reel, int index) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Video/Image Background
        Image.network(
          reel['image'],
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[900],
              child: Center(
                child: Icon(
                  Icons.play_circle_filled,
                  color: Colors.white.withOpacity(0.2),
                  size: 80,
                ),
              ),
            );
          },
        ),

        // Gradient Overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),
        ),

        // Progress Indicator (Top)
        Positioned(
          top: 10,
          left: 0,
          right: 0,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: List.generate(reels.length, (i) {
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 3),
                    height: 2,
                    decoration: BoxDecoration(
                      color: i == currentIndex
                          ? Colors.white
                          : Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),

        // Content - Bottom
        Positioned(
          left: 0,
          right: 0,
          bottom: 20,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Left Content - User Info & Title
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // User Info
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundImage: NetworkImage(
                              'https://picsum.photos/seed/user$index/200/200',
                            ),
                            onBackgroundImageError: (e, s) {},
                          ),
                          SizedBox(width: 10),
                          Text(
                            reel['username'],
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(width: 8),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "Follow",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 6),

                      // Title
                      Text(
                        reel['title'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: 10),

                      // Music/Sound
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.music_note,
                              color: Colors.white,
                              size: 14,
                            ),
                            SizedBox(width: 4),
                            Text(
                              "Trending Sound",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Right Content - Action Buttons
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _actionButton(
                      icon: Icons.favorite,
                      label: reel['likes'],
                      color: Colors.red,
                      onTap: () {
                        _showSnackbar(context, 'Liked!');
                      },
                    ),
                    _actionButton(
                      icon: Icons.comment,
                      label: reel['comments'],
                      color: Colors.white,
                      onTap: () {
                        _showSnackbar(context, 'Comments');
                      },
                    ),
                    _actionButton(
                      icon: Icons.share,
                      label: '',
                      color: Colors.white,
                      onTap: () {
                        _showSnackbar(context, 'Share');
                      },
                    ),
                    _actionButton(
                      icon: Icons.more_vert,
                      label: '',
                      color: Colors.white,
                      onTap: () {
                        _showSnackbar(context, 'More options');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 22,
              ),
            ),
            if (label.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.primary,
        duration: Duration(seconds: 1),
      ),
    );
  }
}