// lib/feature/ecommerce/home/widget/top_picks_widget.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../product/controller/ecommerce_product_controller.dart';
import '../../product/model/ecommerce_product_model.dart';
import '../../product/screen/ecommerce_product_screen.dart';

class TopPicksWidget extends StatelessWidget {
  const TopPicksWidget({super.key});

  static const Color _accent = Color(0xFFE63E3E);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EcommerceProductController>();
    controller.fetchFlashDeals();

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      child: Column(
        children: [
          // ---------- Header ----------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '🔥 Top Picks for You',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              GestureDetector(
                onTap: () => Get.to(() => const EcommerceProductListScreen(
                  title: 'Top Picks',
                )),
                behavior: HitTestBehavior.opaque,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Text(
                    'See All',
                    style: TextStyle(
                      fontSize: 12,
                      color: _accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // ---------- Content ----------
          Obx(() {
            if (controller.isFlashDealsLoading.value) {
              return const SizedBox(
                height: 190, // ✅ reduced
                child: _TopPicksShimmer(),
              );
            }

            final picks = controller.flashDeals.take(8).toList();

            if (picks.isEmpty) {
              return const SizedBox(
                height: 190,
                child: Center(
                  child: Text(
                    'No picks right now',
                    style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
                  ),
                ),
              );
            }

            return SizedBox(
              height: 150, // ✅ only 190px tall
              child: GridView.builder(
                scrollDirection: Axis.horizontal,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,        // ✅ single row
                  mainAxisSpacing: 12,      // horizontal gap between cards
                  crossAxisSpacing: 0,
                  childAspectRatio: 0.72,   // ✅ wide card: 190*0.72 = ~137 wide
                ),
                itemCount: picks.length,
                itemBuilder: (context, index) {
                  return _TopPickCard(product: picks[index]);
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ============================================================
// Product card — image TOP, content BOTTOM
// ============================================================
class _TopPickCard extends StatelessWidget {
  final EcommerceProductModel product;

  const _TopPickCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final price = double.tryParse(product.price) ?? 0;
    final oldPrice = double.tryParse(product.oldPrice) ?? 0;
    String? discountLabel;
    if (oldPrice > price && oldPrice > 0) {
      final pct = ((oldPrice - price) / oldPrice * 100).round();
      discountLabel = '$pct%';
    }

    final badgeText = (product.badge != null && product.badge!.isNotEmpty)
        ? product.badge!
        : discountLabel;

    return GestureDetector(
      onTap: () {

      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF8F8F8),
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ==================================================
            // ✅ IMAGE — top, expanded (fills available space)
            // ==================================================
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    product.primaryImage ?? '',
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Shimmer.fromColors(
                        baseColor: const Color(0xFFE8E8E8),
                        highlightColor: const Color(0xFFF5F5F5),
                        child: Container(color: Colors.white),
                      );
                    },
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported_rounded,
                          color: Colors.grey,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                  // Discount badge
                  if (badgeText != null)
                    Positioned(
                      top: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE63E3E),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          badgeText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // ==================================================
            // ✅ CONTENT — bottom, fixed natural height
            // ==================================================
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Title — 1 line (truncated)
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(width: 4),

                  // Price row
                  Row(
                    children: [
                      Text(
                        '₹${product.price}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE63E3E),
                        ),
                      ),
                      if (product.oldPrice != '0') ...[
                        const SizedBox(width: 4),
                        Text(
                          '₹${product.oldPrice}',
                          style: const TextStyle(
                            fontSize: 9,
                            color: Color(0xFF999999),
                            decoration: TextDecoration.lineThrough,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// Shimmer — matches real card shape
// ============================================================
class _TopPicksShimmer extends StatelessWidget {
  const _TopPicksShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE8E8E8),
      highlightColor: const Color(0xFFF5F5F5),
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          mainAxisSpacing: 12,
          crossAxisSpacing: 0,
          childAspectRatio: 0.72,
        ),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          );
        },
      ),
    );
  }
}