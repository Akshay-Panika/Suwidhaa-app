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

    if (_searchQuery.isNotEmpty) {
      list = list.where((s) {
        return s.fullName.toLowerCase().contains(_searchQuery) ||
            s.fatherName.toLowerCase().contains(_searchQuery) ||
            s.motherName.toLowerCase().contains(_searchQuery) ||
            s.parentPhone.contains(_searchQuery) ||
            s.rollNumber.contains(_searchQuery);
      }).toList();
    }

    if (_selectedClass != "All Classes") {
      list = list.where((s) => s.studentClass == _selectedClass).toList();
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        centerTitle: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, size: 20),
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
          const SizedBox(width: 4),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.studentList.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.indigo),
          );
        }

        if (controller.errorMessage.isNotEmpty &&
            controller.studentList.isEmpty) {
          return _errorState(controller.errorMessage.value);
        }

        final filtered = _filteredStudents;

        return Column(
          children: [
            _filterSection(),
            _countStrip(filtered.length),
            const Divider(height: 1, color: Color(0xFFEEF0F5)),

            Expanded(
              child: filtered.isEmpty
                  ? _emptyState()
                  : RefreshIndicator(
                onRefresh: controller.refreshStudents,
                color: Colors.indigo,
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
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

  // ==================== FILTER SECTION ====================
  Widget _filterSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      child: Column(
        children: [
          // Search bar
          TextField(
            controller: _searchCtrl,
            style: const TextStyle(fontSize: 13.5),
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: "Search name, roll or phone...",
              hintStyle: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: Colors.indigo,
                size: 20,
              ),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                onPressed: () => _searchCtrl.clear(),
                icon: const Icon(Icons.clear_rounded,
                    size: 18, color: Colors.grey),
              )
                  : null,
              filled: true,
              fillColor: Colors.grey.shade50,
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
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

          // Class dropdown
          Container(
            height: 42,
            padding: const EdgeInsets.symmetric(horizontal: 12),
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
                  size: 20,
                ),
                dropdownColor: Colors.white,
                borderRadius: BorderRadius.circular(12),
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
                items: _classes
                    .map((c) => DropdownMenuItem(
                  value: c,
                  child: Row(
                    children: [
                      Icon(
                        c == "All Classes"
                            ? Icons.groups_rounded
                            : Icons.class_rounded,
                        size: 15,
                        color: Colors.indigo,
                      ),
                      const SizedBox(width: 8),
                      Text(c),
                    ],
                  ),
                ))
                    .toList(),
                onChanged: (v) => setState(() => _selectedClass = v!),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== COUNT STRIP ====================
  Widget _countStrip(int count) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 12,
            decoration: BoxDecoration(
              color: Colors.indigo,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 6),
          const Text(
            'CONTACTS',
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
              color: Colors.black54,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(0.10),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$count',
              style: const TextStyle(
                color: Colors.indigo,
                fontWeight: FontWeight.w700,
                fontSize: 11,
              ),
            ),
          ),
          const Spacer(),
          if (count > 0)
            Text(
              count == 1 ? '1 student' : '$count students',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }

  // ==================== STUDENT TILE ====================
  Widget _buildStudentTile(StudentListData s) {
    final color = s.genderColor;
    final initials = s.displayName + _secondInitial(s.fullName);
    final phone = s.parentPhone;
    final hasPhone = phone.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // ---------- Avatar ----------
          Stack(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color.withOpacity(0.15),
                      color.withOpacity(0.06),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  initials,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
              ),
              if (hasPhone)
                Positioned(
                  right: -2,
                  bottom: -2,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF25D366),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: const Icon(Icons.chat_rounded,
                        color: Colors.white, size: 9),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),

          // ---------- Info ----------
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.fullName,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1F36),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    _miniChip(
                      icon: Icons.tag_rounded,
                      text: "Roll ${s.rollNumber}",
                      color: Colors.indigo,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: _miniChip(
                        icon: Icons.class_rounded,
                        text: "Class ${s.studentClass}",
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.phone_rounded,
                      size: 11,
                      color: hasPhone ? Colors.indigo : Colors.grey.shade400,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        hasPhone ? phone : 'No phone',
                        style: TextStyle(
                          fontSize: 11,
                          color: hasPhone
                              ? const Color(0xFF1A1F36)
                              : Colors.grey.shade500,
                          fontWeight: FontWeight.w600,
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

          // ---------- Action buttons ----------
          Row(
            children: [
              _actionBtn(
                icon: Icons.chat_rounded,
                color: const Color(0xFF25D366),
                enabled: hasPhone,
                onTap: hasPhone
                    ? () => _openWhatsApp(
                  phone,
                  s.fatherName.isNotEmpty
                      ? s.fatherName
                      : 'Parent',
                )
                    : null,
              ),
              const SizedBox(width: 8),
              _actionBtn(
                icon: Icons.phone_rounded,
                color: Colors.indigo,
                enabled: hasPhone,
                onTap: hasPhone ? () => _makeCall(phone) : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------- Action button widget ----------
  Widget _actionBtn({
    required IconData icon,
    required Color color,
    required bool enabled,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: enabled ? color : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: enabled ? Colors.white : Colors.grey.shade400,
          size: 16,
        ),
      ),
    );
  }

  // ---------- Mini chip ----------
  Widget _miniChip({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 9, color: color),
          const SizedBox(width: 3),
          Text(
            text,
            style: TextStyle(
              fontSize: 9.5,
              color: color,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.indigo.withOpacity(0.10),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person_search_rounded,
                  size: 40, color: Colors.indigo),
            ),
            const SizedBox(height: 14),
            const Text(
              "No contacts found",
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF1A1F36),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Try changing filters or search",
              style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== ERROR ====================
  Widget _errorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.error_outline_rounded,
                  size: 40, color: Colors.red.shade400),
            ),
            const SizedBox(height: 14),
            Text(
              "Failed to load contacts",
              style: TextStyle(
                fontSize: 14,
                color: Colors.red.shade700,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 14),
            ElevatedButton.icon(
              onPressed: () => controller.refreshStudents(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: const Text(
                'Retry',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}