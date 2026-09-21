import 'package:flutter/material.dart';

class StudentContactScreen extends StatefulWidget {
  const StudentContactScreen({super.key});

  @override
  State<StudentContactScreen> createState() => _StudentContactScreenState();
}

class _StudentContactScreenState extends State<StudentContactScreen> {
  // ==================== SEARCH & FILTER ====================
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = "";
  String _selectedClass = "All Classes";
  String _filterType = "All"; // All | Students | Parents | Both Available

  // ==================== CLASSES ====================
  final List<String> _classes = [
    "All Classes",
    "Class 10 - A",
    "Class 10 - B",
    "Class 9 - A",
    "Class 9 - B",
  ];

  // ==================== STUDENTS DATA ====================
  final List<Map<String, dynamic>> _students = [
    {
      "id": "STU001",
      "roll": 1,
      "name": "Aarav Sharma",
      "class": "Class 10 - A",
      "studentPhone": "+91 98765 43210",
      "parentName": "Rajesh Sharma",
      "parentPhone": "+91 98765 11111",
      "email": "aarav.sharma@school.edu",
      "avatar": Colors.indigo,
      "hasWhatsapp": true,
    },
    {
      "id": "STU002",
      "roll": 2,
      "name": "Priya Verma",
      "class": "Class 10 - A",
      "studentPhone": "+91 98765 43211",
      "parentName": "Sunita Verma",
      "parentPhone": "+91 98765 11112",
      "email": "priya.verma@school.edu",
      "avatar": Colors.teal,
      "hasWhatsapp": true,
    },
    {
      "id": "STU003",
      "roll": 3,
      "name": "Rohan Gupta",
      "class": "Class 10 - A",
      "studentPhone": "+91 98765 43212",
      "parentName": "Amit Gupta",
      "parentPhone": "+91 98765 11113",
      "email": "rohan.gupta@school.edu",
      "avatar": Colors.orange,
      "hasWhatsapp": true,
    },
    {
      "id": "STU004",
      "roll": 4,
      "name": "Sneha Patel",
      "class": "Class 10 - A",
      "studentPhone": "+91 98765 43213",
      "parentName": "Meena Patel",
      "parentPhone": "+91 98765 11114",
      "email": "sneha.patel@school.edu",
      "avatar": Colors.purple,
      "hasWhatsapp": true,
    },
    {
      "id": "STU005",
      "roll": 5,
      "name": "Karan Singh",
      "class": "Class 10 - B",
      "studentPhone": "+91 98765 43214",
      "parentName": "Harpreet Singh",
      "parentPhone": "+91 98765 11115",
      "email": "karan.singh@school.edu",
      "avatar": Colors.red,
      "hasWhatsapp": true,
    },
    {
      "id": "STU006",
      "roll": 6,
      "name": "Ananya Iyer",
      "class": "Class 10 - B",
      "studentPhone": "+91 98765 43215",
      "parentName": "Ramesh Iyer",
      "parentPhone": "+91 98765 11116",
      "email": "ananya.iyer@school.edu",
      "avatar": Colors.blueGrey,
      "hasWhatsapp": true,
    },
    {
      "id": "STU007",
      "roll": 7,
      "name": "Vikram Reddy",
      "class": "Class 9 - A",
      "studentPhone": "+91 98765 43216",
      "parentName": "Krishna Reddy",
      "parentPhone": "+91 98765 11117",
      "email": "vikram.reddy@school.edu",
      "avatar": Colors.green,
      "hasWhatsapp": true,
    },
    {
      "id": "STU008",
      "roll": 8,
      "name": "Meera Joshi",
      "class": "Class 9 - A",
      "studentPhone": "+91 98765 43217",
      "parentName": "Anil Joshi",
      "parentPhone": "+91 98765 11118",
      "email": "meera.joshi@school.edu",
      "avatar": Colors.pink,
      "hasWhatsapp": false,
    },
    {
      "id": "STU009",
      "roll": 9,
      "name": "Aditya Nair",
      "class": "Class 9 - B",
      "studentPhone": "+91 98765 43218",
      "parentName": "Suresh Nair",
      "parentPhone": "+91 98765 11119",
      "email": "aditya.nair@school.edu",
      "avatar": Colors.brown,
      "hasWhatsapp": true,
    },
    {
      "id": "STU010",
      "roll": 10,
      "name": "Riya Kapoor",
      "class": "Class 9 - B",
      "studentPhone": "+91 98765 43219",
      "parentName": "Vikash Kapoor",
      "parentPhone": "+91 98765 11120",
      "email": "riya.kapoor@school.edu",
      "avatar": Colors.deepOrange,
      "hasWhatsapp": true,
    },
  ];

