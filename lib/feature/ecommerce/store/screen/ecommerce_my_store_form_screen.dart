// lib/feature/ecommerce/product/screen/add_product_screen.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../category/controller/ecommerce_category_controller.dart';
import '../../category/model/ecommerce_category_model.dart';
import '../../category/controller/ecommerce_subcategory_controller.dart';
import '../../category/model/ecommerce_subcategory_model.dart';
import '../../../../core/widget/flutter_toast.dart';
import '../../store/controller/ecommerce_store_controller.dart';

class EcommerceMyStoreFormScreen extends StatefulWidget {
  const EcommerceMyStoreFormScreen({super.key});

  @override
  State<EcommerceMyStoreFormScreen> createState() =>
      _EcommerceMyStoreFormScreenState();
}

class _EcommerceMyStoreFormScreenState extends State<EcommerceMyStoreFormScreen> {
  static const Color _accent = Color(0xFFE63E3E);

  final _formKey = GlobalKey<FormState>();

  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _oldPriceCtrl = TextEditingController();
  final _stockCtrl = TextEditingController();
  final _badgeCtrl = TextEditingController();

  bool _isActive = true;
  bool _isSubmitting = false;

  // ✅ Controllers
  late final EcommerceStoreController _storeCtrl;
  late final EcommerceCategoryController _catCtrl;
  late final EcommerceSubCategoryController _subCatCtrl;

  EcommerceCategoryModel? _selectedCategory;
  EcommerceSubCategoryModel? _selectedSubCategory;

  final List<XFile> _images = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _storeCtrl = Get.find<EcommerceStoreController>();
    _catCtrl = Get.find<EcommerceCategoryController>();
    _subCatCtrl = Get.find<EcommerceSubCategoryController>();

