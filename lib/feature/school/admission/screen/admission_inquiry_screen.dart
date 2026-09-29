// screens/admission_inquiry_screen.dart
import 'package:flutter/material.dart';
import '../model/new_student_model.dart';
import 'admission_inquiry_form_screen.dart';
import 'admission_inquiry_view_screen.dart';

class AdmissionInquiryScreen extends StatefulWidget {
  const AdmissionInquiryScreen({super.key});

  @override
  State<AdmissionInquiryScreen> createState() => _AdmissionInquiryScreenState();
}

class _AdmissionInquiryScreenState extends State<AdmissionInquiryScreen> {
  final List<AdmissionInquiry> _all = [
    AdmissionInquiry(
      id: '1',
      studentName: 'Aarav Sharma',
      parentName: 'Rajesh Sharma',
      phone: '9876543210',
      interestedClass: '10th',
      previousSchool: 'St. Mary School',
      notes: 'Interested in Science stream',
      status: InquiryStatus.interested,
      inquiryDate: DateTime(2026, 1, 10),
    ),
    AdmissionInquiry(
      id: '2',
      studentName: 'Diya Patel',
      parentName: 'Mukesh Patel',
      phone: '9123456780',
      email: 'mukesh@example.com',
      interestedClass: '12th',
      status: InquiryStatus.newInquiry,
      inquiryDate: DateTime(2026, 1, 12),
    ),
  ];

  // ---------- Filters ----------
  String _searchQuery = '';
  String? _filterClass;
  InquiryStatus? _filterStatus;

  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<String> get _availableClasses {
    final set = _all.map((s) => s.interestedClass).toSet().toList();
    set.sort();
    return set;
  }

