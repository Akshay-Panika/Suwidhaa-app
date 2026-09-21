import 'package:flutter/material.dart';

class SchoolLibraryScreen extends StatefulWidget {
  const SchoolLibraryScreen({super.key});

  @override
  State<SchoolLibraryScreen> createState() => _SchoolLibraryScreenState();
}

class _SchoolLibraryScreenState extends State<SchoolLibraryScreen>
    with SingleTickerProviderStateMixin {
  // ==================== TAB ====================
  late TabController _tabController;

  // ==================== SEARCH & FILTER ====================
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = "";
  String _statusFilter = "All"; // All | Available | Out of Stock | Upcoming
  String _categoryFilter = "All";

  // ==================== CATEGORIES ====================
  final List<String> _categories = [
    "All",
    "Academic",
    "Fiction",
    "Science",
    "History",
    "Biography",
    "Reference",
  ];

  // ==================== BOOKS DATA ====================
  final List<Map<String, dynamic>> _books = [
    {
      "id": "BK001",
      "title": "Advanced Mathematics - Class 10",
      "author": "R.D. Sharma",
      "category": "Academic",
      "status": "Available",
      "copies": 12,
      "total": 15,
      "cover": Colors.indigo,
      "isbn": "978-81-2345-678-9",
      "shelf": "A-12",
      "year": "2024",
    },
    {
      "id": "BK002",
      "title": "Concepts of Physics Vol 1",
      "author": "H.C. Verma",
      "category": "Science",
      "status": "Available",
      "copies": 5,
      "total": 10,
      "cover": Colors.teal,
      "isbn": "978-81-2345-679-6",
      "shelf": "B-04",
      "year": "2023",
    },
    {
      "id": "BK003",
      "title": "Wings of Fire",
      "author": "A.P.J. Abdul Kalam",
      "category": "Biography",
      "status": "Out of Stock",
      "copies": 0,
      "total": 8,
      "cover": Colors.orange,
      "isbn": "978-81-2345-680-2",
      "shelf": "C-08",
      "year": "2020",
    },
    {
      "id": "BK004",
      "title": "The Alchemist",
      "author": "Paulo Coelho",
      "category": "Fiction",
      "status": "Available",
      "copies": 3,
      "total": 6,
      "cover": Colors.purple,
      "isbn": "978-81-2345-681-9",
      "shelf": "D-02",
      "year": "2019",
    },
    {
      "id": "BK005",
      "title": "Indian History - Modern Era",
      "author": "Bipin Chandra",
      "category": "History",
      "status": "Upcoming",
      "copies": 0,
      "total": 10,
      "cover": Colors.brown,
      "isbn": "978-81-2345-682-6",
      "shelf": "E-01",
      "year": "2025",
    },
    {
      "id": "BK006",
      "title": "Oxford English Dictionary",
      "author": "Oxford Press",
      "category": "Reference",
      "status": "Available",
      "copies": 2,
      "total": 3,
      "cover": Colors.blueGrey,
      "isbn": "978-81-2345-683-3",
      "shelf": "F-05",
      "year": "2022",
    },
    {
      "id": "BK007",
      "title": "Harry Potter & Philosopher's Stone",
      "author": "J.K. Rowling",
      "category": "Fiction",
      "status": "Available",
      "copies": 7,
      "total": 10,
      "cover": Colors.red,
      "isbn": "978-81-2345-684-0",
      "shelf": "D-06",
      "year": "2018",
    },
    {
      "id": "BK008",
      "title": "Organic Chemistry",
      "author": "Morrison & Boyd",
      "category": "Science",
      "status": "Out of Stock",
      "copies": 0,
      "total": 5,
      "cover": Colors.green,
      "isbn": "978-81-2345-685-7",
      "shelf": "B-10",
      "year": "2021",
    },
  ];

  // ==================== DONATIONS ====================
  final List<Map<String, dynamic>> _donations = [
    {
      "title": "Let Us C",
      "author": "Yashavant Kanetkar",
      "donor": "Aarav Sharma",
      "date": "20 Sep 2025",
      "status": "Accepted",
      "condition": "Good",
    },
    {
      "title": "The Complete Reference Java",
      "author": "Herbert Schildt",
      "donor": "Priya Verma",
      "date": "15 Sep 2025",
      "status": "Pending",
      "condition": "Excellent",
    },
  ];

  // ==================== REQUESTS ====================
  final List<Map<String, dynamic>> _requests = [
    {
      "title": "Wings of Fire",
      "author": "A.P.J. Abdul Kalam",
      "requester": "Rohan Gupta",
      "date": "22 Sep 2025",
      "status": "Pending",
      "priority": "High",
    },
    {
      "title": "Organic Chemistry",
      "author": "Morrison & Boyd",
      "requester": "Sneha Patel",
      "date": "21 Sep 2025",
      "status": "Approved",
      "priority": "Medium",
    },
    {
      "title": "Indian History - Modern Era",
      "author": "Bipin Chandra",
      "requester": "Karan Singh",
      "date": "18 Sep 2025",
      "status": "Pending",
      "priority": "Low",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _searchCtrl.addListener(() {
      setState(() => _searchQuery = _searchCtrl.text.toLowerCase().trim());
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
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
    if (_categoryFilter != "All") {
      list = list.where((b) => b['category'] == _categoryFilter).toList();
    }
    return list;
  }

  Color _statusColor(String s) {
    switch (s) {
      case "Available":
        return Colors.green;
      case "Out of Stock":
        return Colors.red;
      case "Upcoming":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _statusIcon(String s) {
    switch (s) {
      case "Available":
        return Icons.check_circle_rounded;
      case "Out of Stock":
        return Icons.cancel_rounded;
      case "Upcoming":
        return Icons.schedule_rounded;
      default:
        return Icons.info_rounded;
    }
  }

  Color _priorityColor(String p) {
    switch (p) {
      case "High":
        return Colors.red;
      case "Medium":
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  void _snack(String msg, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        backgroundColor: color ?? Colors.green,
      ),
    );
  }

  // ==================== BOOK DETAIL SHEET ====================
  void _showBookDetail(Map<String, dynamic> b) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: const EdgeInsets.all(20),
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
                  width: 45,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 80,
                    height: 110,
                    decoration: BoxDecoration(
                      color: (b['cover'] as Color).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: (b['cover'] as Color).withOpacity(0.4)),
                    ),
                    child: Center(
                      child: Icon(Icons.menu_book_rounded,
                          color: b['cover'] as Color, size: 40),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(b['title'] as String,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 4),
                        Text("by ${b['author']}",
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey[700])),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _statusColor(b['status'] as String)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _statusIcon(b['status'] as String),
                                size: 12,
                                color: _statusColor(b['status'] as String),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                b['status'] as String,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: _statusColor(b['status'] as String),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 10),
              _kvRow("Book ID", b['id'] as String),
              _kvRow("ISBN", b['isbn'] as String),
              _kvRow("Category", b['category'] as String),
              _kvRow("Published", b['year'] as String),
              _kvRow("Shelf No.", b['shelf'] as String),
              _kvRow("Copies Available", "${b['copies']} / ${b['total']}"),
              const SizedBox(height: 20),
              // Action buttons
              if (b['status'] == "Available")
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _snack("Book issued successfully!");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.book_rounded,
                        color: Colors.white, size: 18),
                    label: const Text("Issue Book",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600)),
                  ),
                )
              else if (b['status'] == "Out of Stock")
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _showRequestDialog(bookTitle: b['title'] as String);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.notifications_active_rounded,
                        color: Colors.white, size: 18),
                    label: const Text("Notify Me / Request Book",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600)),
                  ),
                )
              else
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      side: const BorderSide(color: Colors.orange),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.schedule_rounded,
                        color: Colors.orange, size: 18),
                    label: const Text("Coming Soon",
                        style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _kvRow(String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(k,
              style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          Text(v,
              style: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  // ==================== DONATE FORM ====================
  void _showDonateDialog() {
    final titleCtrl = TextEditingController();
    final authorCtrl = TextEditingController();
    final qtyCtrl = TextEditingController(text: "1");
    String condition = "Good";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) => Padding(
          padding:
          EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(20),
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
                      width: 45,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: const [
                      Icon(Icons.volunteer_activism_rounded,
                          color: Colors.teal),
                      SizedBox(width: 8),
                      Text("Donate a Book",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Share your books with the library and help other students.",
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 18),
                  _inputField(
                    controller: titleCtrl,
                    label: "Book Title",
                    hint: "e.g. Let Us C",
                    icon: Icons.menu_book_rounded,
                  ),
                  const SizedBox(height: 12),
                  _inputField(
                    controller: authorCtrl,
                    label: "Author",
                    hint: "e.g. Yashavant Kanetkar",
                    icon: Icons.person_rounded,
                  ),
                  const SizedBox(height: 12),
                  _inputField(
                    controller: qtyCtrl,
                    label: "Quantity",
                    hint: "1",
                    icon: Icons.numbers_rounded,
                    keyboard: TextInputType.number,
                  ),
                  const SizedBox(height: 14),
                  const Text("Condition",
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ["Excellent", "Good", "Fair", "Old"]
                        .map((c) => ChoiceChip(
                      label: Text(c),
                      selected: condition == c,
                      onSelected: (_) =>
                          setModal(() => condition = c),
                      selectedColor: Colors.teal,
                      labelStyle: TextStyle(
                        color: condition == c
                            ? Colors.white
                            : Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                      backgroundColor: Colors.white,
                      side: BorderSide(
                          color: Colors.grey.shade300),
                    ))
                        .toList(),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        if (titleCtrl.text.isEmpty ||
                            authorCtrl.text.isEmpty) {
                          _snack("Please fill title & author",
                              color: Colors.red);
                          return;
                        }
                        setState(() {
                          _donations.insert(0, {
                            "title": titleCtrl.text,
                            "author": authorCtrl.text,
                            "donor": "You",
                            "date": "Today",
                            "status": "Pending",
                            "condition": condition,
                          });
                        });
                        Navigator.pop(ctx);
                        _tabController.animateTo(1);
                        _snack("Thank you for donating!");
                      },
                      child: const Text("Submit Donation",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ==================== REQUEST FORM ====================
  void _showRequestDialog({String? bookTitle}) {
    final titleCtrl = TextEditingController(text: bookTitle ?? "");
    final authorCtrl = TextEditingController();
    final reasonCtrl = TextEditingController();
    String priority = "Medium";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) => Padding(
          padding:
          EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(20),
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
                      width: 45,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: const [
                      Icon(Icons.bookmark_add_rounded,
                          color: Colors.orange),
                      SizedBox(width: 8),
                      Text("Request a Book",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Can't find a book? Request it and we'll try to add it to the library.",
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 18),
                  _inputField(
                    controller: titleCtrl,
                    label: "Book Title",
                    hint: "e.g. Wings of Fire",
                    icon: Icons.menu_book_rounded,
                  ),
                  const SizedBox(height: 12),
                  _inputField(
                    controller: authorCtrl,
                    label: "Author (optional)",
                    hint: "e.g. A.P.J. Abdul Kalam",
                    icon: Icons.person_rounded,
                  ),
                  const SizedBox(height: 12),
                  _inputField(
                    controller: reasonCtrl,
                    label: "Reason (optional)",
                    hint: "Why do you need this book?",
                    icon: Icons.notes_rounded,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 14),
                  const Text("Priority",
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ["Low", "Medium", "High"]
                        .map((p) => ChoiceChip(
                      label: Text(p),
                      selected: priority == p,
                      onSelected: (_) =>
                          setModal(() => priority = p),
                      selectedColor: _priorityColor(p),
                      labelStyle: TextStyle(
                        color: priority == p
                            ? Colors.white
                            : Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                      backgroundColor: Colors.white,
                      side: BorderSide(
                          color: Colors.grey.shade300),
                    ))
                        .toList(),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        if (titleCtrl.text.isEmpty) {
                          _snack("Please enter book title",
                              color: Colors.red);
                          return;
                        }
                        setState(() {
                          _requests.insert(0, {
                            "title": titleCtrl.text,
                            "author": authorCtrl.text.isEmpty
                                ? "-"
                                : authorCtrl.text,
                            "requester": "You",
                            "date": "Today",
                            "status": "Pending",
                            "priority": priority,
                          });
                        });
                        Navigator.pop(ctx);
                        _tabController.animateTo(2);
                        _snack("Request submitted!");
                      },
                      child: const Text("Submit Request",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboard = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 13),
        labelStyle: const TextStyle(fontSize: 12),
        prefixIcon: Icon(icon, color: Colors.indigo, size: 18),
        filled: true,
        fillColor: Colors.grey.shade50,
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

  // ==================== BUILD ====================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
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
          IconButton(
            tooltip: "Donate Book",
            onPressed: _showDonateDialog,
            icon: const Icon(Icons.volunteer_activism_rounded),
          ),
          IconButton(
            tooltip: "Request Book",
            onPressed: () => _showRequestDialog(),
            icon: const Icon(Icons.bookmark_add_rounded),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle:
          const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          tabs: const [
            Tab(text: "Books"),
            Tab(text: "Donations"),
            Tab(text: "Requests"),
            Tab(text: "Stats"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBooksTab(),
          _buildDonationsTab(),
          _buildRequestsTab(),
          _buildStatsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (_) => Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.vertical(top: Radius.circular(22)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 45,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text("Quick Action",
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.teal.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.volunteer_activism_rounded,
                          color: Colors.teal),
                    ),
                    title: const Text("Donate a Book",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: Text("Share books with library",
                        style: TextStyle(
                            fontSize: 11, color: Colors.grey[600])),
                    onTap: () {
                      Navigator.pop(context);
                      _showDonateDialog();
                    },
                  ),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.bookmark_add_rounded,
                          color: Colors.orange),
                    ),
                    title: const Text("Request a Book",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: Text("Ask for unavailable book",
                        style: TextStyle(
                            fontSize: 11, color: Colors.grey[600])),
                    onTap: () {
                      Navigator.pop(context);
                      _showRequestDialog();
                    },
                  ),
                ],
              ),
            ),
          );
        },
        backgroundColor: Colors.indigo,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text("Action",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }

  // ==================== TAB 1: BOOKS ====================
  Widget _buildBooksTab() {
    return Column(
      children: [
        // ===== Search + Filter Bar =====
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
          child: Column(
            children: [
              TextField(
                controller: _searchCtrl,
                style: const TextStyle(fontSize: 13),
                decoration: InputDecoration(
                  hintText: "Search books or author...",
                  hintStyle: const TextStyle(fontSize: 13),
                  prefixIcon: const Icon(Icons.search_rounded,
                      color: Colors.indigo, size: 20),
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
                    borderSide: const BorderSide(
                        color: Colors.indigo, width: 1.4),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Status chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:
                  ["All", "Available", "Out of Stock", "Upcoming"]
                      .map((s) {
                    final sel = _statusFilter == s;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(s),
                        selected: sel,
                        onSelected: (_) =>
                            setState(() => _statusFilter = s),
                        selectedColor: Colors.indigo,
                        labelStyle: TextStyle(
                          color: sel ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                        backgroundColor: Colors.white,
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 8),
              // Category chips
              SizedBox(
                height: 32,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: _categories.map((c) {
                    final sel = _categoryFilter == c;
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: InkWell(
                        onTap: () => setState(() => _categoryFilter = c),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: sel
                                ? Colors.indigo.withOpacity(0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: sel
                                  ? Colors.indigo.withOpacity(0.5)
                                  : Colors.grey.shade300,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              c,
                              style: TextStyle(
                                fontSize: 11,
                                color: sel
                                    ? Colors.indigo
                                    : Colors.grey.shade700,
                                fontWeight: sel
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        // ===== Book list =====
        Expanded(
          child: _filteredBooks.isEmpty
              ? _emptyState("No books found")
              : ListView.separated(
            padding: const EdgeInsets.all(14),
            itemCount: _filteredBooks.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) =>
                _buildBookTile(_filteredBooks[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildBookTile(Map<String, dynamic> b) {
    final status = b['status'] as String;
    final sc = _statusColor(status);

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _showBookDetail(b),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            // Cover
            Container(
              width: 55,
              height: 75,
              decoration: BoxDecoration(
                color: (b['cover'] as Color).withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: (b['cover'] as Color).withOpacity(0.4)),
              ),
              child: Center(
                child: Icon(Icons.menu_book_rounded,
                    color: b['cover'] as Color, size: 28),
              ),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(b['title'] as String,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w700),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text("by ${b['author']}",
                      style: TextStyle(
                          fontSize: 11, color: Colors.grey[700]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      // Status badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: sc.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(_statusIcon(status),
                                size: 10, color: sc),
                            const SizedBox(width: 3),
                            Text(status,
                                style: TextStyle(
                                  fontSize: 9,
                                  color: sc,
                                  fontWeight: FontWeight.w700,
                                )),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      // Category
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(b['category'] as String,
                            style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Stock count
            Column(
              children: [
                Text(
                  "${b['copies']}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: (b['copies'] as int) > 0
                        ? Colors.indigo
                        : Colors.grey,
                  ),
                ),
                Text("of ${b['total']}",
                    style: TextStyle(
                        fontSize: 10, color: Colors.grey[600])),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ==================== TAB 2: DONATIONS ====================
  Widget _buildDonationsTab() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "${_donations.length} donations",
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
              TextButton.icon(
                onPressed: _showDonateDialog,
                icon: const Icon(Icons.add_rounded,
                    size: 18, color: Colors.teal),
                label: const Text("Donate",
                    style: TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: _donations.isEmpty
              ? _emptyState("No donations yet")
              : ListView.separated(
            padding: const EdgeInsets.all(14),
            itemCount: _donations.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) =>
                _buildDonationTile(_donations[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildDonationTile(Map<String, dynamic> d) {
    Color statusColor;
    IconData statusIcon;
    switch (d['status']) {
      case "Accepted":
        statusColor = Colors.green;
        statusIcon = Icons.check_circle_rounded;
        break;
      case "Rejected":
        statusColor = Colors.red;
        statusIcon = Icons.cancel_rounded;
        break;
      default:
        statusColor = Colors.orange;
        statusIcon = Icons.access_time_rounded;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.volunteer_activism_rounded,
                color: Colors.teal, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(d['title'] as String,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 3),
                Text("by ${d['author']}",
                    style: TextStyle(
                        fontSize: 11, color: Colors.grey[700])),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.person_rounded,
                        size: 11, color: Colors.grey[600]),
                    const SizedBox(width: 3),
                    Text(d['donor'] as String,
                        style: TextStyle(
                            fontSize: 10, color: Colors.grey[600])),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(d['condition'] as String,
                          style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: Colors.blueGrey)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, size: 10, color: statusColor),
                    const SizedBox(width: 3),
                    Text(d['status'] as String,
                        style: TextStyle(
                            fontSize: 10,
                            color: statusColor,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(d['date'] as String,
                  style:
                  TextStyle(fontSize: 10, color: Colors.grey[600])),
            ],
          ),
        ],
      ),
    );
  }

  // ==================== TAB 3: REQUESTS ====================
  Widget _buildRequestsTab() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "${_requests.length} requests",
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
              TextButton.icon(
                onPressed: () => _showRequestDialog(),
                icon: const Icon(Icons.add_rounded,
                    size: 18, color: Colors.orange),
                label: const Text("Request",
                    style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: _requests.isEmpty
              ? _emptyState("No requests yet")
              : ListView.separated(
            padding: const EdgeInsets.all(14),
            itemCount: _requests.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) =>
                _buildRequestTile(_requests[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildRequestTile(Map<String, dynamic> r) {
    Color statusColor;
    IconData statusIcon;
    switch (r['status']) {
      case "Approved":
        statusColor = Colors.green;
        statusIcon = Icons.check_circle_rounded;
        break;
      case "Rejected":
        statusColor = Colors.red;
        statusIcon = Icons.cancel_rounded;
        break;
      default:
        statusColor = Colors.orange;
        statusIcon = Icons.access_time_rounded;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.bookmark_add_rounded,
                color: Colors.orange, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(r['title'] as String,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 3),
                Text("by ${r['author']}",
                    style: TextStyle(
                        fontSize: 11, color: Colors.grey[700])),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.person_rounded,
                        size: 11, color: Colors.grey[600]),
                    const SizedBox(width: 3),
                    Text(r['requester'] as String,
                        style: TextStyle(
                            fontSize: 10, color: Colors.grey[600])),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: _priorityColor(r['priority'] as String)
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(r['priority'] as String,
                          style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: _priorityColor(
                                  r['priority'] as String))),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, size: 10, color: statusColor),
                    const SizedBox(width: 3),
                    Text(r['status'] as String,
                        style: TextStyle(
                            fontSize: 10,
                            color: statusColor,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(r['date'] as String,
                  style:
                  TextStyle(fontSize: 10, color: Colors.grey[600])),
            ],
          ),
        ],
      ),
    );
  }

  // ==================== TAB 4: STATS ====================
  Widget _buildStatsTab() {
    final available =
        _books.where((b) => b['status'] == "Available").length;
    final outOfStock =
        _books.where((b) => b['status'] == "Out of Stock").length;
    final upcoming =
        _books.where((b) => b['status'] == "Upcoming").length;
    final totalCopies =
    _books.fold<int>(0, (s, b) => s + (b['copies'] as int));
    final totalBooks =
    _books.fold<int>(0, (s, b) => s + (b['total'] as int));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Big card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.indigo, Color(0xFF3F51B5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.indigo.withOpacity(0.28),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.local_library_rounded,
                      color: Colors.white, size: 28),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Total Books",
                        style: TextStyle(
                            color: Colors.white70, fontSize: 12)),
                    const SizedBox(height: 3),
                    Text("$totalBooks copies",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 3),
                    Text("$totalCopies currently available",
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text("Breakdown",
              style:
              TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                  child: _statTile("Available", available, Colors.green,
                      Icons.check_circle_rounded)),
              const SizedBox(width: 8),
              Expanded(
                  child: _statTile("Out of Stock", outOfStock, Colors.red,
                      Icons.cancel_rounded)),
              const SizedBox(width: 8),
              Expanded(
                  child: _statTile("Upcoming", upcoming, Colors.orange,
                      Icons.schedule_rounded)),
            ],
          ),
          const SizedBox(height: 20),
          const Text("By Category",
              style:
              TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          ..._categories.where((c) => c != "All").map((c) {
            final count =
                _books.where((b) => b['category'] == c).length;
            final pct = _books.isEmpty ? 0.0 : count / _books.length;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(c,
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                      Text("$count books",
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey[600])),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: pct,
                      minHeight: 6,
                      backgroundColor: Colors.grey.shade200,
                      valueColor:
                      const AlwaysStoppedAnimation(Colors.indigo),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _statTile(String label, int count, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text("$count",
              style: TextStyle(
                  fontSize: 20,
                  color: color,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(label,
              style: TextStyle(
                  fontSize: 10,
                  color: color,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
              maxLines: 2),
        ],
      ),
    );
  }

  Widget _emptyState(String msg) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inbox_rounded, size: 60, color: Colors.grey.shade400),
          const SizedBox(height: 10),
          Text(msg,
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}