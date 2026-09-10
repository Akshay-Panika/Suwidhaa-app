import 'package:flutter/material.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../controller/ott_banner_controller.dart';

class MovieBanner extends StatefulWidget {
  const MovieBanner({super.key});

  @override
  State<MovieBanner> createState() => _MovieBannerState();
}

class _MovieBannerState extends State<MovieBanner> {
  final OttBannerController controller = Get.find<OttBannerController>();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // 🔹 Shimmer placeholder while banner data is loading
      if (controller.isLoading.value && controller.banners.isEmpty) {
        return const _BannerShimmer();
      }

      if (controller.banners.isEmpty) {
        return const SizedBox(
          height: 240,
          child: Center(
            child: Icon(
              Icons.image_not_supported,
              color: Colors.grey,
              size: 50,
            ),
          ),
        );
      }

      if (_currentIndex >= controller.banners.length) {
        _currentIndex = 0;
      }

      return SizedBox(
        height: 240,
        child: Stack(
          children: [
            CarouselSlider(
              items: controller.banners.map((banner) {
                return _buildBannerItem(
                  image: banner.image,
                );
              }).toList(),
              options: CarouselOptions(
                autoPlay: controller.banners.length > 1,
                autoPlayInterval: const Duration(seconds: 4),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.easeInOut,
                enlargeCenterPage: false,
                enableInfiniteScroll: controller.banners.length > 1,
                viewportFraction: 1.0,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            ),
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  controller.banners.length,
                      (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentIndex == index ? 16 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: _currentIndex == index
                          ? Colors.red
                          : Colors.grey.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildBannerItem({required String image}) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              image,
              fit: BoxFit.cover,
              // 🔹 Shimmer while the image loads
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return const _ImageShimmer();
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[800],
                  child: const Center(
                    child: Icon(
                      Icons.image_not_supported,
                      color: Colors.grey,
                      size: 50,
                    ),
                  ),
                );
              },
            ),
            // Container(
            //   decoration: BoxDecoration(
            //     gradient: LinearGradient(
            //       begin: Alignment.topCenter,
            //       end: Alignment.bottomCenter,
            //       colors: [
            //         Colors.transparent,
            //         Colors.black.withOpacity(0.2),
            //         Colors.black.withOpacity(0.7),
            //         Colors.black.withOpacity(0.9),
            //       ],
            //       stops: const [
            //         0.0,
            //         0.3,
            //         0.6,
            //         1.0,
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

/// 🔹 Full banner shimmer (used while banners list is loading)
class _BannerShimmer extends StatelessWidget {
  const _BannerShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[900]!,
      highlightColor: Colors.grey[700]!,
      child: Container(
        height: 240,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(0),
        ),
        child: Stack(
          children: [
            // Simulated gradient overlay
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.grey[900]!,
                    ],
                  ),
                ),
              ),
            ),
            // Simulated dot indicators
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                      (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: index == 0 ? 16 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.grey[700],
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

/// 🔹 Image shimmer (used while a network image is loading)
class _ImageShimmer extends StatelessWidget {
  const _ImageShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[900]!,
      highlightColor: Colors.grey[700]!,
      child: Container(
        color: Colors.grey[900],
      ),
    );
  }
}