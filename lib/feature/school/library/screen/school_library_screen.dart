import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/library_controller.dart';
import '../model/library_book_model.dart';
import 'school_book_review.dart';           // ← NEW
import 'school_library_form_screen.dart';

class SchoolLibraryScreen extends StatefulWidget {
  const SchoolLibraryScreen({super.key});

  @override
  State<SchoolLibraryScreen> createState() => _SchoolLibraryScreenState();
}

class _SchoolLibraryScreenState extends State<SchoolLibraryScreen> {
  final _searchCtrl = TextEditingController();

  final List<String> _classes = [
    "All", "Class 6", "Class 7", "Class 8",
    "Class 9", "Class 10", "Class 11", "Class 12",
  ];

  final List<String> _subjects = [
    "All", "Maths", "Physics", "Chemistry", "Biology",
    "English", "Hindi", "History", "Geography",
    "Computer", "General",
  ];

  LibraryController get c => Get.find<LibraryController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      c.fetchBooks();
    });

    _searchCtrl.addListener(() {
      c.setSearch(_searchCtrl.text);
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
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

  List<Color> _subjectGradient(String s) {
    final col = _subjectColor(s);
    return [col, Color.lerp(col, Colors.black, 0.35)!];
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

  String _displayLabel(LibraryBookModel b) {
    final subj = b.subject.isEmpty ? 'Book' : b.subject;
    final cls = _displayClass(b.bookClass).replaceAll("Class ", "Class- ");
    return "$subj · $cls";
  }

  // ==================== NAVIGATE ====================
  Future<void> _openBookReview(LibraryBookModel b) async {
    await Get.to(() => SchoolBookReview(book: b));
    // Refresh after coming back (edit/delete possible)
    c.fetchBooks();
  }

  Future<void> _openAddBook() async {
    final ok = await Get.to(() => const SchoolLibraryFormScreen());
    if (ok == true) c.fetchBooks();
  }

  Future<void> _openEditBook(LibraryBookModel b) async {
    final ok = await Get.to(
          () => SchoolLibraryFormScreen(
        book: {
          'id': b.id,
          'author': b.author,
          'book_class': b.bookClass,
          'subject': b.subject,
          'quantity': b.quantity,
          'front_image': b.frontImage,
          'back_image': b.backImage,
        },
      ),
    );
    if (ok == true) c.fetchBooks();
  }

  Future<void> _confirmDelete(LibraryBookModel b) async {
    final ok = await Get.dialog<bool>(
      AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text("Delete Book?"),
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
      await c.deleteBook(b.id!);
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
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text("Library",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
        actions: [
          Obx(() {
            final activeCount =
                (c.classFilter.value != "All" ? 1 : 0) +
                    (c.subjectFilter.value != "All" ? 1 : 0);
            return Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  onPressed: _openFilterSheet,
                  icon: const Icon(Icons.tune_rounded),
                ),
                if (activeCount > 0)
                  Positioned(
                    right: 6, top: 6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                          minWidth: 16, minHeight: 16),
                      child: Text(
                        "$activeCount",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }),
          const SizedBox(width: 12),
          InkWell(
            onTap: _openAddBook,
            customBorder: const CircleBorder(),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white),
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _searchCtrl,
                style: const TextStyle(fontSize: 13),
                decoration: InputDecoration(
                  hintText: "Search by author or ID...",
                  hintStyle: const TextStyle(fontSize: 13),
                  prefixIcon: const Icon(Icons.search_rounded,
                      color: Colors.indigo, size: 20),
                  suffixIcon: _searchCtrl.text.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.close_rounded, size: 18),
                    onPressed: () {
                      _searchCtrl.clear();
                      c.setSearch("");
                    },
                  )
                      : null,
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 0),
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
                    borderSide:
                    const BorderSide(color: Colors.indigo, width: 1.4),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Obx(() {
                final list = c.books;
                return Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Text(
                              "${list.length} book${list.length == 1 ? "" : "s"}",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey[800],
                              ),
                            ),
                            if (c.classFilter.value != "All") ...[
                              const SizedBox(width: 8),
                              _activePill(
                                c.classFilter.value,
                                Colors.indigo,
                                Icons.class_rounded,
                                    () => c.setClassFilter("All"),
                              ),
                            ],
                            if (c.subjectFilter.value != "All") ...[
                              const SizedBox(width: 6),
                              _activePill(
                                c.subjectFilter.value,
                                _subjectColor(c.subjectFilter.value),
                                _subjectIcon(c.subjectFilter.value),
                                    () => c.setSubjectFilter("All"),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    if (c.classFilter.value != "All" ||
                        c.subjectFilter.value != "All")
                      GestureDetector(
                        onTap: c.clearFilters,
                        child: Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.close_rounded,
                                  size: 12, color: Colors.red),
                              SizedBox(width: 3),
                              Text("Clear",
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              }),
            ],
          ),
        ),
        const Divider(height: 1),

        Expanded(
          child: Obx(() {
            if (c.isLoading.value && c.books.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            if (c.error.value.isNotEmpty && c.books.isEmpty) {
              return _errorState(c.error.value);
            }
            if (c.books.isEmpty) return _emptyState();

            return RefreshIndicator(
              onRefresh: c.fetchBooks,
              child: GridView.builder(
                padding: const EdgeInsets.all(10),
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.8,
                ),
                itemCount: c.books.length,
                itemBuilder: (context, index) =>
                    _buildBookGridCard(c.books[index]),
              ),
            );
          }),
        ),
      ],
    );
  }

  // ==================== BOOK CARD ====================
  Widget _buildBookGridCard(LibraryBookModel b) {
    final status = b.status;
    final sc = status == "Available" ? Colors.green : Colors.red;
    final subColor = _subjectColor(b.subject);
    final grad = _subjectGradient(b.subject);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _openBookReview(b),                // ← NEW
        onLongPress: () => _showCardMenu(b),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: (b.frontImage == null || b.frontImage!.isEmpty) ? LinearGradient(
                      colors: grad,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ) : null,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(14),
                      topRight: Radius.circular(14),
                    ),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: (b.frontImage != null &&
                      b.frontImage!.isNotEmpty)
                      ? Image.network(
                    b.frontImage!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Center(
                      child: Icon(
                        _subjectIcon(b.subject),
                        size: 42,
                        color: Colors.white,
                      ),
                    ),
                  )
                      : Center(
                        child: Icon(
                          _subjectIcon(b.subject),
                          size: 42,
                          color: Colors.white,
                        ),
                      ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          _displayLabel(b),
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                            height: 1.25,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      b.author.isNotEmpty ? b.author : "—",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          status == "Available"
                              ? Icons.check_circle_rounded
                              : Icons.cancel_rounded,
                          size: 10,
                          color: sc,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          "Qty: ${b.quantity}",
                          style: TextStyle(
                            fontSize: 10,
                            color: sc,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Spacer(),
                        Icon(Icons.chevron_right_rounded,
                            size: 16, color: Colors.grey[600]),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== MENU ====================
  void _showCardMenu(LibraryBookModel b) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _displayLabel(b),
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w700),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.visibility_rounded,
                    color: Colors.indigo),
                title: const Text("View Details"),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                onTap: () {
                  Navigator.pop(context);
                  _openBookReview(b);
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit_rounded,
                    color: Colors.indigo),
                title: const Text("Edit Book"),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                onTap: () {
                  Navigator.pop(context);
                  _openEditBook(b);
                },
              ),
              ListTile(
                leading:
                const Icon(Icons.delete_rounded, color: Colors.red),
                title: const Text("Delete Book"),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDelete(b);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== FILTER SHEET ====================
  void _openFilterSheet() {
    String tempClass = c.classFilter.value;
    String tempSubject = c.subjectFilter.value;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) => Container(
          padding: const EdgeInsets.all(18),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 45, height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.tune_rounded,
                        color: Colors.indigo, size: 20),
                    const SizedBox(width: 8),
                    const Text("Filter Books",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w700)),
                    const Spacer(),
                    TextButton(
                      onPressed: () => setModal(() {
                        tempClass = "All";
                        tempSubject = "All";
                      }),
                      child: const Text("Reset",
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const Divider(),

                const SizedBox(height: 14),
                _sheetSectionTitle("Class"),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8, runSpacing: 8,
                  children: _classes.map((cl) {
                    final sel = tempClass == cl;
                    return _sheetChip(
                      label: cl,
                      selected: sel,
                      color: Colors.indigo,
                      onTap: () => setModal(() => tempClass = cl),
                      icon: Icons.class_rounded,
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),
                _sheetSectionTitle("Subject"),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8, runSpacing: 8,
                  children: _subjects.map((s) {
                    final sel = tempSubject == s;
                    final color = s == "All"
                        ? Colors.deepPurple
                        : _subjectColor(s);
                    return _sheetChip(
                      label: s,
                      selected: sel,
                      color: color,
                      onTap: () => setModal(() => tempSubject = s),
                      icon: s == "All"
                          ? Icons.menu_book_rounded
                          : _subjectIcon(s),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      c.setClassFilter(tempClass);
                      c.setSubjectFilter(tempSubject);
                      Navigator.pop(ctx);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.check_rounded,
                        color: Colors.white, size: 18),
                    label: const Text("Apply Filters",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 14)),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sheetSectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        color: Colors.grey[600],
        letterSpacing: 1,
      ),
    );
  }

  Widget _sheetChip({
    required String label,
    required bool selected,
    required Color color,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? color : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? color : Colors.grey.shade300,
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 13, color: selected ? Colors.white : color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: selected ? Colors.white : Colors.grey.shade800,
                fontWeight:
                selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== MINI CHIP ====================
  Widget _miniChip(String text, Color color, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 11, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _activePill(
      String text, Color color, IconData icon, VoidCallback onRemove) {
    return GestureDetector(
      onTap: onRemove,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 11, color: color),
            const SizedBox(width: 4),
            Text(
              text,
              style: TextStyle(
                fontSize: 10,
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.close_rounded, size: 11, color: color),
          ],
        ),
      ),
    );
  }

  // ==================== STATES ====================
  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.menu_book_rounded,
              size: 70, color: Colors.grey.shade300),
          const SizedBox(height: 14),
          const Text(
            "No books found",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Try changing your filters",
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _errorState(String msg) {
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
              "Failed to load books",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              msg,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: c.fetchBooks,
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
}