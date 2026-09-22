import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:untitled/core/utils/app_color.dart';
import '../../controller/college_banner_controller.dart';

class CollageBannerCard extends StatelessWidget {
  const CollageBannerCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CollegeBannerController());

    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive height: scales with screen width, clamped to a sane range.
        final screenWidth = MediaQuery.of(context).size.width;
        final bannerHeight = (screenWidth * 0.5).clamp(160.0, 220.0);

        return Obx(() {
          // Loading State
          if (controller.isLoading.value && controller.banners.isEmpty) {
            return SizedBox.shrink();
          }

          // Error State
          if (controller.errorMessage.isNotEmpty && controller.banners.isEmpty) {
            return Container(
              height: bannerHeight,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: CollegeColors.background,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: CollegeColors.border),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 56,
                      color: CollegeColors.secondary,
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        controller.errorMessage.value,
                        style: TextStyle(
                          fontSize: 14,
                          color: CollegeColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => controller.refreshBanners(),
                      icon: const Icon(Icons.refresh, size: 18),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CollegeColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // Empty State
          if (controller.banners.isEmpty) {
            return SizedBox.shrink();
          }

          // Banners Carousel
          return Container(
            height: bannerHeight + 16,
            margin: EdgeInsets.only(top: 40,right: 20,left: 20),
            child: Stack(
              children: [
                CarouselSlider(
                  items: controller.banners.map((banner) {
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            banner.bannerImage,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                width: double.infinity,
                                color: CollegeColors.primaryLight,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: CollegeColors.primary,
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: double.infinity,
                                color: CollegeColors.primaryLight,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.broken_image,
                                      size: 40,
                                      color: CollegeColors.primary.withOpacity(0.5),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Failed to load image',
                                      style: TextStyle(
                                        color: CollegeColors.textSecondary,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        // Subtle bottom gradient so dot indicators / future
                        // captions stay readable over bright images.
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          height: 48,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.25),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                  options: CarouselOptions(
                    height: bannerHeight,
                    viewportFraction: 1.0,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 4),
                    autoPlayAnimationDuration: const Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: false,
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (index, reason) {
                      controller.onPageChanged(index);
                    },
                  ),
                ),
                // Indicator dots
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Obx(
                        () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        controller.banners.length,
                            (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: controller.currentIndex.value == index ? 22 : 7,
                          height: 7,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: controller.currentIndex.value == index
                                ? CollegeColors.primary
                                : CollegeColors.secondaryLight,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }
}