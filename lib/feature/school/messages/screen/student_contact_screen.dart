// lib/feature/school/student_list/screen/student_contact_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/widget/contact_helper.dart';
import '../../../../core/widget/flutter_toast.dart';
import '../../student/controller/student_list_controller.dart';
import '../../student/model/student_list_model.dart';


class StudentContactScreen extends StatefulWidget {
  const StudentContactScreen({super.key});

  @override
  State<StudentContactScreen> createState() => _StudentContactScreenState();
}

class _StudentContactScreenState extends State<StudentContactScreen> {
  final StudentListController controller = Get.put(StudentListController());

  // ==================== SEARCH & FILTER ====================
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = "";
  String _selectedClass = "All Classes";
  bool _whatsappOnly = false;

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
  List<StudentListData> get _filteredStudents {
    var list = List<StudentListData>.from(controller.studentList);

    // Search
    if (_searchQuery.isNotEmpty) {
      list = list.where((s) {
        return s.fullName.toLowerCase().contains(_searchQuery) ||
            s.fatherName.toLowerCase().contains(_searchQuery) ||
            s.motherName.toLowerCase().contains(_searchQuery) ||
            s.parentPhone.contains(_searchQuery) ||
            s.rollNumber.contains(_searchQuery);
      }).toList();
    }

    // Class
    if (_selectedClass != "All Classes") {
      list = list.where((s) => s.studentClass == _selectedClass).toList();
    }

    // WhatsApp only
    if (_whatsappOnly) {
      list = list.where((s) => s.parentPhone.isNotEmpty).toList();
    }

    return list;
  }

  List<String> get _classes {
    final classes = controller.getUniqueClasses();
    return ["All Classes", ...classes];
  }

  // ==================== ACTIONS ====================
  Future<void> _openWhatsApp(String phone, String name) async {
    final cleanPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanPhone.isEmpty) {
      FlutterToast.error('No phone number available');
      return;
    }
    final msg = "Hello $name, this is from Suwidhaa School.";
    await ContactHelper.whatsapp(cleanPhone, msg);
  }

  Future<void> _makeCall(String phone) async {
    if (phone.isEmpty) {
      FlutterToast.error('No phone number available');
      return;
    }
    await ContactHelper.call(phone);
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
        title: const Text(
          "Student Contacts",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
        ),
        actions: [
          IconButton(
            tooltip: "Refresh",
            onPressed: () => controller.refreshStudents(),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: Obx(() {
        // Loading
        if (controller.isLoading.value && controller.studentList.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.indigo),
          );
        }

        // Error
        if (controller.errorMessage.isNotEmpty &&
            controller.studentList.isEmpty) {
          return _errorState(controller.errorMessage.value);
        }

        final filtered = _filteredStudents;

        return Column(
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
                        borderSide:
                        BorderSide(color: Colors.grey.shade200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                        BorderSide(color: Colors.grey.shade200),
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12),
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Colors.grey.shade200),
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
                                fontSize: 13,
                              ),
                              items: _classes
                                  .map((c) => DropdownMenuItem(
                                value: c,
                                child: Text(c),
                              ))
                                  .toList(),
                              onChanged: (v) => setState(
                                      () => _selectedClass = v!),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // WhatsApp filter toggle
                      InkWell(
                        onTap: () => setState(
                                () => _whatsappOnly = !_whatsappOnly),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          height: 40,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12),
                          decoration: BoxDecoration(
                            color: _whatsappOnly
                                ? const Color(0xFF25D366)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _whatsappOnly
                                  ? const Color(0xFF25D366)
                                  : Colors.grey.shade300,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.chat_rounded,
                                size: 16,
                                color: _whatsappOnly
                                    ? Colors.white
                                    : const Color(0xFF25D366),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "WhatsApp",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: _whatsappOnly
                                      ? Colors.white
                                      : Colors.black87,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
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

            // ===== COUNT STRIP =====
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "${filtered.length} contacts",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // ===== STUDENT LIST =====
            Expanded(
              child: filtered.isEmpty
                  ? _emptyState()
                  : RefreshIndicator(
                onRefresh: controller.refreshStudents,
                color: Colors.indigo,
                child: ListView.separated(
                  padding: const EdgeInsets.all(14),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) =>
                  const SizedBox(height: 10),
                  itemBuilder: (context, index) =>
                      _buildStudentTile(filtered[index]),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  // ==================== STUDENT TILE ====================
  Widget _buildStudentTile(StudentListData s) {
    final color = s.genderColor;
    final initials = s.displayName + _secondInitial(s.fullName);
    final phone = s.parentPhone;

    return Container(
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
                child: Text(
                  initials,
                  style: TextStyle(
                    fontSize: 15,
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (phone.isNotEmpty)
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
                Text(
                  s.fullName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
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
                      child: Text(
                        "Roll ${s.rollNumber}",
                        style: const TextStyle(
                          fontSize: 9,
                          color: Colors.indigo,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        "Class ${s.studentClass}",
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
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
                      child: Text(
                        phone.isNotEmpty ? phone : 'No phone',
                        style: TextStyle(
                          fontSize: 10.5,
                          color: Colors.grey[700],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ─── Action buttons ───
          Column(
            children: [
              // WhatsApp
              InkWell(
                onTap: phone.isNotEmpty
                    ? () => _openWhatsApp(
                  phone,
                  s.fatherName.isNotEmpty
                      ? s.fatherName
                      : 'Parent',
                )
                    : null,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: phone.isNotEmpty
                        ? const Color(0xFF25D366)
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.chat_rounded,
                    color: phone.isNotEmpty
                        ? Colors.white
                        : Colors.grey,
                    size: 16,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              // Call
              InkWell(
                onTap: phone.isNotEmpty
                    ? () => _makeCall(phone)
                    : null,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: phone.isNotEmpty
                        ? Colors.indigo
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.phone_rounded,
                    color: phone.isNotEmpty
                        ? Colors.white
                        : Colors.grey,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _secondInitial(String fullName) {
    final parts = fullName.trim().split(' ');
    if (parts.length > 1 && parts[1].isNotEmpty) {
      return parts[1][0].toUpperCase();
    }
    return '';
  }

  // ==================== EMPTY ====================
  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.person_search_rounded,
              size: 60, color: Colors.grey.shade400),
          const SizedBox(height: 10),
          Text(
            "No contacts found",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Try changing filters or search",
            style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  // ==================== ERROR ====================
  Widget _errorState(String error) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline_rounded,
              size: 60, color: Colors.red.shade300),
          const SizedBox(height: 10),
          Text(
            "Failed to load contacts",
            style: TextStyle(
              fontSize: 14,
              color: Colors.red.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ),
          const SizedBox(height: 14),
          ElevatedButton(
            onPressed: () => controller.refreshStudents(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}