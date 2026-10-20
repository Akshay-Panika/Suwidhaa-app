// lib/feature/ecommerce/home/widget/flash_deals_widget.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../product/controller/ecommerce_product_controller.dart';
import '../../product/model/ecommerce_product_model.dart';
import '../../product/screen/ecommerce_product_details_screen.dart';
import '../../product/screen/ecommerce_product_screen.dart';

class FlashDealsWidget extends StatefulWidget {
  const FlashDealsWidget({super.key});

  @override
  State<FlashDealsWidget> createState() => _FlashDealsWidgetState();
}

class _FlashDealsWidgetState extends State<FlashDealsWidget> {
  static const Color _accent = Color(0xFFE63E3E);

  late final EcommerceProductController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<EcommerceProductController>();
    // Trigger fetch immediately (not post-frame) so first build sees loading
    controller.fetchFlashDeals();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Card(
        elevation: 0.1,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------- Header ----------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.flash_on_rounded, color: _accent),
                      SizedBox(width: 4),
                      Text(
                        'Flash Deals',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(() =>  EcommerceProductListScreen(
                        title: 'Flash Deals',
                      ));
                    },
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
              const SizedBox(height: 12),

              // ---------- Content ----------
              Obx(() {
                // Loading
                if (controller.isFlashDealsLoading.value) {
                  return const SizedBox(
                    height: 140,
                    child: _FlashDealsShimmer(),
                  );
                }

                // Empty / error
                final deals = controller.visibleFlashDeals;
                if (deals.isEmpty) {
                  return const SizedBox(
                    height: 140,
                    child: Center(
                      child: Text(
                        'No flash deals right now',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF999999),
                        ),
                      ),
                    ),
                  );
                }

                // Data
                return SizedBox(
                  height: 140,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: deals.length,
                    itemBuilder: (context, index) {
                      return _FlashDealCard(product: deals[index]);
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// Single flash deal card
// ============================================================
class _FlashDealCard extends StatelessWidget {
  final EcommerceProductModel product;

  const _FlashDealCard({required this.product});

  @override
  Widget build(BuildContext context) {
    // Controller read-only — koi change nahi
    final controller = Get.find<EcommerceProductController>();

    // Auto-calc discount % from oldPrice vs price
    final price = double.tryParse(product.price) ?? 0;
    final oldPrice = double.tryParse(product.oldPrice) ?? 0;
    String? discountLabel;
    if (oldPrice > price && oldPrice > 0) {
      final pct = ((oldPrice - price) / oldPrice * 100).round();
      discountLabel = '$pct%';
    }

    return InkWell(
      onTap: () => Get.to(() => EcommerceProductDetailsScreen(productId: product.id)),
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F8F8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------- IMAGE (Stack so we can Position badge + fav) ----------------
            Expanded(
              child: ClipRRect(
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(12)),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      product.primaryImage ?? '',
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Container(color: const Color(0xFFE8E8E8));
                      },
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.image, color: Colors.grey),
                      ),
                    ),

                    // Badge / discount
                    if ((product.badge != null &&
                        product.badge!.isNotEmpty) ||
                        discountLabel != null)
                      Positioned(
                        top: 4,
                        left: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE63E3E),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            product.badge?.isNotEmpty == true
                                ? product.badge!
                                : discountLabel!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                    // ⚡ FAVORITE BUTTON
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () => controller.toggleFavorite(product.id),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            product.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 14,
                            color: product.isFavorite
                                ? const Color(0xFFE63E3E)
                                : const Color(0xFF666666),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ---------------- TITLE + PRICE ----------------
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF333333),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '₹${product.price}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE63E3E),
                        ),
                      ),
                      const SizedBox(width: 4),
                      if (oldPrice > 0 && oldPrice > price)
                        Text(
                          '₹${product.oldPrice}',
                          style: const TextStyle(
                            fontSize: 9,
                            color: Color(0xFF999999),
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
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
// Shimmer for horizontal flash deals list
// ============================================================
class _FlashDealsShimmer extends StatelessWidget {
  const _FlashDealsShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE8E8E8),
      highlightColor: const Color(0xFFF5F5F5),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            width: 150,
            margin: const EdgeInsets.only(right: 12),
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