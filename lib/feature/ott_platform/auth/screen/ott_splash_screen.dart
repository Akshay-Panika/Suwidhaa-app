import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../dashboard/screen/ott_dashboard_screen.dart';
import 'ott_auth_screen.dart';

class OttSplashScreen extends StatefulWidget {
  const OttSplashScreen({super.key});

  @override
  State<OttSplashScreen> createState() => _OttSplashScreenState();
}

class _OttSplashScreenState extends State<OttSplashScreen> {
  final ScrollController _list1Controller = ScrollController();
  final ScrollController _list2Controller = ScrollController();
  final ScrollController _list3Controller = ScrollController();

  bool _isAutoScrollEnabled = false;
  bool _isScrolling = false;
  bool _isPaused = false;

  // Colors for movie cards
  final List<Color> _colors = [
    Colors.blue.shade700,
    Colors.red.shade700,
    Colors.green.shade700,
    Colors.orange.shade700,
    Colors.purple.shade700,
    Colors.teal.shade700,
    Colors.pink.shade700,
    Colors.indigo.shade700,
    Colors.cyan.shade700,
    Colors.amber.shade700,
  ];

  final List<String> movieTitles = [
    'The Dark Knight',
    'Inception',
    'Interstellar',
    'The Matrix',
    'Avatar',
    'Titanic',
    'Gladiator',
    'The Godfather',
    'Pulp Fiction',
    'The Shawshank Redemption',
  ];

  final List<String> movieYears = [
    '2008',
    '2010',
    '2014',
    '1999',
    '2009',
    '1997',
    '2000',
    '1972',
    '1994',
    '1994',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && !_isPaused) {
        setState(() {
          _isAutoScrollEnabled = true;
        });
        _scrollLists();
      }
    });
  }

  void _scrollLists() {
    if (_isScrolling || !mounted || _isPaused) return;
    _isScrolling = true;

    // Scroll List 1 - Down then Up
    if (_list1Controller.hasClients) {
      try {
        _list1Controller.animateTo(
          _list1Controller.position.maxScrollExtent,
          duration: const Duration(seconds: 6),
          curve: Curves.easeInOut,
        ).then((_) {
          if (mounted && !_isPaused && _list1Controller.hasClients) {
            _list1Controller.animateTo(
              0,
              duration: const Duration(seconds: 6),
              curve: Curves.easeInOut,
            ).then((_) {
              _isScrolling = false;
              if (mounted && !_isPaused) {
                _scrollLists();
              }
            });
          } else {
            _isScrolling = false;
          }
        }).catchError((e) {
          _isScrolling = false;
        });
      } catch (e) {
        _isScrolling = false;
      }
    }

    // Scroll List 2 - Up then Down
    if (_list2Controller.hasClients) {
      try {
        _list2Controller.animateTo(
          0,
          duration: const Duration(seconds: 5),
          curve: Curves.easeInOut,
        ).then((_) {
          if (mounted && !_isPaused && _list2Controller.hasClients) {
            _list2Controller.animateTo(
              _list2Controller.position.maxScrollExtent,
              duration: const Duration(seconds: 5),
              curve: Curves.easeInOut,
            ).then((_) {
              if (mounted && !_isPaused) {
                _scrollLists();
              }
            });
          }
        }).catchError((e) {
          _isScrolling = false;
        });
      } catch (e) {
        _isScrolling = false;
      }
    }

    // Scroll List 3 - Down then Up
    if (_list3Controller.hasClients) {
      try {
        _list3Controller.animateTo(
          _list3Controller.position.maxScrollExtent,
          duration: const Duration(seconds: 7),
          curve: Curves.easeInOut,
        ).then((_) {
          if (mounted && !_isPaused && _list3Controller.hasClients) {
            _list3Controller.animateTo(
              0,
              duration: const Duration(seconds: 7),
              curve: Curves.easeInOut,
            ).then((_) {
              if (mounted && !_isPaused) {
                _scrollLists();
              }
            });
          }
        }).catchError((e) {
          _isScrolling = false;
        });
      } catch (e) {
        _isScrolling = false;
      }
    }
  }

  @override
  void dispose() {
    _list1Controller.dispose();
    _list2Controller.dispose();
    _list3Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon:  Icon(Icons.dashboard,color: Colors.white,),
        ),
        title: const Text(
          "OTT",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.black,
        foregroundColor: Colors.black87,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              spacing: 10,
              children: [
                // List 1
                Expanded(
                  child: ListView.builder(
                    controller: _list1Controller,
                    physics: const BouncingScrollPhysics(),
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return _buildMovieCard(
                        index: index,
                        color: _colors[index % _colors.length],
                        title: movieTitles[index % movieTitles.length],
                        year: movieYears[index % movieYears.length],
                        direction: '⬇ Scroll Down',
                        rating: (4.0 + (index % 3) * 0.5).toStringAsFixed(1),
                      );
                    },
                  ),
                ),
                // List 2
                Expanded(
                  child: ListView.builder(
                    controller: _list2Controller,
                    physics: const BouncingScrollPhysics(),
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      final idx = (index + 3) % 10;
                      return _buildMovieCard(
                        index: idx,
                        color: _colors[idx],
                        title: movieTitles[idx],
                        year: movieYears[idx],
                        direction: '⬆ Scroll Up',
                        rating: (4.0 + (idx % 3) * 0.5).toStringAsFixed(1),
                      );
                    },
                  ),
                ),
                // List 3
                Expanded(
                  child: ListView.builder(
                    controller: _list3Controller,
                    physics: const BouncingScrollPhysics(),
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      final idx = (index + 6) % 10;
                      return _buildMovieCard(
                        index: idx,
                        color: _colors[idx],
                        title: movieTitles[idx],
                        year: movieYears[idx],
                        direction: '⬇ Scroll Down',
                        rating: (4.0 + (idx % 3) * 0.5).toStringAsFixed(1),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.black,
                  ],
                ),
              ),
              child: Column(
                children: [
                  const Expanded(child: SizedBox(height: 10)),
                  Expanded(
                    child: Column(
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Unlimited movies, TV show\nAnd More",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const Text(
                          "Get ready to drive into the greatest stories\nin TV and film",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => OttDashboardScreen(),));
                            },
                            child: const Text(
                              "Enjoin Now",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieCard({
    required int index,
    required Color color,
    required String title,
    required String year,
    required String direction,
    required String rating,
  }) {
    return Container(
      height: 200,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Solid color background with pattern
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color,
                    color.withOpacity(0.6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  // Decorative circles
                  Positioned(
                    top: -20,
                    right: -20,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -30,
                    left: -30,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  // Movie icon
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Icon(
                      Icons.movie,
                      color: Colors.white.withOpacity(0.3),
                      size: 50,
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
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
                          '$rating ★',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            year,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
    );
  }
}