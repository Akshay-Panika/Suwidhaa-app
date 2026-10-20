// lib/feature/ecommerce/product/screen/ecommerce_product_favorite_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../controller/ecommerce_product_controller.dart';
import '../model/ecommerce_product_model.dart';
import 'ecommerce_product_details_screen.dart';

class EcommerceProductFavoriteScreen extends StatefulWidget {
  const EcommerceProductFavoriteScreen({super.key});

  @override
  State<EcommerceProductFavoriteScreen> createState() =>
      _EcommerceProductFavoriteScreenState();
}

class _EcommerceProductFavoriteScreenState
    extends State<EcommerceProductFavoriteScreen> {
  late final EcommerceProductController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<EcommerceProductController>();

    // ✅ Trigger fetch IMMEDIATELY (not post-frame) so first build sees loading state
    controller.fetchFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: Colors.black87,
        title: const Text(
          'My Favorites',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => controller.fetchFavorites(),
          ),
        ],
      ),
      body: Obx(() {
        // ✅ 1. Show shimmer whenever:
        //    - API is in flight, OR
        //    - We are NOT in favorites mode yet (stale list data), OR
        //    - Favorites have not been fetched once for this mode
        final isWrongMode = !controller.isViewingFavorites.value;
        final notFetchedYet = !controller.hasFetchedOnce.value;

        if (controller.isLoading.value || isWrongMode || notFetchedYet) {
          return const _FavoriteShimmerGrid();
        }

        // ✅ 2. Empty state (only after a real favorites fetch)
        if (controller.products.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border_rounded,
                      size: 64, color: Color(0xFFCCCCCC)),
                  SizedBox(height: 12),
                  Text(
                    'No Favorites Yet',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF666666)),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Products you mark as favorite will appear here.',
                    style:
                    TextStyle(fontSize: 12, color: Color(0xFF999999)),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        // ✅ 3. Data Grid
        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
          itemCount: controller.products.length,
          itemBuilder: (context, index) {
            final product = controller.products[index];
            return _FavoriteProductCard(
              product: product,
              onRemove: () => controller.toggleFavorite(product.id),
            );
          },
        );
      }),
    );
  }
}

class _FavoriteProductCard extends StatelessWidget {
  final EcommerceProductModel product;
  final VoidCallback onRemove;

  const _FavoriteProductCard({required this.product, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => EcommerceProductDetailsScreen(productId: product.id)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12)),
                    child: Image.network(
                      product.primaryImage ?? '',
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: Icon(Icons.image_not_supported_rounded,
                              color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  if (product.badge != null && product.badge!.isNotEmpty)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE63E3E),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          product.badge!,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: onRemove,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                        child: const Icon(Icons.favorite,
                            size: 16, color: Color(0xFFE63E3E)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF333333)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '₹${product.price}',
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFE63E3E)),
                      ),
                      const SizedBox(width: 4),
                      if (product.oldPrice != '0')
                        Text(
                          '₹${product.oldPrice}',
                          style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFF999999),
                              decoration: TextDecoration.lineThrough),
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

class _FavoriteShimmerGrid extends StatelessWidget {
  const _FavoriteShimmerGrid();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE8E8E8),
      highlightColor: const Color(0xFFF5F5F5),
      child: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
        ),
        itemCount: 4,
        itemBuilder: (context, index) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}