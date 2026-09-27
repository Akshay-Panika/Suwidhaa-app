import 'package:flutter/material.dart';

class SchoolBookReview extends StatefulWidget {
  final Map<String, dynamic> book;

  const SchoolBookReview({super.key, required this.book});

  @override
  State<SchoolBookReview> createState() => _SchoolBookReviewState();
}

class _SchoolBookReviewState extends State<SchoolBookReview> {
  // ==================== COLOR HELPERS ====================
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

  void _snack(String msg, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        backgroundColor: color ?? Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final b = widget.book;
    final sc = _subjectColor(b['subject'] as String);
    final statusColor = _statusColor(b['status'] as String);
    final grad = _subjectGradient(b['subject'] as String);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: sc,
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text("Book Details",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==================== HEADER WITH BOOK COVER ====================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              decoration: BoxDecoration(
                color: sc.withOpacity(0.08),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Book cover
                  Container(
                    width: 110, height: 155,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: grad,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: sc.withOpacity(0.35),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
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
                          child: Icon(_subjectIcon(b['subject'] as String),
                              color: Colors.white, size: 48),
                        ),
                        Positioned(
                          bottom: 8, left: 0, right: 0,
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                b['class'].toString().replaceAll("Class ", "C-"),
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Book title + author + chips
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          b['title'] as String,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              height: 1.3),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.person_rounded,
                                size: 13, color: Colors.grey[700]),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                b['author'] as String,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[700],
                                    fontStyle: FontStyle.italic),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 6, runSpacing: 6,
                          children: [
                            _miniChip(b['class'] as String, Colors.indigo,
                                icon: Icons.class_rounded),
                            _miniChip(b['subject'] as String, sc,
                                icon: _subjectIcon(b['subject'] as String)),
                            _miniChip(b['status'] as String, statusColor,
                                icon: _statusIcon(b['status'] as String)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ==================== INFO CARD ====================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    _kvRow(Icons.tag_rounded, "Book ID", b['id'] as String),
                    const Divider(height: 20),
                    _kvRow(Icons.qr_code_rounded, "ISBN", b['isbn'] as String),
                    const Divider(height: 20),
                    _kvRow(Icons.calendar_today_rounded, "Published",
                        b['year'] as String),
                    const Divider(height: 20),
                    _kvRow(Icons.shelves, "Shelf No.", b['shelf'] as String),
                    const Divider(height: 20),
                    _kvRow(Icons.inventory_2_rounded, "Copies Available",
                        "${b['copies']} / ${b['total']}"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ==================== STOCK INFO CARD ====================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: statusColor.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(_statusIcon(b['status'] as String),
                          color: statusColor, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            b['status'] as String,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: statusColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            b['status'] == "Available"
                                ? "${b['copies']} copies available for issue"
                                : b['status'] == "Out of Stock"
                                ? "Currently unavailable"
                                : "Coming soon",
                            style: TextStyle(
                                fontSize: 11, color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ==================== ACTION BUTTON ====================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildActionButton(b),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(Map<String, dynamic> b) {
    final status = b['status'] as String;

    if (status == "Available") {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.pop(context);
            _snack("Book issued successfully!");
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: const Icon(Icons.book_rounded,
              color: Colors.white, size: 20),
          label: const Text("Issue Book",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 15)),
        ),
      );
    } else if (status == "Out of Stock") {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.pop(context);
            _snack("You'll be notified when available",
                color: Colors.orange);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: const Icon(Icons.notifications_active_rounded,
              color: Colors.white, size: 20),
          label: const Text("Notify Me",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 15)),
        ),
      );
    }
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: const BorderSide(color: Colors.orange),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: const Icon(Icons.schedule_rounded,
            color: Colors.orange, size: 20),
        label: const Text("Coming Soon",
            style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.w700,
                fontSize: 15)),
      ),
    );
  }

  Widget _kvRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(fontSize: 13, color: Colors.grey[700]),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  Widget _miniChip(String text, Color color, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
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
}