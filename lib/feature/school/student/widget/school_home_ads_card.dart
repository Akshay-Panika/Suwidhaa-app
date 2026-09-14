import 'package:flutter/material.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';

import '../../../ott/dashboard/screen/ott_dashboard_screen.dart';

// import 'package:your_app/path/to/ott_dashboard_screen.dart';

class SchoolHomeAdsCard extends StatefulWidget {
  const SchoolHomeAdsCard({super.key});

  @override
  State<SchoolHomeAdsCard> createState() => _SchoolHomeAdsCardState();
}

class _SchoolHomeAdsCardState extends State<SchoolHomeAdsCard> {
  int _currentIndex = 0;

  // Combined Ads Data (School + Movies)
  final List<Map<String, dynamic>> adItems = const [
    // School Ads
    {
      'type': 'school',
      'title': 'Admission Open 2026',
      'subtitle': 'Tap to learn more',
      'color': Colors.blue,
      'icon': Icons.school,
    },
    {
      'type': 'school',
      'title': 'Sports Day Coming Soon',
      'subtitle': 'Tap to learn more',
      'color': Colors.green,
      'icon': Icons.sports_soccer,
    },
    {
      'type': 'school',
      'title': 'Science Exhibition',
      'subtitle': 'Tap to learn more',
      'color': Colors.orange,
      'icon': Icons.science,
    },
    // Movie Ads
    {
      'type': 'movie',
      'title': '🎬 Moana 2',
      'subtitle': 'New Adventure Begins',
      'color': Colors.purple,
      'icon': Icons.movie,
    },
    {
      'type': 'movie',
      'title': '🦁 Mufasa: The Lion King',
      'subtitle': 'The Legend Continues',
      'color': Colors.amber,
      'icon': Icons.live_tv,
    },
    {
      'type': 'movie',
      'title': '⚡ Sonic 3',
      'subtitle': 'Faster Than Ever',
      'color': Colors.deepOrange,
      'icon': Icons.videogame_asset,
    },
  ];

  // Navigation method
  void _navigateToOttDashboard() {
    // Uncomment when you have OttDashboardScreen imported
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  OttDashboardScreen(currentIndex: 3,)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      child: ClipRRect(
        child: Stack(
          children: [
            CarouselSlider.builder(
              itemCount: adItems.length,
              itemBuilder: (context, index, realIndex) {
                final item = adItems[index];
                final isMovie = item['type'] == 'movie';

                return GestureDetector(
                  onTap: _navigateToOttDashboard,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          item['color'] as Color,
                          (item['color'] as Color).withOpacity(0.7),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Left side - Title and Subtitle
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    // Show movie badge if it's a movie
                                    if (isMovie) ...[
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.3),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: const Text(
                                          'MOVIE',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 8,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                    ],
                                    Expanded(
                                      child: Text(
                                        item['title'] as String,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: isMovie ? 16 : 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item['subtitle'] as String,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.85),
                                    fontSize: isMovie ? 12 : 12,
                                  ),
                                ),
                                // Show "Watch Now" for movies
                                if (isMovie) ...[
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.25),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Watch Now',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(width: 4),
                                        Icon(
                                          Icons.play_arrow,
                                          color: Colors.white,
                                          size: 14,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          // Right side - Icon
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              item['icon'] as IconData,
                              color: Colors.white,
                              size: isMovie ? 26 : 28,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              options: CarouselOptions(
                height: double.infinity,
                viewportFraction: 1.0,
                enableInfiniteScroll: true,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 4),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                pauseAutoPlayOnTouch: true,
                enlargeCenterPage: false,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            ),
            // Custom Indicator
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  adItems.length,
                      (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentIndex == index ? 12 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: _currentIndex == index
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}