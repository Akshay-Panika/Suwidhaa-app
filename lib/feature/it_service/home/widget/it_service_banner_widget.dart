import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/utils/app_color.dart';
import '../controller/it_service_banner_controller.dart';

class ItServiceBannerWidget extends StatefulWidget {
  const ItServiceBannerWidget({super.key});

  @override
  State<ItServiceBannerWidget> createState() => _ItServiceBannerWidgetState();
}

class _ItServiceBannerWidgetState extends State<ItServiceBannerWidget> {
  final CarouselSliderController _carouselController = CarouselSliderController();
  int _currentBannerIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ItServiceBannerController controller =
    Get.find<ItServiceBannerController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Obx(() {
        // ---------- LOADING ----------
        if (controller.isLoading.value && controller.banners.isEmpty) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          );
        }

        // ---------- EMPTY ----------
        if (controller.banners.isEmpty) {
          return Container(
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.itServices.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Icon(
                Icons.image_not_supported,
                size: 50,
                color: Colors.grey,
              ),
            ),
          );
        }

        // ---------- DATA ----------
        return Stack(
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
                  autoPlayInterval: const Duration(seconds: 4),
                  autoPlayAnimationDuration:
                  const Duration(milliseconds: 800),
                  pauseAutoPlayOnTouch: true,
                  onPageChanged: (index, reason) {
                    setState(() => _currentBannerIndex = index);
                  },
                ),
                items: controller.banners.map((banner) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      banner.bannerImage,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      gaplessPlayback: true,
                      frameBuilder: (context, child, frame, wasSync) {
                        if (wasSync || frame != null) return child;
                        return Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(color: Colors.white),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: AppColors.itServices.withOpacity(0.08),
                        child: const Icon(
                          Icons.broken_image,
                          size: 50,
                          color: AppColors.itServices,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // ---------- DOT INDICATORS ----------
            Positioned(
              bottom: 14,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: controller.banners.asMap().entries.map((entry) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: _currentBannerIndex == entry.key ? 28 : 8,
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: _currentBannerIndex == entry.key
                          ? AppColors.white
                          : AppColors.white.withOpacity(0.4),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      }),
    );
  }
}