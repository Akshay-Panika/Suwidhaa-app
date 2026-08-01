// lib/screens/ott/ott_home_screen.dart
import 'package:flutter/material.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'ott_video_player_screen.dart';
import 'ott_video_detail_screen.dart';

class OttHomeScreen extends StatefulWidget {
  const OttHomeScreen({super.key});

  @override
  State<OttHomeScreen> createState() => _OttHomeScreenState();
}

class _OttHomeScreenState extends State<OttHomeScreen> {
  final CarouselSliderController _carouselController = CarouselSliderController();
  int _currentBannerIndex = 0;

  // Banner Data with random network videos
  final List<Map<String, dynamic>> banners = [
    {
      'title': 'The Crown Season 6',
      'subtitle': 'The final season of the royal drama',
      'image': 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?q=80&w=600',
      'color': const Color(0xFFDB2777),
      'tag': '🔥 Trending Now',
      'videoUrl': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    },
    {
      'title': 'Money Heist',
      'subtitle': 'The ultimate heist series',
      'image': 'https://images.unsplash.com/photo-1574375927938-d5a98e8ffe85?q=80&w=600',
      'color': const Color(0xFFE53935),
      'tag': '⭐ Popular',
      'videoUrl': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
    },
    {
      'title': 'Marvel Movies',
      'subtitle': 'The complete MCU collection',
      'image': 'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?q=80&w=600',
      'color': const Color(0xFF1565C0),
      'tag': '🎬 New Release',
      'videoUrl': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
    },
    {
      'title': 'Anime Collection',
      'subtitle': 'Best anime series streaming now',
      'image': 'https://images.unsplash.com/photo-1542204165-65bf26472b9b?q=80&w=600',
      'color': const Color(0xFFFF6F00),
      'tag': '🎌 Anime',
      'videoUrl': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
    },
  ];

  // Video Categories
  final List<Map<String, dynamic>> categories = [
    {'name': 'Movies', 'icon': Icons.movie_rounded, 'color': const Color(0xFFDB2777)},
    {'name': 'TV Shows', 'icon': Icons.tv_rounded, 'color': const Color(0xFFE53935)},
    {'name': 'Web Series', 'icon': Icons.play_circle_rounded, 'color': const Color(0xFF9C27B0)},
    {'name': 'Anime', 'icon': Icons.animation_rounded, 'color': const Color(0xFFFF6F00)},
    {'name': 'Documentaries', 'icon': Icons.document_scanner_rounded, 'color': const Color(0xFF00BCD4)},
    {'name': 'Kids', 'icon': Icons.child_care_rounded, 'color': const Color(0xFFFF9800)},
    {'name': 'Sports', 'icon': Icons.sports_rounded, 'color': const Color(0xFF4CAF50)},
    {'name': 'Music', 'icon': Icons.music_note_rounded, 'color': const Color(0xFF9C27B0)},
  ];

  // Video Data with random network videos
  final List<Map<String, dynamic>> videos = [
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
      'category': 'Movies',
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
  ];

  final List<Map<String, dynamic>> continueWatching = [
    {
      'title': 'The Crown Season 5',
      'progress': 0.75,
      'thumbUrl': 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?q=80&w=200',
      'videoUrl': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    },
    {
      'title': 'Money Heist Part 5',
      'progress': 0.45,
      'thumbUrl': 'https://images.unsplash.com/photo-1574375927938-d5a98e8ffe85?q=80&w=200',
      'videoUrl': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
    },
    {
      'title': 'Marvel Avengers',
      'progress': 0.90,
      'thumbUrl': 'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?q=80&w=200',
      'videoUrl': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.black,
            surfaceTintColor: Colors.black,
            toolbarHeight: 70,
            leading: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.menu_rounded, color: Colors.white, size: 28),
            ),
            title: Row(
              children: [
                const Text(
                  'OTT',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFDB2777),
                  ),
                ),
                const SizedBox(width: 4),
                const Text(
                  'Stream',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.cast_rounded, color: Colors.white, size: 22),
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 22),
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ),
              ],
            ),
          ),

          // Banner Carousel
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CarouselSlider(
                      controller: _carouselController,
                      options: CarouselOptions(
                        height: 200,
                        viewportFraction: 1.0,
                        enableInfiniteScroll: true,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 5),
                        autoPlayAnimationDuration: const Duration(milliseconds: 800),
                        pauseAutoPlayOnTouch: true,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentBannerIndex = index;
                          });
                        },
                      ),
                      items: banners.map((banner) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OttVideoPlayerScreen(
                                  videoUrl: banner['videoUrl'],
                                  title: banner['title'],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  banner['color'],
                                  banner['color'].withOpacity(0.7),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Opacity(
                                    opacity: 0.15,
                                    child: Image.network(
                                      banner['image'],
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: -20,
                                  top: -20,
                                  child: Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.25),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          banner['tag'],
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        banner['title'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        banner['subtitle'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(25),
                                        ),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.play_arrow_rounded, color: Colors.black, size: 16),
                                            SizedBox(width: 4),
                                            Text(
                                              'Watch Now',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Positioned(
                    bottom: 14,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: banners.asMap().entries.map((entry) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: _currentBannerIndex == entry.key ? 28 : 8,
                          height: 6,
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: _currentBannerIndex == entry.key
                                ? Colors.white
                                : Colors.white.withOpacity(0.4),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Continue Watching
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.play_circle_rounded, color: Color(0xFFDB2777), size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Continue Watching',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: continueWatching.length,
                      itemBuilder: (context, index) {
                        final item = continueWatching[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OttVideoPlayerScreen(
                                  videoUrl: item['videoUrl'],
                                  title: item['title'],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: 200,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                        child: Image.network(
                                          item['thumbUrl'],
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) => Container(
                                            color: Colors.grey[800],
                                            child: const Icon(Icons.movie_rounded, color: Colors.grey, size: 40),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: LinearProgressIndicator(
                                          value: item['progress'],
                                          backgroundColor: Colors.white.withOpacity(0.2),
                                          color: const Color(0xFFDB2777),
                                          minHeight: 3,
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 8,
                                        right: 8,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(0.7),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            '${(item['progress'] * 100).round()}%',
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
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    item['title'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Categories
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.grid_view_rounded, color: Color(0xFFDB2777), size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Categories',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final cat = categories[index];
                        return GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 70,
                            margin: const EdgeInsets.only(right: 12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: cat['color'].withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Icon(
                                    cat['icon'],
                                    color: cat['color'],
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  cat['name'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Trending Videos
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.trending_up_rounded, color: Color(0xFFDB2777), size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Trending Now',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 250,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: videos.length,
                      itemBuilder: (context, index) {
                        final video = videos[index];
                        return _buildVideoCard(video);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Popular Movies
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.local_fire_department_rounded, color: Color(0xFFDB2777), size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Popular Movies',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 250,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: videos.length,
                      itemBuilder: (context, index) {
                        final video = videos[index];
                        return _buildVideoCard(video);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }

  Widget _buildVideoCard(Map<String, dynamic> video) {
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
        width: 160,
        margin: const EdgeInsets.only(right: 12),
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
                    if (video['badge'] != null)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            video['badge'],
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
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.play_arrow_rounded,
                              color: Color(0xFFDB2777),
                              size: 28,
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
                    maxLines: 1,
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