  List<AdmissionInquiry> get _filtered {
    return _all.where((s) {
      if (_filterClass != null && s.interestedClass != _filterClass) {
        return false;
      }
      if (_filterStatus != null && s.status != _filterStatus) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        return s.studentName.toLowerCase().contains(q) ||
            s.parentName.toLowerCase().contains(q) ||
            s.phone.contains(q) ||
            (s.email?.toLowerCase().contains(q) ?? false);
      }
      return true;
    }).toList();
  }

  bool get _hasActiveFilter =>
      _filterClass != null || _filterStatus != null;

  void _clearFilters() {
    setState(() {
      _filterClass = null;
      _filterStatus = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Admission Inquiries',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, size: 20),
        ),
        actions: [
          InkWell(
            onTap: () async {
              final result = await Navigator.push<AdmissionInquiry>(
                context,
                MaterialPageRoute(
                  builder: (_) => const AdmissionInquiryFormScreen(),
                ),
              );
              if (result != null) setState(() => _all.insert(0, result));
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white,width: 0.3)
              ),
              child: Icon(Icons.add),
            ),
          ),
          SizedBox(width: 20,)
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- Search ----------
            _sectionTitle('Search'),
            const SizedBox(height: 10),
            _searchField(),

            const SizedBox(height: 16),

            // ---------- Filters ----------
            _sectionTitle('Filters'),
            const SizedBox(height: 10),
            _classFilterRow(),
            const SizedBox(height: 10),
            _statusChips(),
            if (_hasActiveFilter) ...[
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: _clearFilters,
                  icon: const Icon(Icons.close_rounded,
                      size: 14, color: Colors.indigo),
                  label: const Text(
                    'Clear Filters',
                    style: TextStyle(
                      color: Colors.indigo,
                      fontWeight: FontWeight.w700,
                      fontSize: 12.5,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 20),

            // ---------- Header ----------
            Row(
              children: [
                _sectionTitle('Inquiries'),
                const SizedBox(width: 6),
                _countBadge(filtered.length),
              ],
            ),
            const SizedBox(height: 12),

            // ---------- List ----------
            if (filtered.isEmpty)
              _noResults()
            else
              ...filtered.map(
                    (i) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _inquiryCard(i),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ==================== SEARCH ====================
  Widget _searchField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        controller: _searchCtrl,
        onChanged: (v) => setState(() => _searchQuery = v),
        style: const TextStyle(fontSize: 13),
        decoration: InputDecoration(
          hintText: 'Search by student, parent, phone or email',
          hintStyle: TextStyle(fontSize: 12.5, color: Colors.grey.shade500),
          prefixIcon: const Icon(Icons.search_rounded,
              size: 18, color: Colors.indigo),
          suffixIcon: _searchQuery.isEmpty
              ? null
              : IconButton(
            icon: const Icon(Icons.close_rounded,
                size: 18, color: Colors.grey),
            onPressed: () {
              _searchCtrl.clear();
              setState(() => _searchQuery = '');
            },
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  // ==================== CLASS FILTER ====================
  Widget _classFilterRow() {
    if (_availableClasses.isEmpty) return const SizedBox.shrink();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _classChip(null, 'All'),
          ..._availableClasses.map((c) => _classChip(c, 'Class $c')),
        ],
      ),
    );
  }

  Widget _classChip(String? value, String label) {
    final selected = _filterClass == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () => setState(() => _filterClass = value),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? Colors.indigo : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? Colors.indigo : Colors.grey.shade300,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: selected ? Colors.white : Colors.indigo,
            ),
          ),
        ),
      ),
    );
  }

  // ==================== STATUS CHIPS ====================
  Widget _statusChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _statusChip(null, 'All'),
          ...InquiryStatus.values.map((s) => _statusChip(s, s.label)),
        ],
      ),
    );
  }

  Widget _statusChip(InquiryStatus? value, String label) {
    final selected = _filterStatus == value;
    final color = value == null
        ? Colors.indigo
        : Color(value.colorValue);
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () => setState(() => _filterStatus = value),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? color : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? color : Colors.grey.shade300,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: selected ? Colors.white : color,
            ),
          ),
        ),
      ),
    );
  }

  // ==================== INQUIRY CARD ====================
  Widget _inquiryCard(AdmissionInquiry i) {
    final statusColor = Color(i.status.colorValue);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () async {
          final result = await Navigator.push<AdmissionInquiry>(
            context,
            MaterialPageRoute(
              builder: (_) => AdmissionInquiryViewScreen(inquiry: i),
            ),
          );
          // If edited in view screen, replace locally
          if (result != null) {
            setState(() {
              final idx = _all.indexWhere((x) => x.id == i.id);
              if (idx >= 0) _all[idx] = result;
            });
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.indigo.withOpacity(0.15),
                          Colors.indigo.withOpacity(0.06),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      i.initials,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.indigo,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Name + parent
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          i.studentName,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Color(0xFF1A1F36),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Parent: ${i.parentName}',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: Color(0xFF6B7280),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Class badge
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.indigo.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      i.interestedClass,
                      style: const TextStyle(
                        color: Colors.indigo,
                        fontWeight: FontWeight.w800,
                        fontSize: 10.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Contact info strip
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.indigo.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.phone_rounded,
                        size: 14, color: Colors.indigo),
                    const SizedBox(width: 4),
                    Text(
                      i.phone,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF1A1F36),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (i.email != null && i.email!.isNotEmpty) ...[
                      const SizedBox(width: 10),
                      const Icon(Icons.email_outlined,
                          size: 13, color: Colors.indigo),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          i.email!,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF1A1F36),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Bottom row: status pill + date
              Row(
                children: [
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      i.status.label.toUpperCase(),
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 9.5,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.calendar_today_rounded,
                      size: 12, color: Color(0xFF6B7280)),
                  const SizedBox(width: 4),
                  Text(
                    i.formattedInquiryDate,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== HELPERS ====================
  Widget _sectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 14,
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

  Widget _countBadge(int count) => Container(
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
  );

  Widget _noResults() => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 40),
    decoration: BoxDecoration(
      color: const Color(0xFFF9FAFC),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.indigo.withOpacity(0.10),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.person_search_rounded,
              size: 28, color: Colors.indigo),
        ),
        const SizedBox(height: 12),
        const Text(
          'No inquiries found',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 13,
            color: Color(0xFF1A1F36),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Try changing filters or add new',
          style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600),
        ),
      ],
    ),
  );
}