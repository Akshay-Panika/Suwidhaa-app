// main.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';



// ==================== DATA MODELS ====================
class Movie {
  final String id;
  final String title;
  final String year;
  final String rating;
  final String duration;
  final String category;
  final String description;
  final String thumbnailUrl;
  final String bannerUrl;
  final String videoUrl;
  final List<String> genres;
  final bool isNew;
  final bool isTrending;
  final bool isRecommended;

  Movie({
    required this.id,
    required this.title,
    required this.year,
    required this.rating,
    required this.duration,
    required this.category,
    required this.description,
    required this.thumbnailUrl,
    required this.bannerUrl,
    required this.videoUrl,
    required this.genres,
    this.isNew = false,
    this.isTrending = false,
    this.isRecommended = false,
  });
}

// ==================== SAMPLE DATA ====================
class MovieData {
  static final List<Movie> movies = [
    Movie(
      id: '1',
      title: 'The Last Kingdom',
      year: '2024',
      rating: '4.9',
      duration: '2h 15m',
      category: 'Action',
      description: 'In a world of chaos and war, one man rises to unite his people and reclaim his homeland.',
      thumbnailUrl: 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?w=400',
      bannerUrl: 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?w=1200',
      videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      genres: ['Action', 'Drama', 'History'],
      isNew: true,
      isTrending: true,
      isRecommended: true,
    ),
    Movie(
      id: '2',
      title: 'Cyber City 2077',
      year: '2024',
      rating: '4.8',
      duration: '2h 30m',
      category: 'Sci-Fi',
      description: 'In a neon-lit future, a hacker discovers the dark secrets behind the city\'s AI overlords.',
      thumbnailUrl: 'https://images.unsplash.com/photo-1541701494587-cb58502866ab?w=400',
      bannerUrl: 'https://images.unsplash.com/photo-1541701494587-cb58502866ab?w=1200',
      videoUrl: 'https://www.w3schools.com/html/mov_bbb.mp4',
      genres: ['Sci-Fi', 'Thriller', 'Cyberpunk'],
      isNew: true,
      isTrending: true,
    ),
    Movie(
      id: '3',
      title: 'Ocean\'s Secret',
      year: '2023',
      rating: '4.7',
      duration: '1h 55m',
      category: 'Adventure',
      description: 'A marine biologist discovers an ancient civilization beneath the ocean depths.',
      thumbnailUrl: 'https://images.unsplash.com/photo-1518837695005-2083093ee35b?w=400',
      bannerUrl: 'https://images.unsplash.com/photo-1518837695005-2083093ee35b?w=1200',
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
      genres: ['Adventure', 'Fantasy', 'Mystery'],
      isRecommended: true,
    ),
    Movie(
      id: '4',
      title: 'The Silent Voice',
      year: '2024',
      rating: '4.9',
      duration: '1h 45m',
      category: 'Drama',
      description: 'A powerful story of redemption and the healing power of human connection.',
      thumbnailUrl: 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=400',
      bannerUrl: 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=1200',
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
      genres: ['Drama', 'Romance', 'Family'],
      isNew: true,
      isRecommended: true,
    ),
    Movie(
      id: '5',
      title: 'Galaxy Warriors',
      year: '2023',
      rating: '4.6',
      duration: '2h 10m',
      category: 'Action',
      description: 'An elite team of soldiers must defend the galaxy from an ancient alien threat.',
      thumbnailUrl: 'https://images.unsplash.com/photo-1519681393784-d120267933ba?w=400',
      bannerUrl: 'https://images.unsplash.com/photo-1519681393784-d120267933ba?w=1200',
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
      genres: ['Action', 'Sci-Fi', 'Adventure'],
      isTrending: true,
    ),
    Movie(
      id: '6',
      title: 'Midnight Stories',
      year: '2024',
      rating: '4.8',
      duration: '1h 30m',
      category: 'Thriller',
      description: 'A collection of interconnected horror stories that will keep you up at night.',
      thumbnailUrl: 'https://images.unsplash.com/photo-1509248961158-e54f6934749c?w=400',
      bannerUrl: 'https://images.unsplash.com/photo-1509248961158-e54f6934749c?w=1200',
      videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      genres: ['Thriller', 'Horror', 'Mystery'],
      isNew: true,
    ),
    Movie(
      id: '7',
      title: 'Jungle Book Reimagined',
      year: '2024',
      rating: '4.5',
      duration: '1h 50m',
      category: 'Animation',
      description: 'A fresh take on the classic tale of Mowgli and his animal friends in the jungle.',
      thumbnailUrl: 'https://images.unsplash.com/photo-1470071459604-7b8ec44ff4d1?w=400',
      bannerUrl: 'https://images.unsplash.com/photo-1470071459604-7b8ec44ff4d1?w=1200',
      videoUrl: 'https://www.w3schools.com/html/mov_bbb.mp4',
      genres: ['Animation', 'Family', 'Adventure'],
      isRecommended: true,
    ),
    Movie(
      id: '8',
      title: 'The Detective\'s Code',
      year: '2023',
      rating: '4.7',
      duration: '2h 00m',
      category: 'Crime',
      description: 'A brilliant detective must solve a series of murders that seem connected to his past.',
      thumbnailUrl: 'https://images.unsplash.com/photo-1519681393784-d120267933ba?w=400',
      bannerUrl: 'https://images.unsplash.com/photo-1519681393784-d120267933ba?w=1200',
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
      genres: ['Crime', 'Drama', 'Mystery'],
      isTrending: true,
    ),
  ];

