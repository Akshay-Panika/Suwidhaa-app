import 'package:flutter/material.dart';
import 'package:untitled/core/utils/app_color.dart';
import 'ott_platform_video_play_screen.dart';

class OttPlatformHomeScreen extends StatefulWidget {
  const OttPlatformHomeScreen({super.key});

  @override
  State<OttPlatformHomeScreen> createState() => _OttPlatformHomeScreenState();
}

class _OttPlatformHomeScreenState extends State<OttPlatformHomeScreen> {
  int selectedTabIndex = 0;
  final List<String> tabNames = ['Home', 'TV Show', 'Movies', 'Kids'];

  final List<String> thumbnailUrls = const [
    'https://picsum.photos/seed/1/300/400',
    'https://picsum.photos/seed/2/300/400',
    'https://picsum.photos/seed/3/300/400',
    'https://picsum.photos/seed/4/300/400',
    'https://picsum.photos/seed/5/300/400',
    'https://picsum.photos/seed/6/300/400',
    'https://picsum.photos/seed/7/300/200',
    'https://picsum.photos/seed/8/300/200',
    'https://picsum.photos/seed/9/300/200',
    'https://picsum.photos/seed/10/300/200',
    'https://picsum.photos/seed/11/300/200',
    'https://picsum.photos/seed/12/300/200',
    'https://picsum.photos/seed/13/300/200',
    'https://picsum.photos/seed/14/300/200',
    'https://picsum.photos/seed/15/300/200',
    'https://picsum.photos/seed/16/300/200',
    'https://picsum.photos/seed/17/300/200',
    'https://picsum.photos/seed/18/300/200',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.dashboard, color: AppColors.primary),
        ),
        title: Text(
          "OTT Platform",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert, color: Colors.black, size: 24),
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab Bar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(tabNames.length, (index) {
                return _buildTabButton(
                  tabNames[index],
                  selectedTabIndex == index,
                      () {
                    setState(() {
                      selectedTabIndex = index;
                    });
                  },
                );
              }),
            ),
          ),
          Divider(height: 1),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildBanner(),
                  _buildContentBasedOnTab(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String text, bool isSelected, VoidCallback onTap) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: isSelected ? AppColors.primary : Colors.grey,
        textStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      child: Text(text),
    );
  }

  Widget _buildBanner() {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => OttPlatformVideoPlayScreen()));
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 180,
        margin: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          image: DecorationImage(
            image: NetworkImage('https://picsum.photos/seed/banner/800/400'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.6),
                Colors.transparent,
              ],
            ),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Featured Content",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Watch the latest trending shows",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => OttPlatformVideoPlayScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    ),
                    child: Text('Watch Now', style: TextStyle(fontSize: 13)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContentBasedOnTab() {
    switch (selectedTabIndex) {
      case 0:
        return Column(
          children: [
            _buildSection("Continue Watching", _getContinueWatching(), true),
            _buildSection("Best For You", _getBestForYou(), false),
            _buildSection("Trending Movies", _getTrending(), false),
          ],
        );
      case 1:
        return Column(
          children: [
            _buildSection("TV Shows", _getTVShows(), true),
            _buildSection("Popular TV Shows", _getPopularTVShows(), false),
          ],
        );
      case 2:
        return Column(
          children: [
            _buildSection("Movies", _getMovies(), true),
            _buildSection("Popular Movies", _getPopularMovies(), false),
          ],
        );
      case 3:
        return Column(
          children: [
            _buildSection("Kids Shows", _getKidsShows(), true),
            _buildSection("Kids Movies", _getKidsMovies(), false),
          ],
        );
      default:
        return SizedBox.shrink();
    }
  }

  Widget _buildSection(String title, List<Map<String, dynamic>> items, bool isSmall) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "See All",
                  style: TextStyle(color: AppColors.primary, fontSize: 13),
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
          SizedBox(
            height: isSmall ? 180 : 160,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              separatorBuilder: (context, index) => SizedBox(width: 10),
              itemBuilder: (context, index) {
                return _buildCard(items[index], index, isSmall);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> item, int index, bool isSmall) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => OttPlatformVideoPlayScreen()));
      },
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: isSmall ? 140 : 220,
        child: Card(
          clipBehavior: Clip.antiAlias,
          elevation: 3,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                thumbnailUrls[index % thumbnailUrls.length],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: Icon(Icons.movie, color: Colors.grey[600], size: 30),
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
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title'] ?? 'Title',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: isSmall ? 11 : 13,
                      ),
                    ),
                    if (item.containsKey('episode'))
                      Text(
                        item['episode'],
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: isSmall ? 9 : 11,
                        ),
                      ),
                    if (item.containsKey('rating'))
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 12),
                          SizedBox(width: 3),
                          Text(
                            item['rating'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isSmall ? 10 : 12,
                            ),
                          ),
                          SizedBox(width: 6),
                          Text(
                            item['year'],
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: isSmall ? 10 : 12,
                            ),
                          ),
                        ],
                      ),
                    if (item.containsKey('rank'))
                      Row(
                        children: [
                          Icon(Icons.trending_up, color: Colors.green, size: 12),
                          SizedBox(width: 3),
                          Text(
                            item['rank'],
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: isSmall ? 10 : 12,
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
      ),
    );
  }

  // Data Methods
  List<Map<String, dynamic>> _getContinueWatching() => [
    {'title': 'Stranger Things', 'episode': 'Episode 1', 'time': '45 min left'},
    {'title': 'The Crown', 'episode': 'Episode 3', 'time': '30 min left'},
    {'title': 'Breaking Bad', 'episode': 'Episode 6', 'time': '50 min left'},
    {'title': 'Game of Thrones', 'episode': 'Episode 4', 'time': '25 min left'},
    {'title': 'The Office', 'episode': 'Episode 8', 'time': '15 min left'},
    {'title': 'Friends', 'episode': 'Episode 10', 'time': '20 min left'},
  ];

  List<Map<String, dynamic>> _getBestForYou() => [
    {'title': 'Avatar 2', 'rating': '4.8', 'year': '2022'},
    {'title': 'Top Gun', 'rating': '4.9', 'year': '2022'},
    {'title': 'Barbie', 'rating': '4.3', 'year': '2023'},
    {'title': 'Oppenheimer', 'rating': '4.8', 'year': '2023'},
    {'title': 'Dune Part 2', 'rating': '4.6', 'year': '2024'},
    {'title': 'Deadpool 3', 'rating': '4.4', 'year': '2024'},
  ];

  List<Map<String, dynamic>> _getTrending() => [
    {'title': 'Avatar 2', 'rank': '#1 in Movies'},
    {'title': 'Top Gun', 'rank': '#2 in Movies'},
    {'title': 'Barbie', 'rank': '#3 in Movies'},
    {'title': 'Oppenheimer', 'rank': '#4 in Movies'},
    {'title': 'Dune Part 2', 'rank': '#5 in Movies'},
    {'title': 'Deadpool 3', 'rank': '#6 in Movies'},
  ];

  List<Map<String, dynamic>> _getTVShows() => [
    {'title': 'The Witcher', 'episode': 'Season 3', 'year': '2023'},
    {'title': 'Wednesday', 'episode': 'Season 1', 'year': '2022'},
    {'title': 'The Last of Us', 'episode': 'Season 1', 'year': '2023'},
    {'title': 'House of Dragons', 'episode': 'Season 2', 'year': '2024'},
    {'title': 'The Mandalorian', 'episode': 'Season 3', 'year': '2023'},
    {'title': 'Loki', 'episode': 'Season 2', 'year': '2023'},
  ];

  List<Map<String, dynamic>> _getPopularTVShows() => [
    {'title': 'Breaking Bad', 'rating': '4.9', 'year': '2010'},
    {'title': 'Game of Thrones', 'rating': '4.6', 'year': '2017'},
    {'title': 'The Office', 'rating': '4.5', 'year': '2011'},
    {'title': 'Friends', 'rating': '4.4', 'year': '2004'},
    {'title': 'Stranger Things', 'rating': '4.8', 'year': '2022'},
    {'title': 'The Crown', 'rating': '4.7', 'year': '2022'},
  ];

  List<Map<String, dynamic>> _getMovies() => [
    {'title': 'Avatar 2', 'rating': '4.8', 'year': '2022'},
    {'title': 'Top Gun Maverick', 'rating': '4.9', 'year': '2022'},
    {'title': 'Barbie', 'rating': '4.3', 'year': '2023'},
    {'title': 'Oppenheimer', 'rating': '4.8', 'year': '2023'},
    {'title': 'Dune Part 2', 'rating': '4.6', 'year': '2024'},
    {'title': 'Deadpool 3', 'rating': '4.4', 'year': '2024'},
  ];

  List<Map<String, dynamic>> _getPopularMovies() => [
    {'title': 'The Godfather', 'rating': '4.9', 'year': '1972'},
    {'title': 'The Dark Knight', 'rating': '4.8', 'year': '2008'},
    {'title': 'Pulp Fiction', 'rating': '4.7', 'year': '1994'},
    {'title': 'Inception', 'rating': '4.6', 'year': '2010'},
    {'title': 'The Matrix', 'rating': '4.5', 'year': '1999'},
    {'title': 'Interstellar', 'rating': '4.5', 'year': '2014'},
  ];

  List<Map<String, dynamic>> _getKidsShows() => [
    {'title': 'Cocomelon', 'episode': 'Season 5', 'year': '2024'},
    {'title': 'Peppa Pig', 'episode': 'Season 8', 'year': '2023'},
    {'title': 'Bluey', 'episode': 'Season 3', 'year': '2024'},
    {'title': 'Paw Patrol', 'episode': 'Season 9', 'year': '2023'},
    {'title': 'SpongeBob', 'episode': 'Season 14', 'year': '2024'},
    {'title': 'Dora', 'episode': 'Season 8', 'year': '2023'},
  ];

  List<Map<String, dynamic>> _getKidsMovies() => [
    {'title': 'Frozen 2', 'rating': '4.5', 'year': '2019'},
    {'title': 'Toy Story 4', 'rating': '4.6', 'year': '2019'},
    {'title': 'Moana', 'rating': '4.4', 'year': '2016'},
    {'title': 'Coco', 'rating': '4.5', 'year': '2017'},
    {'title': 'Lion King', 'rating': '4.7', 'year': '2019'},
    {'title': 'Despicable Me 3', 'rating': '4.3', 'year': '2017'},
  ];
}