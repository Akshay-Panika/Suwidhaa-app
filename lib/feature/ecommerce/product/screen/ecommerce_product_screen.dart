// lib/feature/ecommerce/product/screen/ecommerce_product_list_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../controller/ecommerce_product_controller.dart';
import '../model/ecommerce_product_model.dart';
// lib/feature/ecommerce/product/screen/ecommerce_product_list_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../controller/ecommerce_product_controller.dart';
import '../model/ecommerce_product_model.dart';
import 'ecommerce_product_details_screen.dart';

class EcommerceProductListScreen extends StatefulWidget {
  final int? subcategoryId;
  final String? title;

  const EcommerceProductListScreen({
    super.key,
    this.subcategoryId,
    this.title,
  });

  @override
  State<EcommerceProductListScreen> createState() => _EcommerceProductListScreenState();
}

class _EcommerceProductListScreenState extends State<EcommerceProductListScreen> {
  late final EcommerceProductController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<EcommerceProductController>();

    // ✅ Trigger fetch after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchProducts(subcategoryId: widget.subcategoryId);
    });
  }

  @override
  void didUpdateWidget(covariant EcommerceProductListScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.subcategoryId != widget.subcategoryId) {
      controller.fetchProducts(subcategoryId: widget.subcategoryId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: Colors.black87,
        title: Text(
            widget.title ?? 'All Products',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18)
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => controller.fetchProducts(subcategoryId: widget.subcategoryId),
          ),
        ],
      ),
      body: Obx(() {
        // ✅ 1. Loading OR First time open (no data yet) → Show Shimmer
        if (controller.isLoading.value || (!controller.hasFetchedOnce.value && controller.products.isEmpty)) {
          return const _ProductShimmerGrid();
        }

        // ✅ 2. Data loaded but list empty → Show Empty State
        if (controller.products.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 12),
                Text(
                  'No products found',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          );
        }

        // ✅ 3. Data Grid
        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 0.75, mainAxisSpacing: 12, crossAxisSpacing: 12,
          ),
          itemCount: controller.products.length,
          itemBuilder: (context, index) {
            final product = controller.products[index];
            return _ProductCard(
              product: product,
              onFavoriteTap: () => controller.toggleFavorite(product.id,),
            );
          },
        );
      }),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final EcommerceProductModel product;
  final VoidCallback onFavoriteTap;

  const _ProductCard({required this.product, required this.onFavoriteTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => EcommerceProductDetailsScreen(productId: product.id)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      product.primaryImage ?? '',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (_, __, ___) => Container(color: Colors.grey[200], child: const Icon(Icons.image, color: Colors.grey)),
                    ),
                  ),
                  if (product.badge != null && product.badge!.isNotEmpty)
                    Positioned(
                      top: 8, left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: const Color(0xFFE63E3E), borderRadius: BorderRadius.circular(4)),
                        child: Text(product.badge!, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  Positioned(
                    top: 8, right: 8,
                    child: GestureDetector(
                      onTap: onFavoriteTap,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: Icon(
                          product.isFavorite ? Icons.favorite : Icons.favorite_border,
                          size: 16,
                          color: product.isFavorite ? const Color(0xFFE63E3E) : const Color(0xFF666666),
                        ),
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
                  Text(product.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF333333)), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text('₹${product.price}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFFE63E3E))),
                      const SizedBox(width: 4),
                      if (product.oldPrice != '0')
                        Text('₹${product.oldPrice}', style: const TextStyle(fontSize: 10, color: Color(0xFF999999), decoration: TextDecoration.lineThrough)),
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

class _ProductShimmerGrid extends StatelessWidget {
  const _ProductShimmerGrid();
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE8E8E8),
      highlightColor: const Color(0xFFF5F5F5),
      child: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 0.75, mainAxisSpacing: 12, crossAxisSpacing: 12,
        ),
        itemCount: 6,
        itemBuilder: (_, __) => Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12))),
      ),
    );
  }
}