  // ==================== QUICK MESSAGE TEMPLATES ====================
  final List<Map<String, dynamic>> _templates = [
    {
      "title": "Attendance Alert",
      "message":
      "Dear Parent, your child was absent today. Please inform us about the reason.",
      "icon": Icons.event_busy_rounded,
      "color": Colors.red,
    },
    {
      "title": "Homework Reminder",
      "message":
      "Dear Parent, kindly ensure your child completes the homework assigned for tomorrow.",
      "icon": Icons.assignment_rounded,
      "color": Colors.orange,
    },
    {
      "title": "Exam Schedule",
      "message":
      "Dear Parent, the exam schedule has been released. Please check the school app for details.",
      "icon": Icons.event_note_rounded,
      "color": Colors.indigo,
    },
    {
      "title": "Fee Reminder",
      "message":
      "Dear Parent, this is a gentle reminder to pay the pending school fees at your earliest.",
      "icon": Icons.payment_rounded,
      "color": Colors.teal,
    },
    {
      "title": "PTM Invitation",
      "message":
      "Dear Parent, you are invited for the Parent-Teacher Meeting. Your presence is appreciated.",
      "icon": Icons.groups_rounded,
      "color": Colors.purple,
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

  // ==================== FILTERS ====================
  List<Map<String, dynamic>> get _filteredStudents {
    var list = List<Map<String, dynamic>>.from(_students);
    if (_searchQuery.isNotEmpty) {
      list = list.where((s) {
        return (s['name'] as String).toLowerCase().contains(_searchQuery) ||
            (s['parentName'] as String)
                .toLowerCase()
                .contains(_searchQuery) ||
            (s['studentPhone'] as String).contains(_searchQuery) ||
            (s['roll'].toString()).contains(_searchQuery);
      }).toList();
    }
    if (_selectedClass != "All Classes") {
      list = list.where((s) => s['class'] == _selectedClass).toList();
    }
    if (_filterType == "Both Available") {
      list = list
          .where((s) =>
      (s['studentPhone'] as String).isNotEmpty &&
          (s['parentPhone'] as String).isNotEmpty)
          .toList();
    } else if (_filterType == "WhatsApp") {
      list = list.where((s) => s['hasWhatsapp'] == true).toList();
    }
    return list;
  }

  // ==================== ACTIONS ====================
  void _snack(String msg, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        backgroundColor: color ?? Colors.green,
      ),
    );
  }

  void _openWhatsApp(String phone, String name, {String? message}) {
    // In real app: launch('https://wa.me/$cleanPhone?text=$message')
    final cleanPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');
    final msgText = message ?? "Hello $name, this is from Suwidhaa School.";
    _snack("Opening WhatsApp for $name...", color: Colors.green);
    // TODO: launchUrl(Uri.parse('https://wa.me/$cleanPhone?text=${Uri.encodeComponent(msgText)}'));
  }

  void _makeCall(String phone, String name) {
    _snack("Calling $name at $phone...", color: Colors.blue);
    // TODO: launchUrl(Uri.parse('tel:$phone'));
  }

  void _sendEmail(String email, String name) {
    _snack("Opening email for $name...", color: Colors.orange);
    // TODO: launchUrl(Uri.parse('mailto:$email'));
  }

