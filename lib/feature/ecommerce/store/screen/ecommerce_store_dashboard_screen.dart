// lib/feature/ecommerce/store/screen/ecommerce_store_dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/ecommerce_store_controller.dart';
import '../../product/controller/ecommerce_product_controller.dart';
import '../../product/model/ecommerce_product_model.dart';
import 'ecommerce_my_store_form_screen.dart';
import '../../../../core/widget/flutter_toast.dart'; // ✅ Toast import kiya

class EcommerceStoreDashboardScreen extends StatefulWidget {
  const EcommerceStoreDashboardScreen({super.key});

  @override
  State<EcommerceStoreDashboardScreen> createState() =>
      _EcommerceStoreDashboardScreenState();
}

class _EcommerceStoreDashboardScreenState
    extends State<EcommerceStoreDashboardScreen> {
  static const Color _accent = Color(0xFFE63E3E);

  late final EcommerceStoreController _storeCtrl;
  late final EcommerceProductController _productCtrl;

  @override
  void initState() {
    super.initState();
    _storeCtrl = Get.find<EcommerceStoreController>();
    _productCtrl = Get.find<EcommerceProductController>();

    // ✅ Fetch Products from API on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _productCtrl.fetchOwnerProducts();
    });
  }

  Future<void> _openAddProduct() async {
    await Get.to(() => const EcommerceMyStoreFormScreen());
    _productCtrl.fetchOwnerProducts();
  }

  // ✅ Edit Product
  Future<void> _openEditProduct(EcommerceProductModel product) async {
    await Get.to(() => EcommerceMyStoreFormScreen(product: product));
    _productCtrl.fetchOwnerProducts();
  }

  // ✅ Delete Product Bottom Sheet
  void _showDeleteProductSheet(EcommerceProductModel product) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.delete_forever_rounded,
                color: Colors.red,
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Delete Product?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Are you sure you want to delete "${product.title}" permanently?',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      Get.back(); // Close bottom sheet
                      final ok = await _productCtrl.deleteProduct(product.id);
                      if (ok) {
                        FlutterToast.success("Product deleted successfully");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Yes, Delete',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      isScrollControlled: true,
      isDismissible: true,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final store = _storeCtrl.store.value;

      if (_storeCtrl.isLoading.value && store == null) {
        return const Center(child: CircularProgressIndicator());
      }

      if (store == null) {
        return const Center(child: Text('Store not found. Please refresh.'));
      }

      final products = _productCtrl.ownerProducts;
      final isLoadingProducts = _productCtrl.isOwnerLoading.value;

      return RefreshIndicator(
        onRefresh: () async => await _productCtrl.fetchOwnerProducts(),
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            // ============ Store header card ============
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Gradient header
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [_accent, Color(0xFFFF6E6E)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius:
                      BorderRadius.vertical(top: Radius.circular(14)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            image: store.storeLogo != null && store.storeLogo!.isNotEmpty
                                ? DecorationImage(
                              image: NetworkImage(store.storeLogo!),
                              fit: BoxFit.cover,
                            )
                                : null,
                          ),
                          child: store.storeLogo == null || store.storeLogo!.isEmpty
                              ? const Icon(Icons.storefront_rounded,
                              color: Colors.white, size: 24)
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      store.storeName,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 1),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.25),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'Active',
                                      style: TextStyle(
                                        fontSize: 8,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'Category: ${store.storeCategoryDetail?.title ?? 'Unknown'}',
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Body
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      children: [
                        _infoRow(Icons.location_on_outlined, store.storeAddress),
                        const SizedBox(height: 6),
                        _infoRow(Icons.phone_outlined, store.storePhone),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.inventory_2_outlined,
                                      size: 14, color: Color(0xFF666666)),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${products.length} products', // ✅ Dynamic count
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF666666),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: _openAddProduct,
                              behavior: HitTestBehavior.opaque,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: _accent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.add,
                                        color: Colors.white, size: 16),
                                    SizedBox(width: 4),
                                    Text(
                                      'Add Product',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
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
            const SizedBox(height: 16),

            // ============ Products heading ============
            Row(
              children: [
                const Text(
                  'My Products',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(
                    color: _accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${products.length}', // ✅ Dynamic count
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: _accent,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // ============ Products list ============
            if (isLoadingProducts)
              const Padding(
                padding: EdgeInsets.all(30),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (products.isEmpty)
              _emptyProducts()
            else
              ...products.map((p) => _buildProductCard(p)).toList(),
          ],
        ),
      );
    });
  }

  // ✅ Product Card with Edit & Delete buttons
  Widget _buildProductCard(EcommerceProductModel product) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              product.primaryImage ?? '',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 80,
                height: 80,
                color: Colors.grey.shade100,
                child: const Icon(Icons.image, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Stock: ${product.stock}  •  ${product.subcategoryDetail?.title ?? ''}',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      '₹${product.price}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: _accent,
                      ),
                    ),
                    if (product.oldPrice != '0') ...[
                      const SizedBox(width: 6),
                      Text(
                        '₹${product.oldPrice}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // ✅ Edit & Delete Actions
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: Colors.blue, size: 20),
                onPressed: () => _openEditProduct(product),
                constraints: const BoxConstraints(), // Padding tight karne ke liye
                padding: const EdgeInsets.all(8),
                tooltip: 'Edit Product',
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                onPressed: () => _showDeleteProductSheet(product),
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(8),
                tooltip: 'Delete Product',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _emptyProducts() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(Icons.inventory_2_outlined,
              size: 56, color: _accent.withOpacity(0.3)),
          const SizedBox(height: 10),
          const Text(
            'No products yet',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Tap "Add Product" to list your first product',
            style: TextStyle(fontSize: 11, color: Color(0xFF999999)),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    if (text.isEmpty) return const SizedBox.shrink();
    return Row(
      children: [
        Icon(icon, size: 14, color: const Color(0xFF999999)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 12, color: Color(0xFF666666)),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}