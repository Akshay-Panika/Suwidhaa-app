import 'package:flutter/material.dart';
import 'school_book_review.dart';

class SchoolLibraryScreen extends StatefulWidget {
  const SchoolLibraryScreen({super.key});

  @override
  State<SchoolLibraryScreen> createState() => _SchoolLibraryScreenState();
}

class _SchoolLibraryScreenState extends State<SchoolLibraryScreen> {
  // ==================== SEARCH ====================
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = "";

  // ==================== FILTERS ====================
  String _statusFilter = "All";
  String _classFilter = "All";
  String _subjectFilter = "All";

  final List<String> _classes = [
    "All", "Class 6", "Class 7", "Class 8",
    "Class 9", "Class 10", "Class 11", "Class 12",
  ];

  final List<String> _subjects = [
    "All", "Maths", "Physics", "Chemistry", "Biology",
    "English", "Hindi", "History", "Geography",
    "Computer", "General",
  ];

  // ==================== BOOKS ====================
  final List<Map<String, dynamic>> _books = [
    {
      "id": "BK001", "title": "Advanced Mathematics", "author": "R.D. Sharma",
      "class": "Class 10", "subject": "Maths", "status": "Available",
      "copies": 12, "total": 15, "isbn": "978-81-2345-678-9",
      "shelf": "A-12", "year": "2024",
    },
    {
      "id": "BK002", "title": "Concepts of Physics Vol 1", "author": "H.C. Verma",
      "class": "Class 11", "subject": "Physics", "status": "Available",
      "copies": 5, "total": 10, "isbn": "978-81-2345-679-6",
      "shelf": "B-04", "year": "2023",
    },
    {
      "id": "BK003", "title": "Organic Chemistry", "author": "Morrison & Boyd",
      "class": "Class 12", "subject": "Chemistry", "status": "Out of Stock",
      "copies": 0, "total": 8, "isbn": "978-81-2345-680-2",
      "shelf": "B-10", "year": "2020",
    },
    {
      "id": "BK004", "title": "NCERT Biology", "author": "NCERT",
      "class": "Class 11", "subject": "Biology", "status": "Available",
      "copies": 3, "total": 6, "isbn": "978-81-2345-681-9",
      "shelf": "C-02", "year": "2019",
    },
    {
      "id": "BK005", "title": "Indian History - Modern Era", "author": "Bipin Chandra",
      "class": "Class 12", "subject": "History", "status": "Upcoming",
      "copies": 0, "total": 10, "isbn": "978-81-2345-682-6",
      "shelf": "E-01", "year": "2025",
    },
    {
      "id": "BK006", "title": "Oxford English Grammar", "author": "Oxford Press",
      "class": "Class 9", "subject": "English", "status": "Available",
      "copies": 2, "total": 3, "isbn": "978-81-2345-683-3",
      "shelf": "F-05", "year": "2022",
    },
    {
      "id": "BK007", "title": "Foundation Maths Class 8", "author": "R.S. Aggarwal",
      "class": "Class 8", "subject": "Maths", "status": "Available",
      "copies": 7, "total": 10, "isbn": "978-81-2345-684-0",
      "shelf": "D-06", "year": "2018",
    },
    {
      "id": "BK008", "title": "Hindi Vyakaran", "author": "Acharya Ramchandra",
      "class": "Class 9", "subject": "Hindi", "status": "Out of Stock",
      "copies": 0, "total": 5, "isbn": "978-81-2345-685-7",
      "shelf": "E-08", "year": "2021",
    },
    {
      "id": "BK009", "title": "Computer Science - Python", "author": "Sumita Arora",
      "class": "Class 11", "subject": "Computer", "status": "Available",
      "copies": 6, "total": 8, "isbn": "978-81-2345-686-4",
      "shelf": "G-03", "year": "2024",
    },
    {
      "id": "BK010", "title": "Geography of India", "author": "Majid Husain",
      "class": "Class 10", "subject": "Geography", "status": "Available",
      "copies": 4, "total": 6, "isbn": "978-81-2345-687-1",
      "shelf": "H-02", "year": "2020",
    },
    {
      "id": "BK011", "title": "Science Lab Manual Class 7", "author": "NCERT",
      "class": "Class 7", "subject": "General", "status": "Available",
      "copies": 10, "total": 12, "isbn": "978-81-2345-688-8",
      "shelf": "I-01", "year": "2023",
    },
    {
      "id": "BK012", "title": "English Literature Class 12", "author": "Woven Words",
      "class": "Class 12", "subject": "English", "status": "Available",
      "copies": 1, "total": 4, "isbn": "978-81-2345-689-5",
      "shelf": "F-10", "year": "2022",
    },
  ];

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(() {
      setState(() => _searchQuery = _searchCtrl.text.toLowerCase().trim());
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  // ==================== HELPERS ====================
  List<Map<String, dynamic>> get _filteredBooks {
    var list = List<Map<String, dynamic>>.from(_books);

    if (_searchQuery.isNotEmpty) {
      list = list.where((b) {
        return (b['title'] as String).toLowerCase().contains(_searchQuery) ||
            (b['author'] as String).toLowerCase().contains(_searchQuery);
      }).toList();
    }
    if (_statusFilter != "All") {
      list = list.where((b) => b['status'] == _statusFilter).toList();
    }
    if (_classFilter != "All") {
      list = list.where((b) => b['class'] == _classFilter).toList();
    }
    if (_subjectFilter != "All") {
      list = list.where((b) => b['subject'] == _subjectFilter).toList();
    }
    return list;
  }

  int get _activeFilterCount {
    int count = 0;
    if (_statusFilter != "All") count++;
    if (_classFilter != "All") count++;
    if (_subjectFilter != "All") count++;
    return count;
  }

  bool get _hasActiveFilters =>
      _activeFilterCount > 0 || _searchQuery.isNotEmpty;

  void _clearAllFilters() {
    setState(() {
      _statusFilter = "All";
      _classFilter = "All";
      _subjectFilter = "All";
      _searchCtrl.clear();
      _searchQuery = "";
    });
  }

  Color _statusColor(String s) {
    switch (s) {
      case "Available": return Colors.green;
      case "Out of Stock": return Colors.red;
      case "Upcoming": return Colors.orange;
      default: return Colors.grey;
    }
  }

  IconData _statusIcon(String s) {
    switch (s) {
      case "Available": return Icons.check_circle_rounded;
      case "Out of Stock": return Icons.cancel_rounded;
      case "Upcoming": return Icons.schedule_rounded;
      default: return Icons.info_rounded;
    }
  }

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

  List<Color> _subjectGradient(String s) {
    final c = _subjectColor(s);
    return [c, Color.lerp(c, Colors.black, 0.35)!];
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

  // ==================== NAVIGATE TO REVIEW SCREEN ====================
  void _openBookReview(Map<String, dynamic> b) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SchoolBookReview(book: b),
      ),
    );
  }

