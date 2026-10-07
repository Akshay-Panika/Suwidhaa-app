import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:shimmer/shimmer.dart';
import '../../services/screen/donation_details_screen.dart';
import '../controller/ngo_banner_controller.dart';

class NgoBannerWidget extends StatelessWidget {
  const NgoBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final NgoBannerController controller = Get.find<NgoBannerController>();
    return Obx(() {
      if (controller.isLoading.value && controller.banners.isEmpty) {
        return SizedBox(
          height: 200,
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(child: Container(color: Colors.teal,)),
                  Expanded(child: Container(color: Colors.white,)),
                ],
              ),
              /// Shimer
              Shimmer.fromColors(
                baseColor: Colors.white,
                highlightColor: Colors.grey.shade200,
                child: Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                    borderRadius: BorderRadius.circular(12)
                  ),
                ),
              )
            ],
          ),
        );
      }

      return SizedBox(
        height: 200,
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(child: Container(color: Colors.teal,)),
                Expanded(child: Container(color: Colors.white,)),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: CarouselSlider(
                items: controller.banners.map((banner) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      banner.bannerImage,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      gaplessPlayback: true,                  // ✅ keeps old frame until new loads
                      frameBuilder: (context, child, frame, wasSync) {
                        if (wasSync || frame != null) return child;
                        return  Shimmer.fromColors(
                          baseColor: Colors.white,
                          highlightColor: Colors.grey.shade200,
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12)
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.teal.withOpacity(0.08),
                        child: const Icon(Icons.broken_image, size: 50, color: Colors.teal),
                      ),
                    ),
                  );
                }).toList(),
                options: CarouselOptions(
                  height: 180,
                  viewportFraction: 1,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 4),
                  enableInfiniteScroll: true,
                  pauseAutoPlayOnTouch: false,
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}


