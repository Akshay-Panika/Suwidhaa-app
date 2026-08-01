// lib/screens/ott/ott_category_screen.dart
import 'package:flutter/material.dart';

import 'ott_video_detail_screen.dart';

class OttCategoryScreen extends StatefulWidget {
  const OttCategoryScreen({super.key});

  @override
  State<OttCategoryScreen> createState() => _OttCategoryScreenState();
}

class _OttCategoryScreenState extends State<OttCategoryScreen> {
  String _selectedCategory = 'All';

  final List<Map<String, dynamic>> categories = [
    {'name': 'All', 'icon': Icons.dashboard_rounded, 'color': const Color(0xFFDB2777)},
    {'name': 'Movies', 'icon': Icons.movie_rounded, 'color': const Color(0xFFE53935)},
    {'name': 'TV Shows', 'icon': Icons.tv_rounded, 'color': const Color(0xFF1565C0)},
    {'name': 'Web Series', 'icon': Icons.play_circle_rounded, 'color': const Color(0xFF9C27B0)},
    {'name': 'Anime', 'icon': Icons.animation_rounded, 'color': const Color(0xFFFF6F00)},
    {'name': 'Documentaries', 'icon': Icons.document_scanner_rounded, 'color': const Color(0xFF00BCD4)},
    {'name': 'Kids', 'icon': Icons.child_care_rounded, 'color': const Color(0xFFFF9800)},
    {'name': 'Sports', 'icon': Icons.sports_rounded, 'color': const Color(0xFF4CAF50)},
    {'name': 'Music', 'icon': Icons.music_note_rounded, 'color': const Color(0xFF9C27B0)},
    {'name': 'Comedy', 'icon': Icons.emoji_emotions_rounded, 'color': const Color(0xFFFF5722)},
    {'name': 'Action', 'icon': Icons.flash_on_rounded, 'color': const Color(0xFFD32F2F)},
    {'name': 'Drama', 'icon': Icons.theater_comedy_rounded, 'color': const Color(0xFF7B1FA2)},
  ];

