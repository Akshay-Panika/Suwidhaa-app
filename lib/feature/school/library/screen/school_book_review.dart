import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/widget/flutter_toast.dart';
import '../../auth/controller/school_auth_controller.dart';
import '../controller/library_controller.dart';
import '../model/library_book_model.dart';
import 'school_library_form_screen.dart';

class SchoolBookReview extends StatefulWidget {
  /// Pass at least `id` — screen will fetch fresh data from API.
  final LibraryBookModel? book;

  const SchoolBookReview({super.key, this.book});

  @override
  State<SchoolBookReview> createState() => _SchoolBookReviewState();
}

class _SchoolBookReviewState extends State<SchoolBookReview> {
  final authController = Get.find<SchoolAuthController>();
  // if(authController.userType!='student')
  LibraryController get c => Get.find<LibraryController>();

  LibraryBookModel? _book;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _book = widget.book;
    _load();
  }

  Future<void> _load() async {
    if (_book?.id == null) {
      setState(() {
        _loading = false;
        _error = "No book id provided";
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final fresh = await c.fetchBookById(_book!.id!);
      if (!mounted) return;
      setState(() {
        _book = fresh ?? _book;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  // ==================== HELPERS ====================
  Color _subjectColor(String s) {
    switch (s.toLowerCase()) {
      case "maths": return Colors.indigo;
      case "physics": return Colors.blue;
      case "chemistry": return Colors.deepPurple;
      case "biology": return Colors.green;
      case "english": return Colors.orange;
      case "hindi": return Colors.brown;
      case "history": return Colors.teal;
      case "geography": return Colors.cyan;
      case "computer": return Colors.blueGrey;
      default: return Colors.grey;
    }
  }

  IconData _subjectIcon(String s) {
    switch (s.toLowerCase()) {
      case "maths": return Icons.calculate_rounded;
      case "physics": return Icons.science_rounded;
      case "chemistry": return Icons.biotech_rounded;
      case "biology": return Icons.eco_rounded;
      case "english": return Icons.translate_rounded;
      case "hindi": return Icons.text_fields_rounded;
      case "history": return Icons.history_edu_rounded;
      case "geography": return Icons.public_rounded;
      case "computer": return Icons.computer_rounded;
      default: return Icons.menu_book_rounded;
    }
  }

  String _displayClass(String raw) {
    if (raw.startsWith("Class ")) return raw;
    return "Class $raw";
  }

  // ==================== ACTIONS ====================
  Future<void> _onEdit() async {
    if (_book?.id == null) return;

    final ok = await Get.to(
          () => SchoolLibraryFormScreen(
        book: {
          'id': _book!.id,
          'author': _book!.author,
          'book_class': _book!.bookClass,
          'subject': _book!.subject,
          'quantity': _book!.quantity,
          'front_image': _book!.frontImage,
          'back_image': _book!.backImage,
        },
      ),
    );

    if (ok == true) {
      await _load();
      await c.fetchBooks();
      if (mounted) {
        FlutterToast.success("Book details updated");
      }
    }
  }

  Future<void> _onDelete() async {
    if (_book?.id == null) return;

    final ok = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title:  Text("Delete Book?",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
        content: const Text(
            "Are you sure you want to delete this book?\n\nThis action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Get.back(result: true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (ok == true) {
      final done = await c.deleteBook(_book!.id!);
      if (done && mounted) {
        Get.back();
        FlutterToast.success("Book has been deleted");
      }
    }
  }

  // ==================== BUILD ====================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios, size: 20),
        ),
        title: const Text("Book Details",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
        actions: [
          if(authController.userType!='student')
          if (_book != null) ...[
            InkWell(
              onTap: _onEdit,
              child:  Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 0.3),
                  ),
                  child: Icon(Icons.edit_rounded, size: 20,)),
            ),
            SizedBox(width: 20,),
            InkWell(
              onTap: _onDelete,
              child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 0.3),
                  ),
                  child: const Icon(Icons.delete_rounded, size: 20,)),
            ),
            SizedBox(width: 20,),
          ],
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null || _book == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline_rounded,
                  size: 60, color: Colors.red),
              const SizedBox(height: 12),
              Text(
                _error ?? "Book not found",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _load,
                icon: const Icon(Icons.refresh_rounded, size: 16),
                label: const Text("Retry"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final b = _book!;
    final subColor = _subjectColor(b.subject);
    final statusColor =
    b.status == "Available" ? Colors.green : Colors.red;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               Row(
                 spacing: 10,
                 children: [
                   Expanded(
                     child: _imageBlock(
                       title: "Front Image",
                       url: b.frontImage,
                       icon: _subjectIcon(b.subject),
                       color: subColor,
                     ),
                   ),
          
                   Expanded(
                     child: _imageBlock(
                       title: "Back Image",
                       url: b.backImage,
                       icon: Icons.menu_book_rounded,
                       color: subColor,
                     ),
                   ),
                 ],
               ),
                const SizedBox(height: 14),
          
                // ===== HEADER CARD =====
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(_subjectIcon(b.subject),
                              color: Colors.indigo, size: 26),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              b.subject.isEmpty ? "Book" : b.subject,
                              style: const TextStyle(
                                color: Colors.indigo,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _displayClass(b.bookClass),
                              style: const TextStyle(
                                color: Colors.indigo,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: statusColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  b.status == "Available"
                                      ? Icons.check_circle_rounded
                                      : Icons.cancel_rounded,
                                  color: Colors.white,
                                  size: 12,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  b.status,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
          
                // const SizedBox(height: 10),
          
                // ===== INFO ROWS =====
                _infoRow(
                  icon: Icons.person_rounded,
                  label: "Author",
                  value: b.author.isEmpty ? "—" : b.author,
                ),
                _infoRow(
                  icon: Icons.class_rounded,
                  label: "Class",
                  value: _displayClass(b.bookClass),
                ),
                _infoRow(
                  icon: _subjectIcon(b.subject),
                  label: "Subject",
                  value: b.subject.isEmpty ? "—" : b.subject,
                ),
                _infoRow(
                  icon: Icons.inventory_2_rounded,
                  label: "Quantity",
                  value: "${b.quantity}",
                ),
                _infoRow(
                  icon: Icons.info_outline_rounded,
                  label: "Status",
                  value: b.status,
                  valueColor: statusColor,
                ),
                if (b.id != null)
                  _infoRow(
                    icon: Icons.tag_rounded,
                    label: "ID",
                    value: "#${b.id}",
                  ),
          
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        if(authController.userType!='student')
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 30),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _onDelete,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Colors.red),
                    foregroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.delete_rounded, size: 18),
                  label: const Text(
                    "Delete",
                    style: TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: _onEdit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.edit_rounded, size: 18),
                  label: const Text(
                    "Edit Book",
                    style: TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==================== IMAGE BLOCK ====================
  Widget _imageBlock({
    required String title,
    required String? url,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (url != null && url.isNotEmpty)
            Image.network(
              url,
              fit: BoxFit.cover,
              loadingBuilder: (_, child, progress) {
                if (progress == null) return child;
                return const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                );
              },
              errorBuilder: (_, __, ___) => _imgPlaceholder(icon, color),
            )
          else
            _imgPlaceholder(icon, color),

          Positioned(
            left: 8, bottom: 8,
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
    );
  }

  Widget _imgPlaceholder(IconData icon, Color color) {
    return Container(
      color: color.withOpacity(0.1),
      child: Center(
        child: Icon(icon, size: 48, color: color),
      ),
    );
  }

  // ==================== INFO ROW ====================
  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.indigo),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: valueColor ?? Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}