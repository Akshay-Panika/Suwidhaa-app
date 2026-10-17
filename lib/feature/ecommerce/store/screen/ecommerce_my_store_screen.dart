// lib/feature/ecommerce/store/screen/my_store_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/core/widget/flutter_toast.dart';
import 'ecommerce_store_dashboard_screen.dart';
import 'ecommerce_store_setup_screen.dart';
import '../controller/ecommerce_store_controller.dart';

class EcommerceMyStoreScreen extends StatefulWidget {
  const EcommerceMyStoreScreen({super.key});

  @override
  State<EcommerceMyStoreScreen> createState() => _EcommerceMyStoreScreenState();
}

class _EcommerceMyStoreScreenState extends State<EcommerceMyStoreScreen> {
  late final EcommerceStoreController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<EcommerceStoreController>();

    // ✅ Safety: Har baar screen load hone par ek baar check kar lo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.store.value == null) {
        controller.checkStore();
      }
    });
  }

  // ✅ Edit Store Function
  Future<void> _openEdit() async {
    await Get.to(() => const EcommerceStoreSetupScreen());
  }

  // ✅ Delete Store Bottom Sheet Function
  void _showDeleteBottomSheet() {
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
              'Delete Store?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Are you sure you want to delete this store permanently? This action cannot be undone.',
              textAlign: TextAlign.center,
              style: TextStyle(
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
                      Get.back();
                      final ok = await controller.deleteStore();
                      if (ok) {
                        FlutterToast.success("Store deleted successfully");
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
            'My Store',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)
        ),
        leading: const Icon(Icons.storefront_rounded),
        actions: [
          // ✅ Edit & Delete Buttons (sirf tab dikhenge jab store ho)
          Obx(() {
            if (!controller.hasStore) return const SizedBox();
            return Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: _openEdit,
                  tooltip: 'Edit store',
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: _showDeleteBottomSheet,
                  tooltip: 'Delete store',
                ),
              ],
            );
          }),
        ],
      ),
      body: Obx(() {
        // Loading State
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Store exists → Dashboard
        if (controller.hasStore) {
          return const EcommerceStoreDashboardScreen();
        }

        // No Store → Default Screen
        return _NoStoreScreen(onCreate: () => Get.to(() => const EcommerceStoreSetupScreen()));
      }),
    );
  }
}

class _NoStoreScreen extends StatelessWidget {
  final VoidCallback onCreate;
  const _NoStoreScreen({required this.onCreate});
  static const Color _accent = Color(0xFFE63E3E);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.grey.shade50,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _accent.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.storefront_outlined,
                  size: 56,
                  color: _accent,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'No Store Found',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2D2D2D),
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "You don't have a store yet. Create your store to start selling products.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF757575),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32),
              Column(
                children: [
                  _buildSimplePoint('Select your category'),
                  const SizedBox(height: 10),
                  _buildSimplePoint('Add products with images'),
                  const SizedBox(height: 10),
                  _buildSimplePoint('Start receiving orders'),
                ],
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: onCreate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _accent,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Create Your Store',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSimplePoint(String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.check_circle_rounded, color: Colors.green, size: 18),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF666666),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}