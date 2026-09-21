import 'package:flutter/material.dart';

class SchoolDocumentsScreen extends StatefulWidget {
  const SchoolDocumentsScreen({super.key});

  @override
  State<SchoolDocumentsScreen> createState() => _SchoolDocumentsScreenState();
}

class _SchoolDocumentsScreenState extends State<SchoolDocumentsScreen>
    with SingleTickerProviderStateMixin {
  // ==================== TAB ====================
  late TabController _tabController;

  // ==================== FILTER ====================
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = "";
  String _statusFilter = "All"; // All | Pending | Verified | Rejected

  // ==================== MY DOCUMENTS ====================
  final List<Map<String, dynamic>> _myDocuments = [
    {
      "id": "DOC001",
      "title": "Teaching Certificate",
      "type": "PDF",
      "size": "2.4 MB",
      "category": "Certificate",
      "uploadedOn": "15 Aug 2025",
      "status": "Verified",
      "color": Colors.green,
      "notes": "Verified by Principal Sharma",
    },
    {
      "id": "DOC002",
      "title": "Aadhaar Card",
      "type": "JPG",
      "size": "540 KB",
      "category": "Identity",
      "uploadedOn": "10 Aug 2025",
      "status": "Verified",
      "color": Colors.green,
      "notes": "Verified on 12 Aug 2025",
    },
    {
      "id": "DOC003",
      "title": "Experience Letter",
      "type": "PDF",
      "size": "1.1 MB",
      "category": "Experience",
      "uploadedOn": "20 Sep 2025",
      "status": "Pending",
      "color": Colors.orange,
      "notes": "Awaiting admin review",
    },
    {
      "id": "DOC004",
      "title": "PAN Card",
      "type": "JPG",
      "size": "380 KB",
      "category": "Identity",
      "uploadedOn": "18 Sep 2025",
      "status": "Pending",
      "color": Colors.orange,
      "notes": "Submitted for verification",
    },
  ];

  // ==================== STUDENT DOCUMENTS (To Verify) ====================
  final List<Map<String, dynamic>> _studentDocuments = [
    {
      "id": "SD001",
      "title": "Birth Certificate",
      "studentName": "Aarav Sharma",
      "class": "Class 10 - A",
      "roll": 1,
      "type": "PDF",
      "size": "1.8 MB",
      "source": "Parent App",
      "uploadedOn": "22 Sep 2025",
      "status": "Pending",
      "color": Colors.indigo,
      "notes": "Uploaded from parent mobile app",
    },
    {
      "id": "SD002",
      "title": "Transfer Certificate",
      "studentName": "Priya Verma",
      "class": "Class 10 - A",
      "roll": 2,
      "type": "PDF",
      "size": "2.2 MB",
      "source": "School Portal",
      "uploadedOn": "21 Sep 2025",
      "status": "Verified",
      "color": Colors.green,
      "notes": "Verified by Ms. Neha",
    },
    {
      "id": "SD003",
      "title": "Medical Certificate",
      "studentName": "Rohan Gupta",
      "class": "Class 10 - A",
      "roll": 3,
      "type": "PDF",
      "size": "890 KB",
      "source": "External Upload",
      "uploadedOn": "20 Sep 2025",
      "status": "Pending",
      "color": Colors.orange,
      "notes": "Needs verification",
    },
    {
      "id": "SD004",
      "title": "Aadhaar Card",
      "studentName": "Sneha Patel",
      "class": "Class 10 - A",
      "roll": 4,
      "type": "JPG",
      "size": "420 KB",
      "source": "Parent App",
      "uploadedOn": "19 Sep 2025",
      "status": "Rejected",
      "color": Colors.red,
      "notes": "Blurry image, please re-upload",
    },
    {
      "id": "SD005",
      "title": "Previous Marksheet",
      "studentName": "Karan Singh",
      "class": "Class 10 - B",
      "roll": 5,
      "type": "PDF",
      "size": "1.5 MB",
      "source": "Parent App",
      "uploadedOn": "18 Sep 2025",
      "status": "Verified",
      "color": Colors.green,
      "notes": "All details verified",
    },
    {
      "id": "SD006",
      "title": "Address Proof",
      "studentName": "Ananya Iyer",
      "class": "Class 10 - B",
      "roll": 6,
      "type": "JPG",
      "size": "620 KB",
      "source": "External Upload",
      "uploadedOn": "17 Sep 2025",
      "status": "Pending",
      "color": Colors.orange,
      "notes": "Awaiting teacher review",
    },
  ];

  // ==================== DOCUMENT CATEGORIES ====================
  final List<String> _categories = [
    "Certificate",
    "Identity",
    "Experience",
    "Medical",
    "Academic",
    "Address",
    "Other",
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
  List<Map<String, dynamic>> get _filteredMyDocs {
    var list = List<Map<String, dynamic>>.from(_myDocuments);
    if (_searchQuery.isNotEmpty) {
      list = list
          .where((d) =>
          (d['title'] as String).toLowerCase().contains(_searchQuery))
          .toList();
    }
    if (_statusFilter != "All") {
      list = list.where((d) => d['status'] == _statusFilter).toList();
    }
    return list;
  }

  List<Map<String, dynamic>> get _filteredStudentDocs {
    var list = List<Map<String, dynamic>>.from(_studentDocuments);
    if (_searchQuery.isNotEmpty) {
      list = list.where((d) {
        return (d['title'] as String).toLowerCase().contains(_searchQuery) ||
            (d['studentName'] as String)
                .toLowerCase()
                .contains(_searchQuery);
      }).toList();
    }
    if (_statusFilter != "All") {
      list = list.where((d) => d['status'] == _statusFilter).toList();
    }
    return list;
  }

  int get _pendingCount =>
      _studentDocuments.where((d) => d['status'] == "Pending").length;

  Color _statusColor(String s) {
    switch (s) {
      case "Verified":
        return Colors.green;
      case "Pending":
        return Colors.orange;
      case "Rejected":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _statusIcon(String s) {
    switch (s) {
      case "Verified":
        return Icons.verified_rounded;
      case "Pending":
        return Icons.access_time_rounded;
      case "Rejected":
        return Icons.cancel_rounded;
      default:
        return Icons.info_rounded;
    }
  }

  IconData _fileIcon(String type) {
    switch (type) {
      case "PDF":
        return Icons.picture_as_pdf_rounded;
      case "JPG":
      case "PNG":
        return Icons.image_rounded;
      case "DOC":
      case "DOCX":
        return Icons.description_rounded;
      default:
        return Icons.insert_drive_file_rounded;
    }
  }

  Color _fileColor(String type) {
    switch (type) {
      case "PDF":
        return Colors.red;
      case "JPG":
      case "PNG":
        return Colors.blue;
      case "DOC":
      case "DOCX":
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  Color _sourceColor(String s) {
    switch (s) {
      case "Parent App":
        return Colors.purple;
      case "School Portal":
        return Colors.indigo;
      case "External Upload":
        return Colors.orange;
      default:
        return Colors.grey;
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

  // ==================== VERIFY / REJECT ====================
  void _verifyDocument(Map<String, dynamic> d) {
    setState(() {
      d['status'] = "Verified";
      d['notes'] = "Verified by you on ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
    });
    _snack("Document verified successfully!", color: Colors.green);
  }

  void _rejectDocument(Map<String, dynamic> d, String reason) {
    setState(() {
      d['status'] = "Rejected";
      d['notes'] = reason;
    });
    _snack("Document rejected", color: Colors.red);
  }

  void _showRejectDialog(Map<String, dynamic> d) {
    final reasonCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Reject Document"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Please provide a reason for rejection:",
                style: TextStyle(fontSize: 12, color: Colors.grey[700])),
            const SizedBox(height: 12),
            TextField(
              controller: reasonCtrl,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "e.g. Blurry image, please re-upload",
                hintStyle: const TextStyle(fontSize: 12),
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel",
                style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              if (reasonCtrl.text.trim().isEmpty) return;
              Navigator.pop(context);
              _rejectDocument(d, reasonCtrl.text.trim());
            },
            child: const Text("Reject",
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ==================== UPLOAD SHEET ====================
  void _showUploadSheet({bool forStudent = false}) {
    final titleCtrl = TextEditingController();
    String category = _categories.first;
    String fileType = "PDF";
    String fileName = "";

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
                    children: [
                      Icon(
                        forStudent
                            ? Icons.school_rounded
                            : Icons.upload_file_rounded,
                        color: Colors.indigo,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        forStudent
                            ? "Upload Student Document"
                            : "Upload My Document",
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Title
                  _inputField(
                    controller: titleCtrl,
                    label: "Document Title",
                    hint: "e.g. Teaching Certificate",
                    icon: Icons.title_rounded,
                  ),

                  const SizedBox(height: 12),

                  // Category
                  const Text("Category",
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: category,
                        isExpanded: true,
                        icon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Colors.indigo),
                        style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontSize: 13),
                        items: _categories
                            .map((c) => DropdownMenuItem(
                          value: c,
                          child: Text(c),
                        ))
                            .toList(),
                        onChanged: (v) =>
                            setModal(() => category = v!),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // File picker
                  const Text("File",
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () {
                      setModal(() {
                        fileType = ["PDF", "JPG", "DOC"][DateTime.now().millisecond % 3];
                        fileName =
                        "document_${DateTime.now().millisecondsSinceEpoch}.${fileType.toLowerCase()}";
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: fileName.isEmpty
                            ? Colors.grey.shade50
                            : Colors.indigo.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: fileName.isEmpty
                              ? Colors.grey.shade200
                              : Colors.indigo.withOpacity(0.3),
                          style: fileName.isEmpty
                              ? BorderStyle.solid
                              : BorderStyle.solid,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: fileName.isEmpty
                                  ? Colors.grey.shade200
                                  : Colors.indigo.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              fileName.isEmpty
                                  ? Icons.cloud_upload_rounded
                                  : _fileIcon(fileType),
                              color: fileName.isEmpty
                                  ? Colors.grey
                                  : _fileColor(fileType),
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  fileName.isEmpty
                                      ? "Tap to select file"
                                      : fileName,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: fileName.isEmpty
                                        ? Colors.grey.shade700
                                        : Colors.indigo,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  fileName.isEmpty
                                      ? "PDF, JPG, DOC (max 5 MB)"
                                      : "Ready to upload",
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
                          if (fileName.isNotEmpty)
                            IconButton(
                              onPressed: () =>
                                  setModal(() => fileName = ""),
                              icon: const Icon(Icons.close_rounded,
                                  size: 18, color: Colors.red),
                            ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (titleCtrl.text.trim().isEmpty) {
                          _snack("Please enter document title",
                              color: Colors.red);
                          return;
                        }
                        if (fileName.isEmpty) {
                          _snack("Please select a file",
                              color: Colors.red);
                          return;
                        }

                        setState(() {
                          if (forStudent) {
                            _studentDocuments.insert(0, {
                              "id":
                              "SD${DateTime.now().millisecondsSinceEpoch}",
                              "title": titleCtrl.text,
                              "studentName": "Select Student",
                              "class": "Class 10 - A",
                              "roll": 0,
                              "type": fileType,
                              "size": "1.2 MB",
                              "source": "Teacher Upload",
                              "uploadedOn": "Today",
                              "status": "Pending",
                              "color": Colors.orange,
                              "notes": "Uploaded by teacher",
                            });
                          } else {
                            _myDocuments.insert(0, {
                              "id":
                              "DOC${DateTime.now().millisecondsSinceEpoch}",
                              "title": titleCtrl.text,
                              "type": fileType,
                              "size": "1.2 MB",
                              "category": category,
                              "uploadedOn": "Today",
                              "status": "Pending",
                              "color": Colors.orange,
                              "notes": "Awaiting verification",
                            });
                          }
                        });

                        Navigator.pop(ctx);
                        _snack("Document uploaded successfully!");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        padding:
                        const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.cloud_upload_rounded,
                          color: Colors.white, size: 18),
                      label: const Text("Upload Document",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14)),
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
  }) {
    return TextField(
      controller: controller,
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

  // ==================== PREVIEW SHEET ====================
  void _showPreview(Map<String, dynamic> d, {bool isStudentDoc = false}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        constraints:
        BoxConstraints(maxHeight: MediaQuery.of(ctx).size.height * 0.9),
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
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // File preview
                    Container(
                      height: 220,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: _fileColor(d['type'] as String)
                            .withOpacity(0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: _fileColor(d['type'] as String)
                                .withOpacity(0.2)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _fileIcon(d['type'] as String),
                            size: 60,
                            color: _fileColor(d['type'] as String),
                          ),
                          const SizedBox(height: 10),
                          Text(d['type'] as String,
                              style: TextStyle(
                                fontSize: 14,
                                color: _fileColor(d['type'] as String),
                                fontWeight: FontWeight.w700,
                              )),
                          const SizedBox(height: 4),
                          Text("${d['size']}",
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[600])),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Title
                    Row(
                      children: [
                        Expanded(
                          child: Text(d['title'] as String,
                              style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700)),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _statusColor(d['status'] as String)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _statusIcon(d['status'] as String),
                                size: 12,
                                color:
                                _statusColor(d['status'] as String),
                              ),
                              const SizedBox(width: 4),
                              Text(d['status'] as String,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color:
                                    _statusColor(d['status'] as String),
                                    fontWeight: FontWeight.w700,
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 10),

                    if (isStudentDoc) ...[
                      _kvRow("Student", d['studentName'] as String),
                      _kvRow("Class", d['class'] as String),
                      _kvRow("Roll No", "${d['roll']}"),
                      _kvRow("Source", d['source'] as String),
                    ] else ...[
                      _kvRow("Category", d['category'] as String),
                    ],
                    _kvRow("Document ID", d['id'] as String),
                    _kvRow("File Type", d['type'] as String),
                    _kvRow("File Size", d['size'] as String),
                    _kvRow("Uploaded On", d['uploadedOn'] as String),

                    const SizedBox(height: 12),

                    // Notes
                    if ((d['notes'] as String).isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _statusColor(d['status'] as String)
                              .withOpacity(0.06),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: _statusColor(d['status'] as String)
                                  .withOpacity(0.2)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              size: 16,
                              color: _statusColor(d['status'] as String),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(d['notes'] as String,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[800],
                                    height: 1.4,
                                  )),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 18),

                    // Action buttons
                    if (isStudentDoc &&
                        d['status'] == "Pending") ...[
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.pop(ctx);
                                _showRejectDialog(d);
                              },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 13),
                                side: const BorderSide(color: Colors.red),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: const Icon(Icons.close_rounded,
                                  color: Colors.red, size: 18),
                              label: const Text("Reject",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(ctx);
                                _verifyDocument(d);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 13),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: const Icon(Icons.verified_rounded,
                                  color: Colors.white, size: 18),
                              label: const Text("Verify Document",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.pop(ctx);
                                _snack("Opening file...");
                              },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 13),
                                side:
                                const BorderSide(color: Colors.indigo),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: const Icon(Icons.visibility_rounded,
                                  color: Colors.indigo, size: 18),
                              label: const Text("View",
                                  style: TextStyle(
                                      color: Colors.indigo,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.pop(ctx);
                                _snack("Downloading...");
                              },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 13),
                                side:
                                const BorderSide(color: Colors.indigo),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: const Icon(Icons.download_rounded,
                                  color: Colors.indigo, size: 18),
                              label: const Text("Download",
                                  style: TextStyle(
                                      color: Colors.indigo,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _kvRow(String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(k,
              style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          Flexible(
            child: Text(v,
                style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w600),
                textAlign: TextAlign.right),
          ),
        ],
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
        title: const Text("Documents",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
        actions: [
          IconButton(
            tooltip: "Upload",
            onPressed: () => _showUploadSheet(),
            icon: const Icon(Icons.upload_file_rounded),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle:
          const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          tabs: [
            const Tab(text: "My Documents"),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Student Docs"),
                  if (_pendingCount > 0) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text("$_pendingCount",
                          style: const TextStyle(
                              fontSize: 9,
                              color: Colors.white,
                              fontWeight: FontWeight.w700)),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMyDocumentsTab(),
          _buildStudentDocsTab(),
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
                  const Text("Upload Document",
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text("Choose what you want to upload",
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey[600])),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.indigo.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.upload_file_rounded,
                          color: Colors.indigo),
                    ),
                    title: const Text("My Document",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: Text(
                        "Upload personal or professional docs",
                        style: TextStyle(
                            fontSize: 11, color: Colors.grey[600])),
                    onTap: () {
                      Navigator.pop(context);
                      _showUploadSheet();
                    },
                  ),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.school_rounded,
                          color: Colors.purple),
                    ),
                    title: const Text("Student Document",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: Text(
                        "Upload docs on behalf of a student",
                        style: TextStyle(
                            fontSize: 11, color: Colors.grey[600])),
                    onTap: () {
                      Navigator.pop(context);
                      _showUploadSheet(forStudent: true);
                    },
                  ),
                ],
              ),
            ),
          );
        },
        backgroundColor: Colors.indigo,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text("Upload",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }

  // ==================== TAB 1: MY DOCUMENTS ====================
  Widget _buildMyDocumentsTab() {
    return Column(
      children: [
        // Filter bar
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
          child: Column(
            children: [
              TextField(
                controller: _searchCtrl,
                style: const TextStyle(fontSize: 13),
                decoration: InputDecoration(
                  hintText: "Search my documents...",
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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:
                  ["All", "Verified", "Pending", "Rejected"].map((s) {
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
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: _filteredMyDocs.isEmpty
              ? _emptyState("No documents found")
              : ListView.separated(
            padding: const EdgeInsets.all(14),
            itemCount: _filteredMyDocs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) => _buildDocTile(
              _filteredMyDocs[index],
              isStudentDoc: false,
            ),
          ),
        ),
      ],
    );
  }

  // ==================== TAB 2: STUDENT DOCS ====================
  Widget _buildStudentDocsTab() {
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
          child: Column(
            children: [
              TextField(
                controller: _searchCtrl,
                style: const TextStyle(fontSize: 13),
                decoration: InputDecoration(
                  hintText: "Search by doc or student name...",
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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:
                  ["All", "Pending", "Verified", "Rejected"].map((s) {
                    final sel = _statusFilter == s;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(s),
                        selected: sel,
                        onSelected: (_) =>
                            setState(() => _statusFilter = s),
                        selectedColor: s == "Pending"
                            ? Colors.orange
                            : Colors.indigo,
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
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: _filteredStudentDocs.isEmpty
              ? _emptyState("No student documents found")
              : ListView.separated(
            padding: const EdgeInsets.all(14),
            itemCount: _filteredStudentDocs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) => _buildDocTile(
              _filteredStudentDocs[index],
              isStudentDoc: true,
            ),
          ),
        ),
      ],
    );
  }

  // ==================== DOC TILE ====================
  Widget _buildDocTile(Map<String, dynamic> d, {bool isStudentDoc = false}) {
    final status = d['status'] as String;
    final sc = _statusColor(status);
    final fColor = _fileColor(d['type'] as String);

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _showPreview(d, isStudentDoc: isStudentDoc),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Row(
              children: [
                // File icon
                Container(
                  width: 48,
                  height: 56,
                  decoration: BoxDecoration(
                    color: fColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: fColor.withOpacity(0.25)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(_fileIcon(d['type'] as String),
                          color: fColor, size: 20),
                      const SizedBox(height: 3),
                      Text(d['type'] as String,
                          style: TextStyle(
                              fontSize: 9,
                              color: fColor,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(d['title'] as String,
                          style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 3),
                      if (isStudentDoc)
                        Row(
                          children: [
                            Icon(Icons.person_rounded,
                                size: 11, color: Colors.grey[600]),
                            const SizedBox(width: 3),
                            Flexible(
                              child: Text(
                                  "${d['studentName']} • ${d['class']}",
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey[600]),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        )
                      else
                        Row(
                          children: [
                            Icon(Icons.category_rounded,
                                size: 11, color: Colors.grey[600]),
                            const SizedBox(width: 3),
                            Text(d['category'] as String,
                                style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[600])),
                          ],
                        ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.calendar_today_rounded,
                              size: 10, color: Colors.grey[600]),
                          const SizedBox(width: 3),
                          Text(d['uploadedOn'] as String,
                              style: TextStyle(
                                  fontSize: 10, color: Colors.grey[600])),
                          const SizedBox(width: 8),
                          Text("• ${d['size']}",
                              style: TextStyle(
                                  fontSize: 10, color: Colors.grey[600])),
                        ],
                      ),
                    ],
                  ),
                ),
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: sc.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_statusIcon(status), size: 11, color: sc),
                      const SizedBox(width: 3),
                      Text(status,
                          style: TextStyle(
                              fontSize: 10,
                              color: sc,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ],
            ),

            // Source + Actions row (for student docs)
            if (isStudentDoc) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  // Source tag
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: _sourceColor(d['source'] as String)
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.cloud_download_rounded,
                            size: 10,
                            color: _sourceColor(d['source'] as String)),
                        const SizedBox(width: 3),
                        Text(d['source'] as String,
                            style: TextStyle(
                                fontSize: 9.5,
                                color: _sourceColor(d['source'] as String),
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Quick verify/reject buttons
                  if (status == "Pending") ...[
                    InkWell(
                      onTap: () => _showRejectDialog(d),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: Colors.red.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.close_rounded,
                                size: 13, color: Colors.red),
                            SizedBox(width: 3),
                            Text("Reject",
                                style: TextStyle(
                                    fontSize: 10.5,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    InkWell(
                      onTap: () => _verifyDocument(d),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: Colors.green.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.check_rounded,
                                size: 13, color: Colors.green),
                            SizedBox(width: 3),
                            Text("Verify",
                                style: TextStyle(
                                    fontSize: 10.5,
                                    color: Colors.green,
                                    fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                    ),
                  ] else
                    Text(
                      "Tap to view details",
                      style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[500],
                          fontStyle: FontStyle.italic),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _emptyState(String msg) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.folder_off_rounded,
              size: 60, color: Colors.grey.shade400),
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