import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/core/widget/flutter_toast.dart';

import '../controller/library_controller.dart';

class SchoolLibraryFormScreen extends StatefulWidget {
  final Map<String, dynamic>? book;
  const SchoolLibraryFormScreen({super.key, this.book});

  bool get isEdit => book != null;

  @override
  State<SchoolLibraryFormScreen> createState() =>
      _SchoolLibraryFormScreenState();
}

class _SchoolLibraryFormScreenState extends State<SchoolLibraryFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late final TextEditingController _authorCtrl;
  late final TextEditingController _quantityCtrl;

  String _selectedClass = "Class 6";
  String _selectedSubject = "Maths";

  final ImagePicker _picker = ImagePicker();

  // Local files (newly picked). null = dono case mein
  File? _frontImage;
  File? _backImage;

  // Existing remote URLs (edit mode) — display ke liye
  String? _existingFrontUrl;
  String? _existingBackUrl;

  bool _isSubmitting = false;
  bool _dirty = false;

  final List<String> _classes = [
    "Class 6", "Class 7", "Class 8", "Class 9",
    "Class 10", "Class 11", "Class 12",
  ];

  final List<String> _subjects = [
    "Maths", "Physics", "Chemistry", "Biology",
    "English", "Hindi", "History", "Geography",
    "Computer", "General",
  ];

  @override
  void initState() {
    super.initState();
    final b = widget.book;

    _authorCtrl = TextEditingController(text: b?['author'] ?? '');
    _quantityCtrl = TextEditingController(
      text: (b?['quantity'] ?? 1).toString(),
    );

    if (b != null) {
      // book_class "12" aata hai — "Class 12" mein convert
      final clsRaw = (b['book_class'] ?? b['class'] ?? '') as String;
      final cls = clsRaw.startsWith("Class ")
          ? clsRaw
          : "Class $clsRaw";
      _selectedClass = _classes.contains(cls) ? cls : "Class 6";

      // subject case-insensitive match
      final subjRaw = (b['subject'] ?? 'Maths') as String;
      final subj = _subjects.firstWhere(
            (s) => s.toLowerCase() == subjRaw.toLowerCase(),
        orElse: () => "Maths",
      );
      _selectedSubject = subj;

      _existingFrontUrl = b['front_image'] ?? b['frontImage'];
      _existingBackUrl  = b['back_image']  ?? b['backImage'];
    }

    for (final c in [_authorCtrl, _quantityCtrl]) {
      c.addListener(() {
        if (!_dirty) setState(() => _dirty = true);
      });
    }
  }

  @override
  void dispose() {
    _authorCtrl.dispose();
    _quantityCtrl.dispose();
    super.dispose();
  }

  // ==================== HELPERS ====================
  Color _subjectColor(String s) {
    switch (s) {
      case "Maths": return Colors.indigo;
      case "Physics": return Colors.blue;
      case "Chemistry": return Colors.deepPurple;
      case "Biology": return Colors.green;
      case "English": return Colors.orange;
      case "Hindi": return Colors.brown;
      case "History": return Colors.teal;
      case "Geography": return Colors.cyan;
      case "Computer": return Colors.blueGrey;
      default: return Colors.grey;
    }
  }

  IconData _subjectIcon(String s) {
    switch (s) {
      case "Maths": return Icons.calculate_rounded;
      case "Physics": return Icons.science_rounded;
      case "Chemistry": return Icons.biotech_rounded;
      case "Biology": return Icons.eco_rounded;
      case "English": return Icons.translate_rounded;
      case "Hindi": return Icons.text_fields_rounded;
      case "History": return Icons.history_edu_rounded;
      case "Geography": return Icons.public_rounded;
      case "Computer": return Icons.computer_rounded;
      default: return Icons.menu_book_rounded;
    }
  }

  void _incQuantity() {
    final v = int.tryParse(_quantityCtrl.text.trim()) ?? 1;
    _quantityCtrl.text = (v + 1).toString();
    setState(() => _dirty = true);
    HapticFeedback.selectionClick();
  }

  void _decQuantity() {
    final v = int.tryParse(_quantityCtrl.text.trim()) ?? 1;
    if (v <= 1) return;
    _quantityCtrl.text = (v - 1).toString();
    setState(() => _dirty = true);
    HapticFeedback.selectionClick();
  }

  // ==================== IMAGE PICK ====================
  Future<void> _showPickOptions({required bool isFront}) async {
    final choice = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              isFront ? "Front Image" : "Back Image",
              style: const TextStyle(
                fontWeight: FontWeight.w700, fontSize: 15,
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded,
                  color: Colors.indigo),
              title: const Text("Choose from Gallery"),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_rounded,
                  color: Colors.deepPurple),
              title: const Text("Take a Photo"),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );

    if (choice == null) return;

    try {
      final XFile? x = await _picker.pickImage(
        source: choice, imageQuality: 80,
      );
      if (x == null) return;
      setState(() {
        if (isFront) {
          _frontImage = File(x.path);
        } else {
          _backImage = File(x.path);
        }
        _dirty = true;
      });
      HapticFeedback.lightImpact();
    } catch (e) {
      if (!mounted) return;
      FlutterToast.error("Error: $e");
    }
  }

  // ==================== SUBMIT ====================
  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      HapticFeedback.heavyImpact();
      return;
    }

    setState(() => _isSubmitting = true);
    HapticFeedback.mediumImpact();

    final controller = Get.find<LibraryController>();
    final qty = int.tryParse(_quantityCtrl.text.trim()) ?? 1;

    bool ok;
    if (widget.isEdit) {
      ok = await controller.updateBook(
        id: widget.book!['id'] as int,
        author: _authorCtrl.text.trim(),
        bookClass: _selectedClass.replaceAll("Class ", ""),
        subject: _selectedSubject,
        quantity: qty,
        frontImage: _frontImage,
        backImage: _backImage,
      );
    } else {
      ok = await controller.addBook(
        author: _authorCtrl.text.trim(),
        bookClass: _selectedClass.replaceAll("Class ", ""),
        subject: _selectedSubject,
        quantity: qty,
        frontImage: _frontImage,
        backImage: _backImage,
      );
    }

    if (!mounted) return;
    setState(() => _isSubmitting = false);
    if (ok) Navigator.pop(context, true);
  }

  Future<bool> _confirmDiscard() async {
    if (!_dirty || _isSubmitting) return true;

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text("Discard changes?"),
        content: const Text(
            "You have unsaved changes. Are you sure you want to leave?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Keep editing"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Discard"),
          ),
        ],
      ),
    );
    return ok ?? false;
  }

  // ==================== BUILD ====================
  @override
  Widget build(BuildContext context) {
    final subjectColor = _subjectColor(_selectedSubject);

    return PopScope(
      canPop: !_dirty,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final ok = await _confirmDiscard();
        if (ok && mounted) Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          leading: IconButton(
            onPressed: () async {
              final ok = await _confirmDiscard();
              if (ok && mounted) Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios, size: 20),
          ),
          title: Text(
            widget.isEdit ? "Edit Book" : "Add Book",
            style: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: 17),
          ),
        ),
        body: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageSection(),
                const SizedBox(height: 20),

                _sectionTitle("Class"),
                const SizedBox(height: 10),
                _buildDropdown<String>(
                  label: "Select Class",
                  icon: Icons.class_rounded,
                  value: _selectedClass,
                  items: _classes,
                  color: Colors.indigo,
                  onChanged: (v) => setState(() {
                    _selectedClass = v!;
                    _dirty = true;
                  }),
                ),

                const SizedBox(height: 20),

                _sectionTitle("Subject"),
                const SizedBox(height: 10),
                _buildDropdown<String>(
                  label: "Select Subject",
                  icon: _subjectIcon(_selectedSubject),
                  value: _selectedSubject,
                  items: _subjects,
                  color: subjectColor,
                  onChanged: (v) => setState(() {
                    _selectedSubject = v!;
                    _dirty = true;
                  }),
                ),

                const SizedBox(height: 20),

                _sectionTitle("Author (optional)"),
                const SizedBox(height: 10),
                _buildTextField(
                  controller: _authorCtrl,
                  label: "Author Name",
                  hint: "e.g. R.D. Sharma",
                  icon: Icons.person_rounded,
                  textCapitalization: TextCapitalization.words,
                ),

                const SizedBox(height: 20),

                _sectionTitle("Quantity"),
                const SizedBox(height: 10),
                _buildQuantityField(),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomBar(),
      ),
    );
  }

  // ==================== QUANTITY ====================
  Widget _buildQuantityField() {
    return TextFormField(
      controller: _quantityCtrl,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(5),
      ],
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
      validator: (v) {
        final t = v?.trim() ?? '';
        if (t.isEmpty) return "Quantity required";
        final n = int.tryParse(t);
        if (n == null || n < 1) return "Min 1";
        return null;
      },
      decoration: InputDecoration(
        labelText: "Total Copies",
        hintText: "1",
        prefixIcon: const Icon(Icons.inventory_2_rounded,
            size: 18, color: Colors.indigo),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: _decQuantity,
              icon: const Icon(Icons.remove_circle_outline_rounded,
                  color: Colors.indigo),
            ),
            IconButton(
              onPressed: _incQuantity,
              icon: const Icon(Icons.add_circle_outline_rounded,
                  color: Colors.indigo),
            ),
          ],
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.indigo, width: 1.4),
        ),
      ),
    );
  }

  // ==================== IMAGE SECTION ====================
  Widget _buildImageSection() {
    return SizedBox(
      height: 260,
      child: Row(
        children: [
          Expanded(
            child: _imageBox(
              title: "Front Image",
              localImage: _frontImage,
              remoteUrl: _existingFrontUrl,
              onTap: () => _showPickOptions(isFront: true),
              onClear: (_frontImage == null && _existingFrontUrl == null)
                  ? null
                  : () => setState(() {
                _frontImage = null;
                _existingFrontUrl = null;
                _dirty = true;
              }),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _imageBox(
              title: "Back Image",
              localImage: _backImage,
              remoteUrl: _existingBackUrl,
              onTap: () => _showPickOptions(isFront: false),
              onClear: (_backImage == null && _existingBackUrl == null)
                  ? null
                  : () => setState(() {
                _backImage = null;
                _existingBackUrl = null;
                _dirty = true;
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageBox({
    required String title,
    required File? localImage,
    required String? remoteUrl,
    required VoidCallback onTap,
    VoidCallback? onClear,
  }) {
    final hasImage = localImage != null || remoteUrl != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (localImage != null)
              Image.file(localImage, fit: BoxFit.cover)
            else if (remoteUrl != null)
              Image.network(
                remoteUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _placeholder(title),
              )
            else
              _placeholder(title),

            if (hasImage && onClear != null)
              Positioned(
                top: 6, right: 6,
                child: GestureDetector(
                  onTap: onClear,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close_rounded,
                        size: 16, color: Colors.white),
                  ),
                ),
              ),

            if (hasImage)
              Positioned(
                left: 6, bottom: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder(String title) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.indigo.withOpacity(0.10),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.add_a_photo_rounded,
              size: 28, color: Colors.indigo),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 13,
            color: Colors.indigo,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Tap to upload",
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  // ==================== SHARED WIDGETS ====================
  Widget _sectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 3, height: 14,
          decoration: BoxDecoration(
            color: Colors.indigo,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: Colors.black54,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return TextFormField(
      controller: controller,
      textCapitalization: textCapitalization,
      onChanged: (_) => setState(() {}),
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(fontSize: 12, color: Colors.grey[400]),
        labelStyle: const TextStyle(fontSize: 13),
        prefixIcon: Icon(icon, size: 18, color: Colors.indigo),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.indigo, width: 1.4),
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required IconData icon,
    required T value,
    required List<T> items,
    required Color color,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down_rounded,
              color: Colors.indigo),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(12),
          style: const TextStyle(
              fontSize: 13,
              color: Colors.black87,
              fontWeight: FontWeight.w500),
          onChanged: onChanged,
          items: items.map((it) {
            return DropdownMenuItem<T>(
              value: it,
              child: Row(
                children: [
                  Icon(icon, size: 16, color: color),
                  const SizedBox(width: 10),
                  Text(it.toString()),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _isSubmitting
                    ? null
                    : () async {
                  final ok = await _confirmDiscard();
                  if (ok && mounted) Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: _isSubmitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: _isSubmitting
                    ? const SizedBox(
                  width: 16, height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white,
                  ),
                )
                    : Icon(
                  widget.isEdit
                      ? Icons.check_rounded
                      : Icons.add_rounded,
                  size: 18,
                ),
                label: Text(
                  _isSubmitting
                      ? "Saving..."
                      : (widget.isEdit
                      ? "Update Book"
                      : "Add Book"),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}