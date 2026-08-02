import 'package:flutter/material.dart';
import '../../../core/utils/app_color.dart';

class OttPlatformVideoPlayScreen extends StatelessWidget {
  const OttPlatformVideoPlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.white,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios, color: Colors.black, size: 22),
        ),
        title: Text(
          "Now Playing",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.cast, color: Colors.black, size: 22),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert, color: Colors.black, size: 22),
          ),
        ],
      ),
      body: Column(
        children: [
          // Video Player
          Container(
            height: 220,
            width: double.infinity,
            color: Colors.grey[900],
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.network(
                  'https://picsum.photos/seed/video/800/400',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 220,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[900],
                      child: Icon(
                        Icons.play_circle_filled,
                        color: Colors.white.withOpacity(0.3),
                        size: 60,
                      ),
                    );
                  },
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.5),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => _showPlayDialog(context),
                  child: Container(
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.volume_up, color: Colors.white, size: 18),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                      ),
                      SizedBox(width: 6),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.fullscreen, color: Colors.white, size: 18),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: Row(
                      children: [
                        Text("15:30", style: TextStyle(color: Colors.white70, fontSize: 11)),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            height: 3,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 100,
                                  height: 3,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Text("45:00", style: TextStyle(color: Colors.white70, fontSize: 11)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Video Details
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Stranger Things - Season 4 Episode 3",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "TV Show",
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 14),
                            SizedBox(width: 3),
                            Text("4.8", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        SizedBox(width: 8),
                        Text("2022", style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                        SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Text(
                            "HD",
                            style: TextStyle(
                              fontSize: 9,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      "When a young boy disappears, his mother, a police chief, and his friends must confront terrifying supernatural forces.",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 14),
                    Text("Cast", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    SizedBox(height: 6),
                    Container(
                      height: 70,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: 6,
                        separatorBuilder: (context, index) => SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundImage: NetworkImage(
                                  'https://picsum.photos/seed/cast$index/200/200',
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                ['Millie', 'Finn', 'David', 'Winona', 'Gaten', 'Caleb'][index],
                                style: TextStyle(fontSize: 9, color: Colors.grey[700]),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Episodes", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                        TextButton(
                          onPressed: () {},
                          child: Text("See All", style: TextStyle(color: AppColors.primary, fontSize: 13)),
                        ),
                      ],
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 4,
                      separatorBuilder: (context, index) => Divider(height: 1),
                      itemBuilder: (context, index) {
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Container(
                            width: 80,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              image: DecorationImage(
                                image: NetworkImage('https://picsum.photos/seed/episode$index/200/200'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: Colors.black.withOpacity(0.3),
                                  ),
                                ),
                                Icon(Icons.play_arrow, color: Colors.white, size: 20),
                              ],
                            ),
                          ),
                          title: Text(
                            "Episode ${index + 1}",
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                          subtitle: Text(
                            "45 min • ${index % 2 == 0 ? 'Watch' : 'Watched'}",
                            style: TextStyle(
                              fontSize: 11,
                              color: index % 2 == 0 ? AppColors.primary : Colors.grey[600],
                            ),
                          ),
                          trailing: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.more_vert, color: Colors.grey[400], size: 18),
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                          ),
                          onTap: () => _showEpisodeDialog(context, index),
                        );
                      },
                    ),
                    SizedBox(height: 10),

                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _actionButton(Icons.favorite_border, "Favorite"),
                _actionButton(Icons.download_outlined, "Download"),
                _actionButton(Icons.share_outlined, "Share"),
              ],
            ),
          ),
          // SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _actionButton(IconData icon, String label) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          Icon(icon, color: Colors.black, size: 22),
          SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
        ],
      ),
    );
  }

  void _showPlayDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text("Play Video", style: TextStyle(fontSize: 16)),
        content: Text("Start playing this video?", style: TextStyle(fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(fontSize: 13)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Video is playing..."),
                  backgroundColor: AppColors.primary,
                  duration: Duration(seconds: 1),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: Text("Play Now", style: TextStyle(fontSize: 13)),
          ),
        ],
      ),
    );
  }

  void _showEpisodeDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text("Episode ${index + 1}", style: TextStyle(fontSize: 16)),
        content: Text("Do you want to watch Episode ${index + 1}?", style: TextStyle(fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(fontSize: 13)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Playing Episode ${index + 1}..."),
                  backgroundColor: AppColors.primary,
                  duration: Duration(seconds: 1),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: Text("Watch", style: TextStyle(fontSize: 13)),
          ),
        ],
      ),
    );
  }
}