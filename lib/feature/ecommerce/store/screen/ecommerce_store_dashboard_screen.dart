// lib/feature/ecommerce/store/screen/ecommerce_store_dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/ecommerce_store_controller.dart';
import 'ecommerce_my_store_form_screen.dart';

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

  @override
  void initState() {
    super.initState();
    _storeCtrl = Get.find<EcommerceStoreController>();
  }

  Future<void> _openAddProduct() async {
    await Get.to(() => const EcommerceMyStoreFormScreen());
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

      // ✅ Ab yahan Scaffold aur AppBar nahi hai, seedha ListView return ho raha hai
      return ListView(
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
                      // Store Logo
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
                              children: const [
                                Icon(Icons.inventory_2_outlined,
                                    size: 14, color: Color(0xFF666666)),
                                SizedBox(width: 4),
                                Text(
                                  '0 products',
                                  style: TextStyle(
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
                child: const Text(
                  '0',
                  style: TextStyle(
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
          _emptyProducts(),
        ],
      );
    });
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