    // ✅ Auto-select store's category and fetch sub-categories
    _initStoreCategory();
  }

  void _initStoreCategory() {
    final store = _storeCtrl.store.value;
    if (store != null) {
      // Find category in API list
      final match = _catCtrl.categories.firstWhereOrNull(
            (c) => c.id == store.storeCategory,
      );

      if (match != null) {
        setState(() => _selectedCategory = match);
        _subCatCtrl.fetchSubCategories(categoryId: match.id);
      } else {
        // Agar API me category load hone me time lag raha ho
        ever<List<EcommerceCategoryModel>>(_catCtrl.categories, (_) {
          _initStoreCategory();
        });
      }
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    _oldPriceCtrl.dispose();
    _stockCtrl.dispose();
    _badgeCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final files = await _picker.pickMultiImage(imageQuality: 80);
    if (files.isEmpty) return;
    setState(() => _images.addAll(files));
  }

  void _removeImage(int i) {
    setState(() => _images.removeAt(i));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedSubCategory == null) {
      FlutterToast.error('Please select a sub-category');
      return;
    }
    if (_images.isEmpty) {
      FlutterToast.error('Please add at least one image');
      return;
    }

    setState(() => _isSubmitting = true);

    // ⚠️ YAHAN PRODUCT CREATE API LAGEGI (Future)
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    FlutterToast.success('Product added successfully');
    Get.back(result: true);
  }

  @override
  Widget build(BuildContext context) {
    final store = _storeCtrl.store.value;
    if (store == null) {
      return const Scaffold(
        body: Center(child: Text('Store not found')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: Colors.black87,
        title: const Text(
          'Add Product',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios))
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            // Store Banner
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _accent.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.storefront, color: _accent, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Adding product to',
                          style: TextStyle(fontSize: 10, color: Color(0xFF999999)),
                        ),
                        Text(
                          store.storeName,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF333333),
                          ),
                        ),
                        Text(
                          'Category: ${store.storeCategoryDetail?.title ?? ''}',
                          style: TextStyle(
                            fontSize: 10,
                            color: _accent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            _sectionTitle('Product Images *'),
            const SizedBox(height: 8),
            Center(child: _buildImageRow()),
            const SizedBox(height: 16),

            _sectionTitle('Basic Info'),
            const SizedBox(height: 8),
            _field(_titleCtrl, 'Product Title *',
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Title required' : null),
            const SizedBox(height: 10),
            _field(_descCtrl, 'Description', maxLines: 3),
            const SizedBox(height: 16),

            _sectionTitle('Category (Locked)'),
            const SizedBox(height: 8),
            _buildLockedCategory(),
            const SizedBox(height: 16),

            _sectionTitle('Sub-Category *'),
            const SizedBox(height: 8),
            _buildSubCategoryDropdown(),
            const SizedBox(height: 16),

            _sectionTitle('Pricing & Stock'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _field(
                    _priceCtrl,
                    'Price (₹) *',
                    keyboard: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Price required';
                      if (double.tryParse(v) == null) return 'Invalid price';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _field(
                    _oldPriceCtrl,
                    'Old Price (₹)',
                    keyboard: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _field(
                    _stockCtrl,
                    'Stock *',
                    keyboard: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Stock required';
                      if (int.tryParse(v) == null) return 'Invalid';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _field(_badgeCtrl, 'Badge (e.g. 50% OFF)'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Active Toggle
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: SwitchListTile(
                value: _isActive,
                onChanged: (v) => setState(() => _isActive = v),
                activeColor: _accent,
                title: const Text('Active',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                subtitle: const Text('Show this product in your store',
                    style: TextStyle(fontSize: 11)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
            const SizedBox(height: 20),

            // Submit Button
            SizedBox(
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _isSubmitting ? null : _submit,
                icon: _isSubmitting
                    ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : const Icon(Icons.check, size: 18),
                label: Text(
                  _isSubmitting ? 'Saving...' : 'Save Product',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String t) => Text(
    t,
    style: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w700,
      color: Color(0xFF333333),
    ),
  );

  Widget _field(
      TextEditingController c,
      String hint, {
        TextInputType? keyboard,
        int maxLines = 1,
        String? Function(String?)? validator,
      }) {
    return TextFormField(
      controller: c,
      keyboardType: keyboard,
      maxLines: maxLines,
      validator: validator,
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF999999)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _accent, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
      ),
    );
  }

  // ✅ Category Display (API)
  Widget _buildLockedCategory() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Row(
        children: [
          Icon(Icons.category_rounded, size: 18, color: _accent),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _selectedCategory?.title ?? 'Loading...',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: _accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'Locked',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: _accent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Sub-category Dropdown (API)
  Widget _buildSubCategoryDropdown() {
    return Obx(() {
      if (_subCatCtrl.isLoading.value) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFEEEEEE)),
          ),
          child: const Row(
            children: [
              SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(strokeWidth: 2, color: _accent),
              ),
              SizedBox(width: 10),
              Text('Loading sub-categories...',
                  style: TextStyle(fontSize: 12, color: Color(0xFF999999))),
            ],
          ),
        );
      }

      final subs = _subCatCtrl.subCategories;
      if (subs.isEmpty) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF3F3),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _accent.withOpacity(0.3)),
          ),
          child: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, size: 16, color: _accent),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'No sub-categories found for this category.',
                  style: TextStyle(fontSize: 11, color: _accent),
                ),
              ),
            ],
          ),
        );
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFEEEEEE)),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<EcommerceSubCategoryModel>(
            value: _selectedSubCategory,
            isExpanded: true,
            hint: const Text(
              'Select sub-category',
              style: TextStyle(fontSize: 13, color: Color(0xFF999999)),
            ),
            items: subs.map((s) {
              return DropdownMenuItem(
                value: s,
                child: Text(s.title, style: const TextStyle(fontSize: 13)),
              );
            }).toList(),
            onChanged: (v) => setState(() => _selectedSubCategory = v),
          ),
        ),
      );
    });
  }

  Widget _buildImageRow() {
    return SizedBox(
      height: 90,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          GestureDetector(
            onTap: _pickImages,
            child: Container(
              width: 90,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _accent.withOpacity(0.4),
                  width: 1.5,
                ),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo_outlined, color: _accent, size: 22),
                  SizedBox(height: 4),
                  Text(
                    'Add',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: _accent,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ..._images.asMap().entries.map((entry) {
            final i = entry.key;
            final file = entry.value;
            return Stack(
              children: [
                Container(
                  width: 90,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: FileImage(File(file.path)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 12,
                  child: GestureDetector(
                    onTap: () => _removeImage(i),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, size: 14, color: Colors.white),
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}