  // ==================== FILTER SHEET (still bottom sheet for filters only) ====================
  void _openFilterSheet() {
    String tempClass = _classFilter;
    String tempSubject = _subjectFilter;
    String tempStatus = _statusFilter;

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
                        tempStatus = "All";
                      }),
                      child: const Text("Reset",
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Divider(),

                const SizedBox(height: 14),
                _sheetSectionTitle("Class"),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8, runSpacing: 8,
                  children: _classes.map((c) {
                    final sel = tempClass == c;
                    return _sheetChip(
                      label: c,
                      selected: sel,
                      color: Colors.indigo,
                      count: c == "All"
                          ? _books.length
                          : _books.where((b) => b['class'] == c).length,
                      onTap: () => setModal(() => tempClass = c),
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
                      count: s == "All"
                          ? _books.length
                          : _books.where((b) => b['subject'] == s).length,
                      onTap: () => setModal(() => tempSubject = s),
                      icon: s == "All"
                          ? Icons.menu_book_rounded
                          : _subjectIcon(s),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),
                _sheetSectionTitle("Availability"),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8, runSpacing: 8,
                  children: ["All", "Available", "Out of Stock", "Upcoming"]
                      .map((s) {
                    final sel = tempStatus == s;
                    final color = s == "All" ? Colors.teal : _statusColor(s);
                    return _sheetChip(
                      label: s,
                      selected: sel,
                      color: color,
                      count: s == "All"
                          ? _books.length
                          : _books.where((b) => b['status'] == s).length,
                      onTap: () => setModal(() => tempStatus = s),
                      icon: s == "All" ? Icons.tune_rounded : _statusIcon(s),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _classFilter = tempClass;
                        _subjectFilter = tempSubject;
                        _statusFilter = tempStatus;
                      });
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
    required int count,
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
            Icon(icon, size: 13, color: selected ? Colors.white : color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: selected ? Colors.white : Colors.grey.shade800,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(
                color: selected
                    ? Colors.white.withOpacity(0.25)
                    : color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "$count",
                style: TextStyle(
                  fontSize: 9.5,
                  color: selected ? Colors.white : color,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text("Library",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: _openFilterSheet,
                icon: const Icon(Icons.tune_rounded),
              ),
              if (_activeFilterCount > 0)
                Positioned(
                  right: 6, top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                    constraints:
                    const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      "$_activeFilterCount",
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
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final list = _filteredBooks;

    return Column(
      children: [
        // ===== Search + Active Pills =====
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
                  hintText: "Search books or author...",
                  hintStyle: const TextStyle(fontSize: 13),
                  prefixIcon: const Icon(Icons.search_rounded,
                      color: Colors.indigo, size: 20),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.close_rounded, size: 18),
                    onPressed: () {
                      _searchCtrl.clear();
                      setState(() => _searchQuery = "");
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
              Row(
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
                          if (_classFilter != "All") ...[
                            const SizedBox(width: 8),
                            _activePill(_classFilter, Colors.indigo,
                                Icons.class_rounded,
                                    () => setState(() => _classFilter = "All")),
                          ],
                          if (_subjectFilter != "All") ...[
                            const SizedBox(width: 6),
                            _activePill(
                                _subjectFilter,
                                _subjectColor(_subjectFilter),
                                _subjectIcon(_subjectFilter),
                                    () =>
                                    setState(() => _subjectFilter = "All")),
                          ],
                          if (_statusFilter != "All") ...[
                            const SizedBox(width: 6),
                            _activePill(
                                _statusFilter,
                                _statusColor(_statusFilter),
                                _statusIcon(_statusFilter),
                                    () => setState(() => _statusFilter = "All")),
                          ],
                        ],
                      ),
                    ),
                  ),
                  if (_hasActiveFilters)
                    GestureDetector(
                      onTap: _clearAllFilters,
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
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        // ===== Grid =====
        Expanded(
          child: list.isEmpty
              ? _emptyState()
              : GridView.builder(
            padding: const EdgeInsets.all(14),
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.8,
            ),
            itemCount: list.length,
            itemBuilder: (context, index) =>
                _buildBookGridCard(list[index]),
          ),
        ),
      ],
    );
  }

  // ==================== 🎯 BOOK GRID CARD ====================
  Widget _buildBookGridCard(Map<String, dynamic> b) {
    final status = b['status'] as String;
    final sc = _statusColor(status);
    final subColor = _subjectColor(b['subject'] as String);
    final grad = _subjectGradient(b['subject'] as String);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        // 👇 Navigate to full screen instead of bottom sheet
        onTap: () => _openBookReview(b),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== BOOK COVER =====
              Expanded(
                flex: 5,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: grad,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(14),
                          topRight: Radius.circular(14),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0, top: 0, bottom: 0,
                            child: Container(
                              width: 6,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.25),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  bottomLeft: Radius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Icon(
                              _subjectIcon(b['subject'] as String),
                              size: 42,
                              color: Colors.white,
                            ),
                          ),
                          Positioned(
                            top: 8, left: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                b['class']
                                    .toString()
                                    .replaceAll("Class ", "C-"),
                                style: const TextStyle(
                                  fontSize: 9,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 8, right: 8,
                      child: Container(
                        width: 10, height: 10,
                        decoration: BoxDecoration(
                          color: sc,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ===== INFO =====
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        b['title'] as String,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                          height: 1.25,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        b['author'] as String,
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      _miniChip(
                        b['subject'] as String,
                        subColor,
                        icon: _subjectIcon(b['subject'] as String),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(_statusIcon(status), size: 10, color: sc),
                          const SizedBox(width: 3),
                          Text(
                            "${b['copies']}/${b['total']}",
                            style: TextStyle(
                              fontSize: 10,
                              color: sc,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const Spacer(),
                          Icon(Icons.chevron_right_rounded,
                              size: 14, color: Colors.grey[400]),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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

  // ==================== ACTIVE PILL ====================
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

  // ==================== EMPTY STATE ====================
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
          if (_hasActiveFilters) ...[
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: _clearAllFilters,
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: const Text("Reset filters"),
            ),
          ],
        ],
      ),
    );
  }
}