  static final List<String> categories = [
    'All',
    'Action',
    'Adventure',
    'Animation',
    'Crime',
    'Drama',
    'Sci-Fi',
    'Thriller',
  ];
}

// ==================== NETFLIX HOME SCREEN ====================
class NetflixHomeScreen extends StatefulWidget {
  const NetflixHomeScreen({super.key});

  @override
  State<NetflixHomeScreen> createState() => _NetflixHomeScreenState();
}

class _NetflixHomeScreenState extends State<NetflixHomeScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  int _selectedCategory = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<String> navItems = ['Home', 'Movies', 'TV Shows', 'My List'];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: _buildBody(),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 1:
        return _buildMoviesTab();
      case 2:
        return _buildTVShowsTab();
      case 3:
        return _buildMyListTab();
      default:
        return _buildHomeTab();
    }
  }

  Widget _buildBottomNav() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.95),
          ],
        ),
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        selectedItemColor: const Color(0xFFE50914),
        unselectedItemColor: Colors.grey.shade600,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 11,
          letterSpacing: 0.5,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 11,
          letterSpacing: 0.3,
        ),
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded, size: 26),
            activeIcon: Icon(Icons.home_rounded, size: 28),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.movie_rounded, size: 26),
            activeIcon: Icon(Icons.movie_rounded, size: 28),
            label: 'Movies',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tv_rounded, size: 26),
            activeIcon: Icon(Icons.tv_rounded, size: 28),
            label: 'TV Shows',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_rounded, size: 26),
            activeIcon: Icon(Icons.favorite_rounded, size: 28),
            label: 'My List',
          ),
        ],
      ),
    );
  }

  // ==================== HOME TAB ====================
  Widget _buildHomeTab() {
    final featuredMovie = MovieData.movies[0];
    final trendingMovies = MovieData.movies.where((m) => m.isTrending).toList();
    final newMovies = MovieData.movies.where((m) => m.isNew).toList();
    final recommendedMovies = MovieData.movies.where((m) => m.isRecommended).toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildCategoryRow(),
          const SizedBox(height: 12),
          _buildHeroSection(featuredMovie),
          const SizedBox(height: 28),
          _buildSectionHeader('Continue Watching', 'See All'),
          _buildContinueWatching(),
          const SizedBox(height: 28),
          _buildSectionHeader('🔥 Trending Now', 'See All'),
          _buildHorizontalScroll(trendingMovies),
          const SizedBox(height: 28),
          _buildSectionHeader('✨ New Releases', 'See All'),
          _buildHorizontalScroll(newMovies),
          const SizedBox(height: 28),
          _buildSectionHeader('⭐ Recommended for You', 'See All'),
          _buildHorizontalScroll(recommendedMovies),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFE50914),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFE50914).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.play_arrow_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'OTTFlix',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                'Watch anywhere, anytime',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 11,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.search_rounded, color: Colors.white, size: 22),
              onPressed: () {},
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 22),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryRow() {
    return Container(
      height: 42,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: MovieData.categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = index == _selectedCategory;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFE50914) : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? const Color(0xFFE50914) : Colors.grey.shade800,
                  width: 1.5,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                MovieData.categories[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey.shade400,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 13,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ==================== HERO SECTION ====================
  Widget _buildHeroSection(Movie movie) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () => _navigateToPlayer(movie),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.width * 0.56,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(movie.bannerUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.width * 0.56,
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
              Positioned(
                left: 20,
                right: 20,
                bottom: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE50914),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'NEW RELEASE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              movie.rating,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            movie.year,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      movie.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        letterSpacing: 0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      movie.description,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 13,
                        letterSpacing: 0.3,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        _buildActionButton(
                          icon: Icons.play_arrow_rounded,
                          label: 'Play',
                          isPrimary: true,
                          onTap: () => _navigateToPlayer(movie),
                        ),
                        const SizedBox(width: 12),
                        _buildActionButton(
                          icon: Icons.add_rounded,
                          label: 'My List',
                          isPrimary: false,
                          onTap: () {},
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
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required bool isPrimary,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isPrimary ? const Color(0xFFE50914) : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: isPrimary ? null : Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isPrimary ? Colors.white : Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isPrimary ? Colors.white : Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== SECTION HEADER ====================
  Widget _buildSectionHeader(String title, String action) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Row(
              children: [
                Text(
                  action,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== CONTINUE WATCHING ====================
  Widget _buildContinueWatching() {
    final movies = MovieData.movies.take(3).toList();
    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: movies.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final movie = movies[index];
          return GestureDetector(
            onTap: () => _navigateToPlayer(movie),
            child: Container(
              width: 200,
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      movie.thumbnailUrl,
                      width: 80,
                      height: 110,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 80,
                        height: 110,
                        color: Colors.grey.shade800,
                        child: const Icon(Icons.movie, color: Colors.grey),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            movie.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          LinearProgressIndicator(
                            value: 0.6 + (index * 0.1),
                            backgroundColor: Colors.grey.shade800,
                            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFE50914)),
                            minHeight: 3,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${(60 + index * 15)}% complete',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ),
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

  // ==================== HORIZONTAL SCROLL ====================
  Widget _buildHorizontalScroll(List<Movie> movies) {
    return SizedBox(
      height: 230,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: movies.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final movie = movies[index];
          return _buildMovieCard(movie);
        },
      ),
    );
  }

  Widget _buildMovieCard(Movie movie) {
    return GestureDetector(
      onTap: () => _navigateToPlayer(movie),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 160,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      movie.thumbnailUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey.shade800,
                        child: const Center(
                          child: Icon(Icons.movie, color: Colors.grey, size: 40),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.6),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: 8,
                    bottom: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        movie.duration,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_border_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Colors.amber, size: 12),
                        const SizedBox(width: 2),
                        Text(
                          movie.rating,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(
                          movie.category,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(
                          movie.year,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
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
  }

  // ==================== MOVIES TAB ====================
  Widget _buildMoviesTab() {
    final movies = MovieData.movies.where((m) => m.category != 'TV Shows').toList();
    return _buildCategoryGrid('Movies', movies);
  }

  // ==================== TV SHOWS TAB ====================
  Widget _buildTVShowsTab() {
    final shows = MovieData.movies.take(4).toList();
    return _buildCategoryGrid('TV Shows', shows);
  }

  // ==================== MY LIST TAB ====================
  Widget _buildMyListTab() {
    final savedMovies = MovieData.movies.where((m) => m.isRecommended).toList();
    return _buildCategoryGrid('My List', savedMovies);
  }

  // ==================== CATEGORY GRID ====================
  Widget _buildCategoryGrid(String title, List<Movie> items) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${items.length} titles available',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.7,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final movie = items[index];
                  return TweenAnimationBuilder(
                    duration: Duration(milliseconds: 300 + (index * 50)),
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Opacity(
                          opacity: value,
                          child: child,
                        ),
                      );
                    },
                    child: GestureDetector(
                      onTap: () => _navigateToPlayer(movie),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.network(
                                    movie.thumbnailUrl,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    errorBuilder: (_, __, ___) => Container(
                                      color: Colors.grey.shade800,
                                      child: const Center(
                                        child: Icon(
                                          Icons.movie,
                                          color: Colors.grey,
                                          size: 40,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withOpacity(0.6),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 8,
                                    bottom: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.85),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        movie.duration,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.6),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.favorite_border_rounded,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    left: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE50914),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        movie.rating,
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
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    movie.title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.2,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade800,
                                          borderRadius: BorderRadius.circular(3),
                                        ),
                                        child: Text(
                                          movie.category,
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 9,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Row(
                                        children: [
                                          const Icon(Icons.star_rounded, color: Colors.amber, size: 12),
                                          const SizedBox(width: 2),
                                          Text(
                                            movie.rating,
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== NAVIGATION TO PLAYER ====================
  void _navigateToPlayer(Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NetflixPlayerScreen(movie: movie),
        fullscreenDialog: true,
      ),
    );
  }
}

// ==================== NETFLIX PLAYER SCREEN ====================
class NetflixPlayerScreen extends StatefulWidget {
  final Movie movie;

  const NetflixPlayerScreen({super.key, required this.movie});

  @override
  State<NetflixPlayerScreen> createState() => _NetflixPlayerScreenState();
}

class _NetflixPlayerScreenState extends State<NetflixPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isBuffering = true;
  bool _showControls = true;
  bool _isMuted = false;
  bool _isPlaying = false;
  bool _isFullscreen = false;
  Timer? _hideControlsTimer;
  double _volume = 1.0;
  double _playbackSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _initializeVideo();
  }

  void _initializeVideo() {
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.movie.videoUrl),
    );

    _controller.initialize().then((_) {
      if (!mounted) return;
      setState(() {
        _isInitialized = true;
        _isBuffering = false;
        _isPlaying = true;
      });
      _controller.play();
      _resetHideControlsTimer();
    });

    _controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  void _toggleControlsVisibility() {
    setState(() => _showControls = !_showControls);
    if (_showControls) _resetHideControlsTimer();
  }

  void _resetHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 4), () {
      if (mounted && _controller.value.isPlaying) {
        setState(() => _showControls = false);
      }
    });
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
    });
    _resetHideControlsTimer();
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _controller.setVolume(_isMuted ? 0 : _volume);
    });
    _resetHideControlsTimer();
  }

  void _seekRelative(Duration offset) {
    if (!_controller.value.isInitialized) return;
    final target = _controller.value.position + offset;
    final duration = _controller.value.duration;
    _controller.seekTo(
      target < Duration.zero ? Duration.zero : (target > duration ? duration : target),
    );
    _resetHideControlsTimer();
  }

  void _changeVolume(double value) {
    setState(() {
      _volume = value;
      _controller.setVolume(_isMuted ? 0 : value);
    });
    _resetHideControlsTimer();
  }

  void _changePlaybackSpeed(double speed) {
    setState(() {
      _playbackSpeed = speed;
      _controller.setPlaybackSpeed(speed);
    });
    _resetHideControlsTimer();
  }

  void _toggleFullscreen() {
    setState(() {
      _isFullscreen = !_isFullscreen;
      if (_isFullscreen) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      } else {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
        SystemChrome.setEnabledSystemUIMode(
          SystemUiMode.manual,
          overlays: SystemUiOverlay.values,
        );
      }
    });
  }

  String _formatDuration(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return hours > 0 ? '$hours:$minutes:$seconds' : '$minutes:$seconds';
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    _controller.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Video Player
            Center(
              child: _isInitialized
                  ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
                  : _buildLoadingScreen(),
            ),

            // Tap to show/hide controls
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _toggleControlsVisibility,
                onDoubleTap: _togglePlayPause,
              ),
            ),

            // Controls Overlay
            AnimatedOpacity(
              opacity: _showControls ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              child: IgnorePointer(
                ignoring: !_showControls,
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Stack(
                    children: [
                      // Center Controls
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildControlButton(
                              icon: Icons.replay_10_rounded,
                              size: 36,
                              onTap: () => _seekRelative(const Duration(seconds: -10)),
                            ),
                            const SizedBox(width: 20),
                            _buildControlButton(
                              icon: _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                              size: 56,
                              isPrimary: true,
                              onTap: _togglePlayPause,
                            ),
                            const SizedBox(width: 20),
                            _buildControlButton(
                              icon: Icons.forward_10_rounded,
                              size: 36,
                              onTap: () => _seekRelative(const Duration(seconds: 10)),
                            ),
                          ],
                        ),
                      ),

                      // Top Controls
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.7),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 28),
                                onPressed: () => Navigator.pop(context),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.movie.title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.3,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      widget.movie.year,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Quality Badge
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE50914),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'HD',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Settings Button
                              IconButton(
                                icon: const Icon(Icons.settings_rounded, color: Colors.white, size: 24),
                                onPressed: () => _showSettingsDialog(),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Bottom Controls
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.8),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Progress
                              if (_isInitialized) ...[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _formatDuration(_controller.value.position),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      _formatDuration(_controller.value.duration),
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                VideoProgressIndicator(
                                  _controller,
                                  allowScrubbing: true,
                                  colors: VideoProgressColors(
                                    playedColor: const Color(0xFFE50914),
                                    bufferedColor: Colors.white.withOpacity(0.3),
                                    backgroundColor: Colors.white.withOpacity(0.1),
                                  ),
                                ),
                              ],
                              const SizedBox(height: 12),
                              // Bottom Controls Row
                              Row(
                                children: [
                                  // Play/Pause
                                  IconButton(
                                    icon: Icon(
                                      _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                    onPressed: _togglePlayPause,
                                  ),
                                  // Volume
                                  IconButton(
                                    icon: Icon(
                                      _isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                    onPressed: _toggleMute,
                                  ),
                                  // Volume Slider
                                  Expanded(
                                    flex: 2,
                                    child: Slider(
                                      value: _volume,
                                      min: 0,
                                      max: 1,
                                      onChanged: _changeVolume,
                                      activeColor: const Color(0xFFE50914),
                                      inactiveColor: Colors.white.withOpacity(0.3),
                                      thumbColor: Colors.white,
                                    ),
                                  ),
                                  // Speed
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      '${_playbackSpeed}x',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  // Fullscreen
                                  IconButton(
                                    icon: Icon(
                                      _isFullscreen ? Icons.fullscreen_exit_rounded : Icons.fullscreen_rounded,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                    onPressed: _toggleFullscreen,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required double size,
    bool isPrimary = false,
    required VoidCallback onTap,
  }) {
    return Container(
      width: isPrimary ? 72 : 52,
      height: isPrimary ? 72 : 52,
      decoration: BoxDecoration(
        color: isPrimary ? Colors.white.withOpacity(0.9) : Colors.black.withOpacity(0.5),
        shape: BoxShape.circle,
        border: isPrimary ? null : Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(
          icon,
          color: isPrimary ? Colors.black : Colors.white,
          size: size,
        ),
        onPressed: onTap,
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          widget.movie.bannerUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: Colors.grey.shade900,
            child: const Center(
              child: CircularProgressIndicator(color: Color(0xFFE50914)),
            ),
          ),
        ),
        Container(
          color: Colors.black.withOpacity(0.5),
        ),
        const Center(
          child: CircularProgressIndicator(
            color: Color(0xFFE50914),
            strokeWidth: 3,
          ),
        ),
      ],
    );
  }

  void _showSettingsDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Settings',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Playback Speed',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [0.5, 0.75, 1.0, 1.25, 1.5, 2.0].map((speed) {
                final isSelected = _playbackSpeed == speed;
                return GestureDetector(
                  onTap: () {
                    _changePlaybackSpeed(speed);
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFE50914) : Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${speed}x',
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white70,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text(
              'Audio & Subtitles',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Audio',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          'English',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Subtitles',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          'Off',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}