  // ==================== CONTACT ACTION SHEET ====================
  void _showContactActions(Map<String, dynamic> s) {
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

              // Student header
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor:
                    (s['avatar'] as Color).withOpacity(0.15),
                    child: Text(
                      (s['name'] as String)
                          .split(' ')
                          .map((e) => e[0])
                          .take(2)
                          .join(),
                      style: TextStyle(
                        fontSize: 16,
                        color: s['avatar'] as Color,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s['name'] as String,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700)),
                        const SizedBox(height: 3),
                        Text("${s['class']} • Roll ${s['roll']}",
                            style: TextStyle(
                                fontSize: 11, color: Colors.grey[600])),
                      ],
                    ),
                  ),
                  if (s['hasWhatsapp'] == true)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.chat_rounded,
                              size: 10, color: Colors.green),
                          SizedBox(width: 3),
                          Text("WhatsApp",
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 18),

              // ==== Contact Options ====
              const Text("Student Contact",
                  style: TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              _contactCard(
                name: s['name'] as String,
                phone: s['studentPhone'] as String,
                role: "Student",
                color: Colors.indigo,
                onWhatsapp: () {
                  Navigator.pop(ctx);
                  _openWhatsApp(s['studentPhone'] as String,
                      s['name'] as String);
                },
                onCall: () {
                  Navigator.pop(ctx);
                  _makeCall(
                      s['studentPhone'] as String, s['name'] as String);
                },
              ),

              const SizedBox(height: 10),

              const Text("Parent Contact",
                  style: TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              _contactCard(
                name: s['parentName'] as String,
                phone: s['parentPhone'] as String,
                role: "Parent",
                color: Colors.teal,
                onWhatsapp: () {
                  Navigator.pop(ctx);
                  _openWhatsApp(s['parentPhone'] as String,
                      s['parentName'] as String);
                },
                onCall: () {
                  Navigator.pop(ctx);
                  _makeCall(
                      s['parentPhone'] as String, s['parentName'] as String);
                },
              ),

              const SizedBox(height: 14),

              // Email
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    _sendEmail(s['email'] as String, s['name'] as String);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: Colors.indigo),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.email_rounded,
                      color: Colors.indigo, size: 18),
                  label: Text(s['email'] as String,
                      style: const TextStyle(
                          color: Colors.indigo,
                          fontWeight: FontWeight.w600,
                          fontSize: 12)),
                ),
              ),

              const SizedBox(height: 14),

              // Quick messages
              Row(
                children: [
                  const Text("Send Quick Message",
                      style: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w700)),
                  const Spacer(),
                  Text("via WhatsApp",
                      style: TextStyle(
                          fontSize: 10,
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 10),
              Column(
                children: _templates.map((t) {
                  return InkWell(
                    onTap: () {
                      Navigator.pop(ctx);
                      _openWhatsApp(
                        s['parentPhone'] as String,
                        s['parentName'] as String,
                        message: t['message'] as String,
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: (t['color'] as Color).withOpacity(0.06),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color:
                            (t['color'] as Color).withOpacity(0.2)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: (t['color'] as Color)
                                  .withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(t['icon'] as IconData,
                                color: t['color'] as Color, size: 16),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(t['title'] as String,
                                    style: const TextStyle(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w700)),
                                const SizedBox(height: 2),
                                Text(
                                  t['message'] as String,
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey[700]),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.send_rounded,
                              color: t['color'] as Color, size: 16),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _contactCard({
    required String name,
    required String phone,
    required String role,
    required Color color,
    required VoidCallback onWhatsapp,
    required VoidCallback onCall,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.person_rounded, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(name,
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(role,
                          style: TextStyle(
                              fontSize: 9,
                              color: color,
                              fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(phone,
                    style: TextStyle(
                        fontSize: 11, color: Colors.grey[700])),
              ],
            ),
          ),
          // WhatsApp button
          InkWell(
            onTap: onWhatsapp,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: const Color(0xFF25D366),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.chat_rounded,
                  color: Colors.white, size: 18),
            ),
          ),
          const SizedBox(width: 6),
          // Call button
          InkWell(
            onTap: onCall,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.phone_rounded,
                  color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== BULK WHATSAPP SHEET ====================
  void _showBulkSheet() {
    final msgCtrl = TextEditingController();
    final Set<String> selectedIds = {};

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) => Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
          ),
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(ctx).size.height * 0.9),
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
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF25D366).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.chat_bubble_rounded,
                        color: Color(0xFF25D366), size: 20),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text("Bulk WhatsApp Message",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                "Send a message to multiple parents at once.",
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const SizedBox(height: 14),

              // Message input
              TextField(
                controller: msgCtrl,
                maxLines: 3,
                style: const TextStyle(fontSize: 13),
                decoration: InputDecoration(
                  hintText: "Type your message...",
                  hintStyle: const TextStyle(fontSize: 13),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  contentPadding: const EdgeInsets.all(12),
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
                        color: Color(0xFF25D366), width: 1.4),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Template chips
              SizedBox(
                height: 32,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: _templates.map((t) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: InkWell(
                        onTap: () =>
                        msgCtrl.text = t['message'] as String,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color:
                            (t['color'] as Color).withOpacity(0.08),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: (t['color'] as Color)
                                    .withOpacity(0.25)),
                          ),
                          child: Row(
                            children: [
                              Icon(t['icon'] as IconData,
                                  size: 12, color: t['color'] as Color),
                              const SizedBox(width: 4),
                              Text(t['title'] as String,
                                  style: TextStyle(
                                      fontSize: 10.5,
                                      color: t['color'] as Color,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 14),
              Row(
                children: [
                  const Text("Select Recipients",
                      style: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w700)),
                  const Spacer(),
                  Text("${selectedIds.length} selected",
                      style: const TextStyle(
                          fontSize: 11,
                          color: Colors.indigo,
                          fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 8),

              // Student list
              Expanded(
                child: ListView.builder(
                  itemCount: _students.length,
                  itemBuilder: (context, index) {
                    final s = _students[index];
                    final id = s['id'] as String;
                    final sel = selectedIds.contains(id);
                    return Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: sel
                            ? const Color(0xFF25D366).withOpacity(0.06)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: sel
                              ? const Color(0xFF25D366).withOpacity(0.4)
                              : Colors.grey.shade200,
                          width: sel ? 1.3 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor:
                            (s['avatar'] as Color).withOpacity(0.15),
                            child: Text(
                              (s['name'] as String)
                                  .split(' ')
                                  .map((e) => e[0])
                                  .take(2)
                                  .join(),
                              style: TextStyle(
                                  fontSize: 10,
                                  color: s['avatar'] as Color,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(s['name'] as String,
                                    style: const TextStyle(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w600)),
                                Text(
                                    s['parentPhone'] as String,
                                    style: TextStyle(
                                        fontSize: 10.5,
                                        color: Colors.grey[600])),
                              ],
                            ),
                          ),
                          Checkbox(
                            value: sel,
                            activeColor: const Color(0xFF25D366),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            onChanged: (v) => setModal(() {
                              if (v == true)
                                selectedIds.add(id);
                              else
                                selectedIds.remove(id);
                            }),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (msgCtrl.text.isEmpty) {
                      _snack("Please type a message", color: Colors.red);
                      return;
                    }
                    if (selectedIds.isEmpty) {
                      _snack("Please select recipients",
                          color: Colors.red);
                      return;
                    }
                    Navigator.pop(ctx);
                    _snack(
                        "Sending WhatsApp to ${selectedIds.length} parents...",
                        color: const Color(0xFF25D366));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF25D366),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.send_rounded,
                      color: Colors.white, size: 18),
                  label: const Text("Send to Selected",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14)),
                ),
              ),
            ],
          ),
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
        title: const Text("Student Contacts",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
        actions: [
          IconButton(
            tooltip: "Bulk WhatsApp",
            onPressed: _showBulkSheet,
            icon: const Icon(Icons.groups_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          // ===== SEARCH + FILTER BAR =====
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
            child: Column(
              children: [
                // Search
                TextField(
                  controller: _searchCtrl,
                  style: const TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    hintText: "Search name, roll or phone...",
                    hintStyle: const TextStyle(fontSize: 13),
                    prefixIcon: const Icon(Icons.search_rounded,
                        color: Colors.indigo, size: 20),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                      onPressed: () => _searchCtrl.clear(),
                      icon: const Icon(Icons.clear_rounded,
                          size: 18, color: Colors.grey),
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
                      borderSide: const BorderSide(
                          color: Colors.indigo, width: 1.4),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Class + WhatsApp filter
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedClass,
                            isExpanded: true,
                            icon: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: Colors.indigo,
                                size: 20),
                            style: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                                fontSize: 13),
                            items: _classes
                                .map((c) => DropdownMenuItem(
                              value: c,
                              child: Text(c),
                            ))
                                .toList(),
                            onChanged: (v) =>
                                setState(() => _selectedClass = v!),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // WhatsApp-only toggle chip
                    InkWell(
                      onTap: () => setState(() => _filterType =
                      _filterType == "WhatsApp" ? "All" : "WhatsApp"),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: _filterType == "WhatsApp"
                              ? const Color(0xFF25D366)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _filterType == "WhatsApp"
                                ? const Color(0xFF25D366)
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.chat_rounded,
                                size: 16,
                                color: _filterType == "WhatsApp"
                                    ? Colors.white
                                    : const Color(0xFF25D366)),
                            const SizedBox(width: 5),
                            Text("WhatsApp",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: _filterType == "WhatsApp"
                                        ? Colors.white
                                        : Colors.black87,
                                    fontWeight: FontWeight.w600)),
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

          // ===== BULK ACTION STRIP =====
          Container(
            color: Colors.white,
            padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "${_filteredStudents.length} contacts",
                    style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                TextButton.icon(
                  onPressed: _showBulkSheet,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  icon: const Icon(Icons.groups_rounded,
                      size: 15, color: Color(0xFF25D366)),
                  label: const Text("Bulk WhatsApp",
                      style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF25D366),
                          fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // ===== STUDENT LIST =====
          Expanded(
            child: _filteredStudents.isEmpty
                ? _emptyState()
                : ListView.separated(
              padding: const EdgeInsets.all(14),
              itemCount: _filteredStudents.length,
              separatorBuilder: (_, __) =>
              const SizedBox(height: 10),
              itemBuilder: (context, index) =>
                  _buildStudentTile(_filteredStudents[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentTile(Map<String, dynamic> s) {
    final color = s['avatar'] as Color;
    final initials = (s['name'] as String)
        .split(' ')
        .map((e) => e[0])
        .take(2)
        .join();

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _showContactActions(s),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            // Avatar
            Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: color.withOpacity(0.15),
                  child: Text(initials,
                      style: TextStyle(
                          fontSize: 15,
                          color: color,
                          fontWeight: FontWeight.w700)),
                ),
                if (s['hasWhatsapp'] == true)
                  Positioned(
                    right: -2,
                    bottom: -2,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF25D366),
                        shape: BoxShape.circle,
                        border:
                        Border.all(color: Colors.white, width: 1.5),
                      ),
                      child: const Icon(Icons.chat_rounded,
                          color: Colors.white, size: 10),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s['name'] as String,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w700),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: Colors.indigo.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text("Roll ${s['roll']}",
                            style: const TextStyle(
                                fontSize: 9,
                                color: Colors.indigo,
                                fontWeight: FontWeight.w700)),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(s['class'] as String,
                            style: TextStyle(
                                fontSize: 10, color: Colors.grey[600]),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.phone_rounded,
                          size: 10, color: Colors.grey[600]),
                      const SizedBox(width: 3),
                      Flexible(
                        child: Text(s['studentPhone'] as String,
                            style: TextStyle(
                                fontSize: 10.5, color: Colors.grey[700]),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Action buttons
            Column(
              children: [
                // WhatsApp
                if (s['hasWhatsapp'] == true)
                  InkWell(
                    onTap: () => _openWhatsApp(
                        s['parentPhone'] as String,
                        s['parentName'] as String),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF25D366),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.chat_rounded,
                          color: Colors.white, size: 16),
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.chat_rounded,
                        color: Colors.grey, size: 16),
                  ),
                const SizedBox(height: 6),
                // Call
                InkWell(
                  onTap: () => _makeCall(s['parentPhone'] as String,
                      s['parentName'] as String),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.indigo,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.phone_rounded,
                        color: Colors.white, size: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.person_search_rounded,
              size: 60, color: Colors.grey.shade400),
          const SizedBox(height: 10),
          Text("No contacts found",
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text("Try changing filters or search",
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
        ],
      ),
    );
  }
}