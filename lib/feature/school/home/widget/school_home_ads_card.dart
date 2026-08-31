import 'package:flutter/material.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';

class SchoolHomeAdsCard extends StatefulWidget {
  const SchoolHomeAdsCard({super.key});

  @override
  State<SchoolHomeAdsCard> createState() => _SchoolHomeAdsCardState();
}

class _SchoolHomeAdsCardState extends State<SchoolHomeAdsCard> {
  int _currentIndex = 0;

  final List<String> adImages = const [
    'https://placehold.co/800x400/2196F3/FFFFFF?text=School+Ad+1',
    'https://placehold.co/800x400/4CAF50/FFFFFF?text=School+Ad+2',
    'https://placehold.co/800x400/FF9800/FFFFFF?text=School+Ad+3',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      // margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.black.withOpacity(0.1),
      child: Stack(
        children: [
          CarouselSlider.builder(
            itemCount: adImages.length,
            itemBuilder: (context, index, realIndex) {
              return Image.network(
                adImages[index],
                fit: BoxFit.cover,
                width: double.infinity,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey.shade200,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                            : null,
                        color: Colors.blue,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade200,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.grey.shade400,
                          size: 40,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Failed to load image',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                },
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
                adImages.length,
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
    );
  }
}