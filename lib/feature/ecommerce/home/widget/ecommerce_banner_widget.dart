// lib/feature/ecommerce/banner/widget/ecommerce_banner_widget.dart

import 'package:carousel_slider_plus/carousel_controller.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../controller/ecommerce_banner_controller.dart';

class EcommerceBannerWidget extends StatefulWidget {
  const EcommerceBannerWidget({super.key});

  @override
  State<EcommerceBannerWidget> createState() => _EcommerceBannerWidgetState();
}

class _EcommerceBannerWidgetState extends State<EcommerceBannerWidget> {
  static const double _height = 180;

  final CarouselSliderController _carouselController =
  CarouselSliderController();
  int _currentBannerIndex = 0;

  late final EcommerceBannerController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<EcommerceBannerController>();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final banners = controller.banners;

      // ---- Shimmer loading ----
      if (controller.isLoading.value && banners.isEmpty) {
        return const _BannerShimmer();
      }

      // ---- Empty ----
      if (banners.isEmpty) {
        return const SizedBox(
          height: _height,
          child: Center(child: Text('No banners available')),
        );
      }

      // Clamp indicator index if the list shrank
      if (_currentBannerIndex >= banners.length) {
        _currentBannerIndex = 0;
      }

      return SizedBox(
        height: _height,
        child: Stack(
          children: [
            CarouselSlider(
              controller: _carouselController,
              options: CarouselOptions(
                height: _height,
                viewportFraction: 1.0,
                enableInfiniteScroll: banners.length > 1,
                autoPlay: banners.length > 1,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 600),
                pauseAutoPlayOnTouch: true,
                onPageChanged: (index, reason) {
                  setState(() => _currentBannerIndex = index);
                },
              ),
              items: banners.map((banner) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      banner.bannerImage,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        // Per-image shimmer while downloading
                        return Shimmer.fromColors(
                          baseColor: const Color(0xFFE8E8E8),
                          highlightColor: const Color(0xFFF5F5F5),
                          child: Container(color: Colors.white),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: Icon(
                            Icons.broken_image,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),

            // ✅ Indicator dots
            if (banners.length > 1)
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: banners.asMap().entries.map((entry) {
                    final isActive = _currentBannerIndex == entry.key;
                    return GestureDetector(
                      onTap: () =>
                          _carouselController.animateToPage(entry.key),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: isActive ? 24 : 8,
                        height: 6,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: isActive
                              ? Colors.white
                              : Colors.white.withOpacity(0.4),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      );
    });
  }
}

// ============================================================
// Shimmer skeleton for banner
// ============================================================
class _BannerShimmer extends StatelessWidget {
  const _BannerShimmer();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _EcommerceBannerWidgetState._height,
      child: Shimmer.fromColors(
        baseColor: const Color(0xFFE8E8E8),
        highlightColor: const Color(0xFFF5F5F5),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}