import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/core/widget/flutter_toast.dart';
import '../../category/controller/ecommerce_category_controller.dart';
import '../../category/model/ecommerce_category_model.dart';
import '../controller/ecommerce_store_controller.dart';

class EcommerceStoreSetupScreen extends StatefulWidget {
  const EcommerceStoreSetupScreen({super.key});

  @override
  State<EcommerceStoreSetupScreen> createState() => _EcommerceStoreSetupScreenState();
}

class _EcommerceStoreSetupScreenState extends State<EcommerceStoreSetupScreen> {
  static const Color _accent = Color(0xFFE63E3E);

  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  EcommerceCategoryModel? _selectedCategory;
  File? _selectedLogo;

  late final EcommerceStoreController _storeCtrl;
  late final EcommerceCategoryController _catCtrl;

  bool get isEditing => _storeCtrl.store.value != null;

  @override
  void initState() {
    super.initState();
    _storeCtrl = Get.find<EcommerceStoreController>();
    _catCtrl = Get.find<EcommerceCategoryController>();

    // Pre-fill if editing
    final existing = _storeCtrl.store.value;
    if (existing != null) {
      _nameCtrl.text = existing.storeName;
      _addressCtrl.text = existing.storeAddress;
      _phoneCtrl.text = existing.storePhone;
      // find category
      for(var c in _catCtrl.categories) {
        if(c.id == existing.storeCategory) {
          _selectedCategory = c;
          break;
        }
      }
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _addressCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickLogo() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (file != null) {
      setState(() => _selectedLogo = File(file.path));
    }
  }

  Future<void> _saveStore() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == null) {
      FlutterToast.error("Please select a category");
      return;
    }

    bool ok;
    if (isEditing) {
      ok = await _storeCtrl.updateStore(
        name: _nameCtrl.text.trim(),
        address: _addressCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        categoryId: _selectedCategory!.id,
        logo: _selectedLogo,
      );
    } else {
      ok = await _storeCtrl.createStore(
        name: _nameCtrl.text.trim(),
        address: _addressCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        categoryId: _selectedCategory!.id,
        logo: _selectedLogo,
      );
    }

    if (ok) {
      Get.back(); // Go back to MyStoreScreen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: Colors.black87,
        title: Text(
          isEditing ? 'Edit Store' : 'Setup Your Store',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Logo Picker (Optional but API supports it)
            Center(
              child: GestureDetector(
                onTap: _pickLogo,
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: _accent.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: _accent.withOpacity(0.3), width: 2),
                    image: _selectedLogo != null
                        ? DecorationImage(image: FileImage(_selectedLogo!), fit: BoxFit.cover)
                        : null,
                  ),
                  child: _selectedLogo == null
                      ? const Icon(Icons.add_a_photo, color: _accent, size: 30)
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Store name
            _label('Store Name *'),
            const SizedBox(height: 6),
            _field(_nameCtrl, 'e.g. Sharma Cloth Store', validator: (v) => (v == null || v.trim().isEmpty) ? 'Name required' : null),
            const SizedBox(height: 16),

            // Category
            _label('Which category does your store sell? *'),
            const SizedBox(height: 6),
            Obx(() {
              if (_catCtrl.isLoading.value && _catCtrl.categories.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFEEEEEE)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<EcommerceCategoryModel>(
                    value: _selectedCategory,
                    isExpanded: true,
                    hint: const Text('Select your category', style: TextStyle(fontSize: 13, color: Color(0xFF999999))),
                    items: _catCtrl.categories.map((c) {
                      return DropdownMenuItem(
                        value: c,
                        child: Text(c.title, style: const TextStyle(fontSize: 13)),
                      );
                    }).toList(),
                    onChanged: (v) => setState(() => _selectedCategory = v),
                  ),
                ),
              );
            }),
            const SizedBox(height: 16),

            // Address
            _label('Address'),
            const SizedBox(height: 6),
            _field(_addressCtrl, 'Shop address', maxLines: 2),
            const SizedBox(height: 16),

            // Phone
            _label('Phone'),
            const SizedBox(height: 6),
            _field(_phoneCtrl, '+91 00000 00000', keyboard: TextInputType.phone),
            const SizedBox(height: 24),

            // Submit
            SizedBox(
              height: 50,
              child: Obx(() => ElevatedButton.icon(
                onPressed: _storeCtrl.isSaving.value ? null : _saveStore,
                icon: _storeCtrl.isSaving.value
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.check),
                label: Text(
                  isEditing ? 'Update Store' : 'Create My Store',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String t) => Text(t, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF333333)));

  Widget _field(TextEditingController c, String hint, {int maxLines = 1, TextInputType? keyboard, String? Function(String?)? validator}) {
    return TextFormField(
      controller: c,
      maxLines: maxLines,
      keyboardType: keyboard,
      validator: validator,
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF999999)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFEEEEEE))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _accent, width: 1.5)),
      ),
    );
  }
}