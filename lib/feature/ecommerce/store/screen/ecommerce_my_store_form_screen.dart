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
import '../../product/controller/ecommerce_product_controller.dart';
import '../../product/model/ecommerce_product_model.dart';
import '../../store/controller/ecommerce_store_controller.dart';


class EcommerceMyStoreFormScreen extends StatefulWidget {
  /// ✅ Agar product null nahi hai, to Edit mode me khulega
  final EcommerceProductModel? product;

  const EcommerceMyStoreFormScreen({super.key, this.product});

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
  bool isEditing = false;

  // ✅ Controllers
  late final EcommerceStoreController _storeCtrl;
  late final EcommerceCategoryController _catCtrl;
  late final EcommerceSubCategoryController _subCatCtrl;
  late final EcommerceProductController _productCtrl;

  EcommerceCategoryModel? _selectedCategory;
  EcommerceSubCategoryModel? _selectedSubCategory;

  // ✅ Images
  final List<XFile> _images = []; // Nayi images jo user select karega
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _storeCtrl = Get.find<EcommerceStoreController>();
    _catCtrl = Get.find<EcommerceCategoryController>();
    _subCatCtrl = Get.find<EcommerceSubCategoryController>();
    _productCtrl = Get.find<EcommerceProductController>();

    isEditing = widget.product != null;

    // Auto-fill agar edit mode hai
    if (isEditing) {
      _titleCtrl.text = widget.product!.title;
      _descCtrl.text = widget.product!.description;
      _priceCtrl.text = widget.product!.price;
      _oldPriceCtrl.text = widget.product!.oldPrice;
      _stockCtrl.text = widget.product!.stock.toString();
      _badgeCtrl.text = widget.product!.badge ?? '';
      _isActive = widget.product!.isActive;
    }

    // Setup Category
    _initStoreCategory();
  }

  void _initStoreCategory() {
    final store = _storeCtrl.store.value;
    if (store != null) {
      final match = _catCtrl.categories.firstWhereOrNull(
            (c) => c.id == store.storeCategory,
      );

      if (match != null) {
        setState(() => _selectedCategory = match);
        _subCatCtrl.fetchSubCategories(categoryId: match.id).then((_) {
          // Set sub-category if editing
          if (isEditing) {
            final subMatch = _subCatCtrl.subCategories.firstWhereOrNull(
                  (s) => s.id == widget.product!.subcategory,
            );
            if (subMatch != null) {
              setState(() => _selectedSubCategory = subMatch);
            }
          }
        });
      } else {
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

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedSubCategory == null) {
      FlutterToast.error('Please select a sub-category');
      return;
    }
    // Naye product me image zaruri hai, edit me optional hai
    if (!isEditing && _images.isEmpty) {
      FlutterToast.error('Please add at least one image');
      return;
    }

    final ok = await _productCtrl.saveProduct(
      productId: widget.product?.id, // null = create, id = update
      subcategoryId: _selectedSubCategory!.id,
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      price: _priceCtrl.text.trim(),
      oldPrice: _oldPriceCtrl.text.trim().isEmpty ? '0' : _oldPriceCtrl.text.trim(),
      stock: int.tryParse(_stockCtrl.text.trim()) ?? 0,
      badge: _badgeCtrl.text.trim(),
      isActive: _isActive,
      images: _images.map((x) => File(x.path)).toList(),
    );

    if (ok) {
      FlutterToast.success(isEditing ? 'Product updated!' : 'Product created!');
      Get.back(result: true);
    }
  }

  Future<void> _deleteProduct() async {
    Get.defaultDialog(
      title: 'Delete Product?',
      middleText: 'Are you sure you want to delete this product?',
      textConfirm: 'Delete',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        Get.back(); // Close Dialog
        final ok = await _productCtrl.deleteProduct(widget.product!.id);
        if (ok) {
          FlutterToast.success('Product deleted');
          Get.back(result: true);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = _storeCtrl.store.value;
    if (store == null) {
      return const Scaffold(body: Center(child: Text('Store not found')));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text(
          isEditing ? 'Edit Product' : 'Add Product',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: Colors.black),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black,),
        ),
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: _deleteProduct,
            ),
        ],
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

            _sectionTitle(isEditing ? 'Product Images (optional)' : 'Product Images *'),
            const SizedBox(height: 8),

            // Edit mode purani image dikhaye
            if (isEditing && _images.isEmpty && widget.product!.primaryImage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(widget.product!.primaryImage!, height: 90, width: 90, fit: BoxFit.cover),
                ),
              ),

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
              child: Obx(() => ElevatedButton.icon(
                onPressed: _productCtrl.isSaving.value ? null : _saveProduct,
                icon: _productCtrl.isSaving.value
                    ? const SizedBox(
                  width: 16, height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
                    : const Icon(Icons.check, size: 18),
                label: Text(
                  _productCtrl.isSaving.value
                      ? 'Saving...'
                      : (isEditing ? 'Update Product' : 'Save Product'),
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              )),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String t) => Text(
    t,
    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF333333)),
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
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF333333)),
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
              style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: _accent),
            ),
          ),
        ],
      ),
    );
  }

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
              SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: _accent)),
              SizedBox(width: 10),
              Text('Loading sub-categories...', style: TextStyle(fontSize: 12, color: Color(0xFF999999))),
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
                child: Text('No sub-categories found for this category.', style: TextStyle(fontSize: 11, color: _accent)),
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
            hint: const Text('Select sub-category', style: TextStyle(fontSize: 13, color: Color(0xFF999999))),
            items: subs.map((s) {
              return DropdownMenuItem(value: s, child: Text(s.title, style: const TextStyle(fontSize: 13)));
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
                border: Border.all(color: _accent.withOpacity(0.4), width: 1.5),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo_outlined, color: _accent, size: 22),
                  SizedBox(height: 4),
                  Text('Add', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: _accent)),
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
                    image: DecorationImage(image: FileImage(File(file.path)), fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 12,
                  child: GestureDetector(
                    onTap: () => _removeImage(i),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
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