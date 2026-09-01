import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/app_color.dart';

class ModuleBannerCard extends StatefulWidget {
  const ModuleBannerCard({super.key});

  @override
  State<ModuleBannerCard> createState() => _ModuleBannerCardState();
}

class _ModuleBannerCardState extends State<ModuleBannerCard> {
  int _currentBannerIndex = 0;
  final PageController _pageController = PageController();

  final List<Map<String, String>> bannerItems = [
    {
      'tag': '⚡ MULTI-SERVICE HUB',
      'title': 'All Local Services & Needs\nRight Inside One App',
      'action': 'Explore Now',
      'icon': '🏪',
      'bgColor': '#EEF2FF',
    },
    {
      'tag': '🛍️ FESTIVE DELIGHTS',
      'title': 'Get Amazing Discounts Across\nAll Our Verified Digital Channels',
      'action': 'Check Offers',
      'icon': '🎉',
      'bgColor': '#FFF7ED',
    },
    {
      'tag': '🚀 PREMIUM SERVICES',
      'title': 'Unlock Exclusive Benefits\nWith Suwidhaa Premium',
      'action': 'Upgrade Now',
      'icon': '⭐',
      'bgColor': '#F3E8FF',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140, // Fixed height for the banner
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // CarouselSlider without Expanded
          CarouselSlider(
            items: bannerItems.map((item) {
              return _buildBannerItem(item);
            }).toList(),
            options: CarouselOptions(
              viewportFraction: 1,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 5),
              autoPlayCurve: Curves.easeInOut,
              enlargeCenterPage: true,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentBannerIndex = index;
                });
              },
            ),
          ),
          Positioned(
            bottom: 20,
            child: _buildBannerIndicators(),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerItem(Map<String, String> item) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(int.parse(item['bgColor']!.replaceFirst('#', '0xFF'))),
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    item['tag']!,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item['title']!,
                  style: const TextStyle(
                    color: Color(0xFF1E293B),
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    item['action']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  item['icon']!,
                  style: const TextStyle(fontSize: 30),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        bannerItems.length,
            (index) {
          bool isActive = _currentBannerIndex == index;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: isActive ? 24 : 6,
            height: 6,
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary : Colors.grey.withOpacity(0.5),
              borderRadius: BorderRadius.circular(3),
              boxShadow: isActive
                  ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 6,
                ),
              ]
                  : null,
            ),
          );
        },
      ),
    );
  }
}