import 'package:flutter/material.dart';

class OttSchoolScreen extends StatefulWidget {
  const OttSchoolScreen({super.key});

  @override
  State<OttSchoolScreen> createState() => _OttSchoolScreenState();
}

class _OttSchoolScreenState extends State<OttSchoolScreen> {
  final List<String> _categories = [
    'All',
    'Educational',
    'Fun Learning',
    'Science',
    'Arts',
    'Music',
    'Sports',
    'Crafts',
  ];

  final List<Map<String, String>> _videos = [
    {
      'title': 'Learn ABC - Fun Animation',
      'category': 'Educational',
      'rating': '4.9',
      'duration': '15 min',
      'image': 'https://picsum.photos/seed/abc/200/300',
      'age': '3+',
    },
    {
      'title': 'Science Experiments for Kids',
      'category': 'Science',
      'rating': '4.8',
      'duration': '20 min',
      'image': 'https://picsum.photos/seed/science/200/300',
      'age': '6+',
    },
    {
      'title': 'Creative Art & Drawing',
      'category': 'Arts',
      'rating': '4.7',
      'duration': '18 min',
      'image': 'https://picsum.photos/seed/art/200/300',
      'age': '4+',
    },
    {
      'title': 'Kids Yoga & Exercise',
      'category': 'Sports',
      'rating': '4.8',
      'duration': '12 min',
      'image': 'https://picsum.photos/seed/yoga/200/300',
      'age': '5+',
    },
    {
      'title': 'Learn Piano - Easy Songs',
      'category': 'Music',
      'rating': '4.9',
      'duration': '25 min',
      'image': 'https://picsum.photos/seed/piano/200/300',
      'age': '6+',
    },
    {
      'title': 'Paper Crafts - Origami',
      'category': 'Crafts',
      'rating': '4.6',
      'duration': '15 min',
      'image': 'https://picsum.photos/seed/origami/200/300',
      'age': '5+',
    },
    {
      'title': 'Fun Math Games',
      'category': 'Fun Learning',
      'rating': '4.7',
      'duration': '10 min',
      'image': 'https://picsum.photos/seed/mathfun/200/300',
      'age': '4+',
    },
    {
      'title': 'Animal Kingdom - Wildlife',
      'category': 'Educational',
      'rating': '4.9',
      'duration': '22 min',
      'image': 'https://picsum.photos/seed/animals/200/300',
      'age': '3+',
    },
    {
      'title': 'Learn Spanish - Basics',
      'category': 'Fun Learning',
      'rating': '4.5',
      'duration': '18 min',
      'image': 'https://picsum.photos/seed/spanish/200/300',
      'age': '7+',
    },
    {
      'title': 'Cooking for Kids',
      'category': 'Crafts',
      'rating': '4.8',
      'duration': '20 min',
      'image': 'https://picsum.photos/seed/cooking/200/300',
      'age': '6+',
    },
  ];

  int _selectedCategory = 0;

  // Filter videos based on selected category
  List<Map<String, String>> get _filteredVideos {
    if (_selectedCategory == 0) {
      return _videos;
    }
    return _videos
        .where((video) => video['category'] == _categories[_selectedCategory])
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: const Text(
        '🎓 School',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          // Categories
          _buildCategories(),
          const SizedBox(height: 16),
          // Video Grid
          _buildVideoGrid(),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedCategory == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = index;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: isSelected ? Colors.orange : Colors.grey[900],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? Colors.orange : Colors.grey[800]!,
                  width: 1,
                ),
              ),
              child: Text(
                _categories[index],
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

  Widget _buildVideoGrid() {
    if (_filteredVideos.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.video_library,
                color: Colors.grey[700],
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                'No videos found',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 16,
                ),
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
          childAspectRatio: 0.7,
        ),
        itemCount: _filteredVideos.length,
        itemBuilder: (context, index) {
          final video = _filteredVideos[index];
          final ageColor = int.parse(video['age']!.replaceAll('+', '')) <= 4
              ? Colors.green
              : int.parse(video['age']!.replaceAll('+', '')) <= 6
              ? Colors.orange
              : Colors.red;
          return Container(
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
                color: Colors.orange.shade600.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Video Thumbnail
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Stack(
                    children: [
                      Image.network(
                        video['image']!,
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
                              child: CircularProgressIndicator(
                                color: Colors.orange,
                              ),
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
                      // Play Button Overlay
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.play_circle_outline,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                      // Category Badge
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            video['category']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      // Age Badge
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: ageColor.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.family_restroom,
                                color: Colors.white,
                                size: 10,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                video['age']!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Duration Badge
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '⏱ ${video['duration']}',
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
                // Video Info
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        video['title']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            video['rating']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'School',
                              style: TextStyle(
                                color: Colors.orangeAccent,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
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
          );
        },
      ),
    );
  }
}