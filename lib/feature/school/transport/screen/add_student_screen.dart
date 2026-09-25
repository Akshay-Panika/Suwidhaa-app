// lib/feature/school/transport/view/add_student_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/widget/flutter_toast.dart';
import '../../student/controller/student_list_controller.dart';
import '../../student/model/student_list_model.dart';
import '../model/transport_model.dart';

class AddStudentScreen extends StatefulWidget {
  final List<TransportModel> transports;

  const AddStudentScreen({super.key, required this.transports});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  static const Color _primary = Colors.indigo;
  static const Color _primaryDark = Color(0xFF283593);
  static const Color _primaryLight = Color(0xFFE8EAF6);

  TransportModel? _selectedTransport;
  StudentListData? _selectedStudent;

  // Timing
  TimeOfDay? _pickupTime;
  TimeOfDay? _dropTime;

  late StudentListController _studentController;

  @override
  void initState() {
    super.initState();

    if (widget.transports.isNotEmpty) {
      _selectedTransport = widget.transports.first;
    }

    _studentController = Get.find<StudentListController>();

    if (_studentController.studentList.isEmpty) {
      _studentController.loadStudentList();
    }
  }

  // ==================== TIME PICKER ====================
  Future<void> _pickTime({required bool isPickup}) async {
    final initial = isPickup
        ? (_pickupTime ?? const TimeOfDay(hour: 7, minute: 30))
        : (_dropTime ?? const TimeOfDay(hour: 15, minute: 0));

    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: _primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isPickup) {
          _pickupTime = picked;
        } else {
          _dropTime = picked;
        }
      });
    }
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return 'Select time';
    final h = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final m = time.minute.toString().padLeft(2, '0');
    final p = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '${h.toString().padLeft(2, '0')}:$m $p';
  }

  // ==================== OPEN TRANSPORT PICKER ====================
  Future<void> _openTransportPicker() async {
    final result = await showModalBottomSheet<TransportModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TransportPickerSheet(
        transports: widget.transports,
        selectedId: _selectedTransport?.id,
      ),
    );

    if (result != null) {
      setState(() => _selectedTransport = result);
    }
  }

  // ==================== OPEN STUDENT PICKER ====================
  Future<void> _openStudentPicker() async {
    final result = await showModalBottomSheet<StudentListData>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StudentPickerSheet(
        studentController: _studentController,
        selectedStudentId: _selectedStudent?.id,
      ),
    );

    if (result != null) {
      setState(() => _selectedStudent = result);
    }
  }

  void _clearStudent() {
    setState(() => _selectedStudent = null);
  }

  // ==================== SAVE ====================
  Future<void> _saveStudent() async {
    if (_selectedTransport == null) {
      FlutterToast.error('Please select a transport');
      return;
    }
    if (_selectedStudent == null) {
      FlutterToast.error('Please select a student');
      return;
    }

    // TODO: Call your API here with:
    // transportId: _selectedTransport!.id
    // studentName: _selectedStudent!.fullName
    // studentId: _selectedStudent!.studentIdCard
    // address: _selectedStudent!.address
    // pickupTime: _formatTime(_pickupTime)
    // dropTime: _formatTime(_dropTime)

    FlutterToast.success('Student added successfully');
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: _primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add Student',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==================== TRANSPORT ====================
            _sectionTitle('Transport'),
            const SizedBox(height: 12),
            _buildTransportSelectorButton(),

            const SizedBox(height: 22),

            // ==================== STUDENT ====================
            Row(
              children: [
                _sectionTitle('Student'),
                const Spacer(),
                if (_selectedStudent != null)
                  TextButton.icon(
                    onPressed: _clearStudent,
                    icon: const Icon(Icons.close_rounded,
                        size: 14, color: Colors.red),
                    label: const Text(
                      'Clear',
                      style: TextStyle(fontSize: 12, color: Colors.red),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            _buildStudentSelectorButton(),

            const SizedBox(height: 22),

            // ==================== TIMING ====================
            _sectionTitle('Timing'),
            const SizedBox(height: 12),
            _buildTimingRow(),

            const SizedBox(height: 24),

            // ==================== SAVE ====================
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saveStudent,
                icon: const Icon(Icons.check_rounded, size: 18),
                label: const Text('Save Student'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }


  Widget _buildTransportSelectorButton() {
    final hasTransport = _selectedTransport != null;
    final hasImage = hasTransport &&
        _selectedTransport!.driverImage != null &&
        _selectedTransport!.driverImage!.isNotEmpty;

    return InkWell(
      onTap: _openTransportPicker,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          color: hasTransport
              ? _primaryLight.withOpacity(0.4)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: hasTransport
                ? _primary.withOpacity(0.4)
                : Colors.grey.shade300,
            width: hasTransport ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // ✅ Driver image or icon
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                gradient: hasImage
                    ? null
                    : (hasTransport
                    ? null
                    : const LinearGradient(
                  colors: [_primary, _primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )),
                color: hasImage
                    ? null
                    : (hasTransport ? _primary.withOpacity(0.15) : null),
                borderRadius: BorderRadius.circular(10),
                border: hasImage
                    ? Border.all(
                    color: _primary.withOpacity(0.3), width: 1.5)
                    : null,
              ),
              child: hasImage
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: Image.network(
                  _selectedTransport!.driverImage!,
                  width: 42,
                  height: 42,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.directions_bus_rounded,
                    size: 20,
                    color: hasTransport
                        ? _primary
                        : Colors.grey.shade600,
                  ),
                ),
              )
                  : Center(
                child: Icon(
                  hasTransport
                      ? Icons.directions_bus_rounded
                      : Icons.add_road_rounded,
                  size: 18,
                  color: hasTransport
                      ? _primary
                      : Colors.grey.shade600,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hasTransport
                        ? (_selectedTransport!.routeName?.isNotEmpty == true
                        ? _selectedTransport!.routeName!
                        : _selectedTransport!.transportType)
                        : 'Tap to select transport',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: hasTransport
                          ? Colors.black87
                          : Colors.grey.shade600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    hasTransport
                        ? 'Vehicle: ${_selectedTransport!.vehicleNumber} • Driver: ${_selectedTransport!.driverName}'
                        : 'Choose from your transport list',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: hasTransport ? _primary : Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildStudentSelectorButton() {
    final hasStudent = _selectedStudent != null;
    return InkWell(
      onTap: _openStudentPicker,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          color: hasStudent
              ? _primaryLight.withOpacity(0.4)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: hasStudent
                ? _primary.withOpacity(0.4)
                : Colors.grey.shade300,
            width: hasStudent ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: hasStudent
                    ? _primary.withOpacity(0.15)
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                hasStudent
                    ? Icons.person_rounded
                    : Icons.person_search_rounded,
                size: 18,
                color: hasStudent ? _primary : Colors.grey.shade600,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hasStudent
                        ? _selectedStudent!.fullName
                        : 'Tap to select student',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: hasStudent
                          ? Colors.black87
                          : Colors.grey.shade600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    hasStudent
                        ? 'Class: ${_selectedStudent!.studentClass} • ID: ${_selectedStudent!.studentIdCard}'
                        : 'Choose from student list',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: hasStudent ? _primary : Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // TIMING ROW
  // ============================================================
  Widget _buildTimingRow() {
    return Row(
      children: [
        Expanded(
          child: _buildTimeSelector(
            label: 'Pickup Time',
            icon: Icons.arrow_upward_rounded,
            color: Colors.green.shade700,
            time: _pickupTime,
            onTap: () => _pickTime(isPickup: true),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildTimeSelector(
            label: 'Drop Time',
            icon: Icons.arrow_downward_rounded,
            color: Colors.orange.shade800,
            time: _dropTime,
            onTap: () => _pickTime(isPickup: false),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSelector({
    required String label,
    required IconData icon,
    required Color color,
    required TimeOfDay? time,
    required VoidCallback onTap,
  }) {
    final isSelected = time != null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.08) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 14, color: color),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatTime(time),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: isSelected ? color : Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================
  Widget _sectionTitle(String text) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: _primaryLight,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(Icons.label_important_rounded,
              size: 12, color: _primary),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}


// ============================================================
// TRANSPORT PICKER BOTTOM SHEET
// ============================================================
class TransportPickerSheet extends StatefulWidget {
  final List<TransportModel> transports;
  final int? selectedId;

  const TransportPickerSheet({
    super.key,
    required this.transports,
    this.selectedId,
  });

  @override
  State<TransportPickerSheet> createState() => _TransportPickerSheetState();
}

class _TransportPickerSheetState extends State<TransportPickerSheet> {
  static const Color _primary = Colors.indigo;
  static const Color _primaryDark = Color(0xFF283593);
  static const Color _primaryLight = Color(0xFFE8EAF6);

  final _searchCtrl = TextEditingController();
  String _searchQuery = '';
  int? _selectedId;

  @override
  void initState() {
    super.initState();
    _selectedId = widget.selectedId;
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<TransportModel> get _filtered {
    if (_searchQuery.isEmpty) return widget.transports;
    final q = _searchQuery.toLowerCase();
    return widget.transports.where((t) {
      return t.vehicleNumber.toLowerCase().contains(q) ||
          t.driverName.toLowerCase().contains(q) ||
          (t.routeName?.toLowerCase().contains(q) ?? false) ||
          t.transportType.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Drag handle
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _primaryLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.directions_bus_rounded,
                          size: 18, color: _primary),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Select Transport',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Choose a bus or van',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded, size: 20),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              // Search
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: (v) => setState(() => _searchQuery = v.trim()),
                  decoration: InputDecoration(
                    hintText: 'Search by vehicle, driver, route...',
                    hintStyle:
                    TextStyle(fontSize: 12, color: Colors.grey.shade500),
                    prefixIcon: Icon(Icons.search_rounded,
                        size: 18, color: _primary),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                      icon: const Icon(Icons.close_rounded, size: 16),
                      onPressed: () {
                        _searchCtrl.clear();
                        setState(() => _searchQuery = '');
                      },
                    )
                        : null,
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                      const BorderSide(color: _primary, width: 1.5),
                    ),
                  ),
                ),
              ),

              // List
              Expanded(child: _buildList(scrollController)),

              // Bottom button
              if (_selectedId != null) _buildBottomButton(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildList(ScrollController scrollController) {
    final list = _filtered;

    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                color: _primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.directions_bus_outlined,
                  size: 30, color: _primary),
            ),
            const SizedBox(height: 10),
            const Text(
              'No transports found',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      itemCount: list.length,
      separatorBuilder: (_, __) => const SizedBox(height: 6),
      itemBuilder: (context, index) {
        final t = list[index];
        final isSelected = _selectedId == t.id;
        return _buildTransportItem(t, isSelected);
      },
    );
  }

  Widget _buildTransportItem(TransportModel transport, bool isSelected) {
    final routeName = transport.routeName?.isNotEmpty == true
        ? transport.routeName!
        : '${transport.transportType} • ${transport.vehicleNumber}';

    final hasImage = transport.driverImage != null &&
        transport.driverImage!.isNotEmpty;

    return InkWell(
      onTap: () => setState(() => _selectedId = transport.id),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? _primaryLight : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? _primary : Colors.grey.shade200,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // ✅ Driver Image / Bus Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: hasImage
                    ? null
                    : const LinearGradient(
                  colors: [_primary, _primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
                border: hasImage
                    ? Border.all(
                    color: _primary.withOpacity(0.3), width: 1.5)
                    : null,
              ),
              child: hasImage
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: Image.network(
                  transport.driverImage!,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: _primary,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (_, __, ___) => const Center(
                    child: Icon(
                      Icons.directions_bus_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              )
                  : const Center(
                child: Icon(
                  Icons.directions_bus_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    routeName,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Icon(Icons.confirmation_number_rounded,
                          size: 10, color: Colors.grey.shade500),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          transport.vehicleNumber,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.person_rounded,
                          size: 10, color: Colors.grey.shade500),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          transport.driverName,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (transport.capacity != null &&
                      transport.capacity!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        'Capacity: ${transport.capacity}',
                        style: TextStyle(
                          fontSize: 10.5,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Check
            if (isSelected)
              const Icon(Icons.check_circle_rounded,
                  size: 22, color: _primary)
            else
              Icon(Icons.radio_button_unchecked,
                  size: 22, color: Colors.grey.shade300),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {
            final transport =
            widget.transports.firstWhere((t) => t.id == _selectedId);
            Navigator.pop(context, transport);
          },
          icon: const Icon(Icons.check_rounded, size: 18),
          label: const Text('Confirm Selection'),
          style: ElevatedButton.styleFrom(
            backgroundColor: _primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}


// ============================================================
// STUDENT PICKER BOTTOM SHEET
// ============================================================
class StudentPickerSheet extends StatefulWidget {
  final StudentListController studentController;
  final int? selectedStudentId;

  const StudentPickerSheet({
    super.key,
    required this.studentController,
    this.selectedStudentId,
  });

  @override
  State<StudentPickerSheet> createState() => _StudentPickerSheetState();
}

class _StudentPickerSheetState extends State<StudentPickerSheet> {
  static const Color _primary = Colors.indigo;
  static const Color _primaryDark = Color(0xFF283593);
  static const Color _primaryLight = Color(0xFFE8EAF6);

  final _searchCtrl = TextEditingController();

  String? _selectedClass;
  String? _selectedSchoolType;
  String _searchQuery = '';

  int? _selectedId;

  @override
  void initState() {
    super.initState();
    _selectedId = widget.selectedStudentId;
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  // ==================== FILTERS ====================
  List<String> get _schoolTypes {
    return widget.studentController.studentList
        .map((s) => s.schoolType)
        .where((t) => t.isNotEmpty)
        .toSet()
        .toList()
      ..sort();
  }

  List<String> get _classes {
    final list = widget.studentController.studentList.where((s) {
      if (_selectedSchoolType != null && _selectedSchoolType!.isNotEmpty) {
        return s.schoolType == _selectedSchoolType;
      }
      return true;
    });
    return list
        .map((s) => s.studentClass)
        .where((c) => c.isNotEmpty)
        .toSet()
        .toList()
      ..sort();
  }

  List<StudentListData> get _filteredStudents {
    var list = widget.studentController.studentList.toList();

    if (_selectedSchoolType != null && _selectedSchoolType!.isNotEmpty) {
      list = list.where((s) => s.schoolType == _selectedSchoolType).toList();
    }
    if (_selectedClass != null && _selectedClass!.isNotEmpty) {
      list = list.where((s) => s.studentClass == _selectedClass).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((s) {
        return s.fullName.toLowerCase().contains(q) ||
            s.studentIdCard.toLowerCase().contains(q) ||
            s.rollNumber.toLowerCase().contains(q) ||
            s.parentPhone.toLowerCase().contains(q);
      }).toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Drag handle
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _primaryLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.person_search_rounded,
                          size: 18, color: _primary),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Select Student',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Filter and choose a student',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded, size: 20),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              Expanded(
                child: Obx(() {
                  final _ = widget.studentController.studentList.length;
                  final loading = widget.studentController.isLoading.value;

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                        child: _buildFiltersRow(),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                        child: _buildSearchField(),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: loading &&
                            widget.studentController.studentList.isEmpty
                            ? const Center(
                          child: SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: _primary),
                          ),
                        )
                            : _buildList(scrollController),
                      ),
                    ],
                  );
                }),
              ),

              if (_selectedId != null) _buildBottomButton(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFiltersRow() {
    final classes = _classes;
    final schoolTypes = _schoolTypes;

    return Row(
      spacing: 10,
      children: [
        Expanded(
          child: _buildSmallDropdown<String>(
            value: _selectedSchoolType,
            hint: 'Type',
            icon: Icons.school_rounded,
            items: [
              const DropdownMenuItem<String>(
                value: null,
                child: Text('All Types', style: TextStyle(fontSize: 12)),
              ),
              ...schoolTypes.map((t) => DropdownMenuItem<String>(
                value: t,
                child: Text(t,
                    style: const TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis),
              )),
            ],
            onChanged: (v) {
              setState(() {
                _selectedSchoolType = v;
                _selectedClass = null;
              });
            },
          ),
        ),
        Expanded(
          child: _buildSmallDropdown<String>(
            value: _selectedClass,
            hint: 'Class',
            icon: Icons.class_rounded,
            items: [
              const DropdownMenuItem<String>(
                value: null,
                child: Text('All Classes', style: TextStyle(fontSize: 12)),
              ),
              ...classes.map((c) => DropdownMenuItem<String>(
                value: c,
                child: Text(c,
                    style: const TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis),
              )),
            ],
            onChanged: (v) => setState(() => _selectedClass = v),
          ),
        ),
      ],
    );
  }

  Widget _buildSmallDropdown<T>({
    required T? value,
    required String hint,
    required IconData icon,
    required List<DropdownMenuItem<T>> items,
    required Function(T?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          hint: Row(
            children: [
              Icon(icon, size: 14, color: _primary),
              const SizedBox(width: 6),
              Text(hint, style: const TextStyle(fontSize: 12)),
            ],
          ),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchCtrl,
      onChanged: (v) => setState(() => _searchQuery = v.trim()),
      decoration: InputDecoration(
        hintText: 'Search by name, ID, roll no, phone...',
        hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade500),
        prefixIcon: Icon(Icons.search_rounded, size: 18, color: _primary),
        suffixIcon: _searchQuery.isNotEmpty
            ? IconButton(
          icon: const Icon(Icons.close_rounded, size: 16),
          onPressed: () {
            _searchCtrl.clear();
            setState(() => _searchQuery = '');
          },
        )
            : null,
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primary, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildList(ScrollController scrollController) {
    final students = _filteredStudents;

    if (students.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                color: _primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person_search_rounded,
                  size: 30, color: _primary),
            ),
            const SizedBox(height: 10),
            const Text(
              'No students found',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              _searchQuery.isNotEmpty
                  ? 'Try a different search'
                  : 'No students in this filter',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      itemCount: students.length,
      separatorBuilder: (_, __) => const SizedBox(height: 6),
      itemBuilder: (context, index) {
        final s = students[index];
        final isSelected = _selectedId == s.id;
        return _buildStudentItem(s, isSelected);
      },
    );
  }

  Widget _buildStudentItem(StudentListData student, bool isSelected) {
    return InkWell(
      onTap: () => setState(() => _selectedId = student.id),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? _primaryLight : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? _primary : Colors.grey.shade200,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [_primary, _primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  student.displayName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student.fullName.isNotEmpty
                        ? student.fullName
                        : 'Unknown',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    [
                      if (student.studentIdCard.isNotEmpty)
                        'ID: ${student.studentIdCard}',
                      if (student.studentClass.isNotEmpty)
                        'Class: ${student.studentClass}',
                    ].join(' • '),
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle_rounded,
                  size: 22, color: _primary)
            else
              Icon(Icons.radio_button_unchecked,
                  size: 22, color: Colors.grey.shade300),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {
            final student = widget.studentController.studentList
                .firstWhere((s) => s.id == _selectedId);
            Navigator.pop(context, student);
          },
          icon: const Icon(Icons.check_rounded, size: 18),
          label: const Text('Confirm Selection'),
          style: ElevatedButton.styleFrom(
            backgroundColor: _primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}