  final List<Map<String, dynamic>> allVideos = [
    {
      'id': '1',
      'title': 'Big Buck Bunny',
      'year': '2024',
      'duration': '10:34',
      'quality': '4K',
      'views': '2.5M',
      'videoUrl': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      'thumbUrl': 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?q=80&w=300',
      'category': 'Movies',
      'genre': 'Animation',
      'rating': 4.8,
      'description': 'A large rabbit is bullied by three small animals, but plots to get revenge.',
      'cast': ['Big Buck', 'Bunny'],
      'director': 'Sacha Goedegebure',
      'releaseDate': '2024',
      'language': 'English',
      'subtitles': 'Hindi, Tamil, Telugu',
      'badge': 'Trending',
    },
    {
      'id': '2',
      'title': 'Elephants Dream',
      'year': '2023',
      'duration': '10:53',
      'quality': 'HD',
      'views': '1.8M',
      'videoUrl': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
      'thumbUrl': 'https://images.unsplash.com/photo-1574375927938-d5a98e8ffe85?q=80&w=300',
      'category': 'Movies',
      'genre': 'Sci-Fi',
      'rating': 4.5,
      'description': 'Emo and his friends explore a strange mechanical world.',
      'cast': ['Emo', 'Proog'],
      'director': 'Bassam Kurdali',
      'releaseDate': '2023',
      'language': 'English',
      'subtitles': 'Hindi, Tamil, Telugu',
      'badge': 'Popular',
    },
    {
      'id': '3',
      'title': 'For Bigger Blazes',
      'year': '2024',
      'duration': '15:00',
      'quality': '4K',
      'views': '3.2M',
      'videoUrl': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
      'thumbUrl': 'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?q=80&w=300',
      'category': 'TV Shows',
      'genre': 'Action',
      'rating': 4.9,
      'description': 'A thrilling action series with epic fight scenes.',
      'cast': ['Hero', 'Villain'],
      'director': 'John Doe',
      'releaseDate': '2024',
      'language': 'English',
      'subtitles': 'Hindi, Tamil, Telugu',
      'badge': 'New',
    },
    {
      'id': '4',
      'title': 'For Bigger Escapes',
      'year': '2023',
      'duration': '12:00',
      'quality': 'HD',
      'views': '1.2M',
      'videoUrl': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
      'thumbUrl': 'https://images.unsplash.com/photo-1542204165-65bf26472b9b?q=80&w=300',
      'category': 'Web Series',
      'genre': 'Adventure',
      'rating': 4.3,
      'description': 'An epic adventure of survival and escape.',
      'cast': ['John', 'Sarah'],
      'director': 'Jane Smith',
      'releaseDate': '2023',
      'language': 'English',
      'subtitles': 'Hindi, Tamil, Telugu',
      'badge': 'Trending',
    },
    {
      'id': '5',
      'title': 'For Bigger Fun',
      'year': '2024',
      'duration': '8:00',
      'quality': '4K',
      'views': '4.5M',
      'videoUrl': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
      'thumbUrl': 'https://images.unsplash.com/photo-1517604931442-7e0c8ed2963c?q=80&w=300',
      'category': 'Web Series',
      'genre': 'Comedy',
      'rating': 4.7,
      'description': 'A hilarious comedy series that will make you laugh.',
      'cast': ['Comic 1', 'Comic 2'],
      'director': 'Mike Johnson',
      'releaseDate': '2024',
      'language': 'English',
      'subtitles': 'Hindi, Tamil, Telugu',
      'badge': 'Popular',
    },
    {
      'id': '6',
      'title': 'For Bigger Joy',
      'year': '2023',
      'duration': '11:00',
      'quality': 'HD',
      'views': '2.1M',
      'videoUrl': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoy.mp4',
      'thumbUrl': 'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?q=80&w=300',
      'category': 'Anime',
      'genre': 'Animation',
      'rating': 4.6,
      'description': 'A heartwarming anime about friendship and joy.',
      'cast': ['Hero', 'Friend'],
      'director': 'Yuki Tanaka',
      'releaseDate': '2023',
      'language': 'Japanese',
      'subtitles': 'English, Hindi',
      'badge': 'New',
    },
    {
      'id': '7',
      'title': 'For Bigger Meltdown',
      'year': '2024',
      'duration': '14:00',
      'quality': '4K',
      'views': '5.1M',
      'videoUrl': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdown.mp4',
      'thumbUrl': 'https://images.unsplash.com/photo-1503614472-8c93d56e92ce?q=80&w=300',
      'category': 'Movies',
      'genre': 'Drama',
      'rating': 4.7,
      'description': 'A powerful drama about life and choices.',
      'cast': ['Actor 1', 'Actor 2'],
      'director': 'Jane Doe',
      'releaseDate': '2024',
      'language': 'English',
      'subtitles': 'Hindi, Tamil, Telugu',
      'badge': 'Trending',
    },
    {
      'id': '8',
      'title': 'Sintel',
      'year': '2010',
      'duration': '14:45',
      'quality': 'HD',
      'views': '1.9M',
      'videoUrl': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4',
      'thumbUrl': 'https://images.unsplash.com/photo-1517604931442-7e0c8ed2963c?q=80&w=300',
      'category': 'Movies',
      'genre': 'Fantasy',
      'rating': 4.4,
      'description': 'A young girl finds a dragon in the mountains.',
      'cast': ['Sintel', 'Dragon'],
      'director': 'Colin Levy',
      'releaseDate': '2010',
      'language': 'English',
      'subtitles': 'Hindi, Tamil, Telugu',
      'badge': 'Classic',
    },
    {
      'id': '9',
      'title': 'Tears of Steel',
      'year': '2012',
      'duration': '12:14',
      'quality': '4K',
      'views': '2.8M',
      'videoUrl': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4',
      'thumbUrl': 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?q=80&w=300',
      'category': 'Movies',
      'genre': 'Sci-Fi',
      'rating': 4.5,
      'description': 'A sci-fi thriller about robots and humanity.',
      'cast': ['Hero', 'Robot'],
      'director': 'Ian Hubert',
      'releaseDate': '2012',
      'language': 'English',
      'subtitles': 'Hindi, Tamil, Telugu',
      'badge': 'Popular',
    },
  ];

  List<Map<String, dynamic>> get filteredVideos {
    if (_selectedCategory == 'All') {
      return allVideos;
    }
    return allVideos.where((video) => video['category'] == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Categories',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Category Filter
          Container(
            height: 80,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                final isSelected = _selectedCategory == cat['name'];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = cat['name'];
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFDB2777) : Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          cat['icon'],
                          color: isSelected ? Colors.white : cat['color'],
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          cat['name'],
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Video Grid
          Expanded(
            child: filteredVideos.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox_rounded,
                    size: 64,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No videos in this category',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )
                : GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: filteredVideos.length,
              itemBuilder: (context, index) {
                final video = filteredVideos[index];
                return _buildVideoGridCard(video);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoGridCard(Map<String, dynamic> video) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OttVideoDetailScreen(video: video),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Stack(
                  children: [
                    Image.network(
                      video['thumbUrl'],
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[800],
                        child: const Icon(Icons.movie_rounded, color: Colors.grey, size: 40),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDB2777),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          video['quality'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star_rounded, color: Colors.amber, size: 12),
                            const SizedBox(width: 2),
                            Text(
                              video['rating'].toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          video['duration'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          gradient: LinearGradient(
                            begin: Alignment.center,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.transparent,
                              Colors.black.withOpacity(0.3),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.play_arrow_rounded,
                              color: Color(0xFFDB2777),
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video['title'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${video['year']} • ${video['views']} views',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}