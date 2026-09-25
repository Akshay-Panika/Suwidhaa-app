// lib/feature/school/transport/view/school_student_transport_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/core/widget/contact_helper.dart';
import '../../../../core/widget/flutter_toast.dart';
import '../controller/transport_controller.dart';
import '../model/transport_model.dart';
import 'add_bus_screen.dart';
import 'add_student_screen.dart';

class SchoolStudentTransportScreen extends StatelessWidget {
  const SchoolStudentTransportScreen({super.key});

  // ================= PRIMARY COLOR =================
  static const Color _primary = Colors.indigo;
  static const Color _primaryDark = Color(0xFF283593);
  static const Color _primaryLight = Color(0xFFE8EAF6);

  @override
  Widget build(BuildContext context) {
    final TransportController controller = Get.put(TransportController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.indigo,
        automaticallyImplyLeading: false,
        titleSpacing: 16,
        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.directions_bus,
                size: 24,
                color: Colors.white,
              ),
            ),

            const SizedBox(width: 10),

            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "School Transport",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "Manage Buses & Student",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  onPressed: () {
                    // Notification screen
                  },
                  icon: const Icon(
                    Icons.notifications_none_rounded,
                    color: Colors.white,
                    size: 25,
                  ),
                ),

                Positioned(
                  right: 7,
                  top: 7,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.blue,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ==================== HEADER ====================
          _buildHeader(context, controller),

          // Routes Title
          Container(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _primaryLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.route_rounded,
                      size: 14, color: _primary),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Bus Routes',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),

          // List View
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value &&
                  controller.transportList.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(color: _primary),
                );
              }

              if (controller.filteredTransportList.isEmpty) {
                return _buildEmptyState();
              }

              return RefreshIndicator(
                color: _primary,
                onRefresh: () => controller.refreshTransportList(),
                child: ListView.builder(
                  padding:
                  const EdgeInsets.only(bottom: 100, left: 14, right: 14),
                  itemCount: controller.filteredTransportList.length,
                  itemBuilder: (context, index) {
                    final transport = controller.filteredTransportList[index];
                    return _buildTransportCard(context, transport, controller);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HEADER (with Add Bus + Add Student)
  // ============================================================
  Widget _buildHeader(BuildContext context, TransportController controller) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Transport',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
            ),
          ),
          // Add Bus Button
          _buildHeaderButton(
            icon: Icons.directions_bus,
            label: 'Add Bus',
            color: _primary,
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddBusScreen(),
                ),
              );
              if (result == true) {
                controller.refreshTransportList();
              }
            },
          ),
          const SizedBox(width: 8),
          // Add Student Button
          _buildHeaderButton(
            icon: Icons.person_add_alt_1_rounded,
            label: 'Add Student',
            color: Colors.green.shade700,
            onTap: () {
              if (controller.transportList.isEmpty) {
                FlutterToast.error('Please add a bus first');
                return;
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddStudentScreen(
                    transports: controller.transportList,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.directions_bus_outlined,
                size: 50, color: _primary),
          ),
          const SizedBox(height: 16),
          const Text(
            'No transport routes available',
            style: TextStyle(
              fontSize: 15,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tap "+ Bus" to add a new route',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TRANSPORT CARD
  // ============================================================
  Widget _buildTransportCard(
      BuildContext context,
      TransportModel transport,
      TransportController controller,
      ) {
    String routeName = transport.routeName ??
        '${transport.transportType} - ${transport.vehicleNumber}';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row 1: Route Name + Type + Student Count
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: _primaryLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.directions_bus_rounded,
                          size: 18, color: _primary),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            routeName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            transport.vehicleNumber,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _primaryLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        transport.transportType,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: _primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _buildChip(Icons.directions_bus, transport.vehicleNumber,
                        _primary, true),
                    if (transport.schoolType != null &&
                        transport.schoolType!.isNotEmpty)
                      _buildChip(Icons.school, transport.schoolType!,
                          Colors.teal, false),
                    if (transport.capacity != null &&
                        transport.capacity!.isNotEmpty)
                      _buildChip(Icons.person_outline,
                          'Cap: ${transport.capacity}', Colors.orange, false),
                    if (transport.studentCount > 0)
                      _buildChip(
                        Icons.school_rounded,
                        '${transport.studentCount} students',
                        Colors.green,
                        true,
                      ),
                  ],
                ),
                const SizedBox(height: 12),

                Divider(height: 1, thickness: 1, color: Colors.grey.shade100),
                const SizedBox(height: 12),

                // Row 3: Driver Info + Action Buttons
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _primaryLight,
                        border: Border.all(
                            color: _primary.withOpacity(0.2), width: 1.5),
                      ),
                      child: transport.driverImage != null &&
                          transport.driverImage!.isNotEmpty
                          ? ClipOval(
                        child: Image.network(
                          transport.driverImage!,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                              Icons.person,
                              size: 20,
                              color: _primary),
                        ),
                      )
                          : const Icon(Icons.person,
                          size: 20, color: _primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            transport.driverName,
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Icon(Icons.phone,
                                  size: 11, color: Colors.grey.shade500),
                              const SizedBox(width: 4),
                              Text(
                                transport.driverNumber,
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      spacing: 8,
                      children: [
                        _buildActionButton(
                          icon: Icons.call_rounded,
                          color: Colors.green.shade700,
                          onTap: () => ContactHelper.call(transport.driverNumber),
                          tooltip: 'Call Driver',
                        ),
                        _buildActionButton(
                          icon: Icons.chat_rounded,
                          color: const Color(0xFF25D366),
                          onTap: () => ContactHelper.whatsapp(
                              transport.driverNumber,
                              'Hello, I need assistance with my transport service.'),
                          tooltip: 'WhatsApp',
                        ),
                        _buildActionButton(
                          icon: Icons.arrow_forward_ios_rounded,
                          color: _primary,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  TransportDetailScreen(transport: transport),
                            ),
                          ),
                          tooltip: 'View Details',
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CHIP
  // ============================================================
  Widget _buildChip(IconData icon, String label, Color color, bool bold) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ACTION BUTTON
  // ============================================================
  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
      ),
    );
  }
}

// ============================================================
// TRANSPORT DETAIL SCREEN
// ============================================================
class TransportDetailScreen extends StatelessWidget {
  final TransportModel transport;

  const TransportDetailScreen({super.key, required this.transport});

  static const Color _primary = Colors.indigo;
  static const Color _primaryDark = Color(0xFF283593);
  static const Color _primaryLight = Color(0xFFE8EAF6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: _primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              transport.routeName ?? 'Transport Route',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              'Vehicle: ${transport.vehicleNumber}',
              style: const TextStyle(
                fontSize: 11,
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDriverCard(),
            const SizedBox(height: 20),
            _buildStudentList(transport.students),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        ContactHelper.call(transport.driverNumber),
                    icon: const Icon(Icons.call_rounded, size: 16),
                    label: const Text('Call'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side: BorderSide(color: Colors.green.shade300),
                      foregroundColor: Colors.green.shade700,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => ContactHelper.whatsapp(
                        transport.driverNumber,
                        'Hello, I need assistance with my transport service.'),
                    icon: const Icon(Icons.chat_rounded, size: 16),
                    label: const Text('WhatsApp'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side: const BorderSide(color: Color(0xFF25D366)),
                      foregroundColor: const Color(0xFF25D366),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _primaryLight.withOpacity(0.4),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _primary.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: _primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.person_rounded,
                    color: Colors.white, size: 14),
              ),
              const SizedBox(width: 8),
              const Text(
                'Driver Details',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: _primary, width: 2),
                ),
                child: transport.driverImage != null &&
                    transport.driverImage!.isNotEmpty
                    ? ClipOval(
                  child: Image.network(
                    transport.driverImage!,
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(
                        Icons.person,
                        size: 32,
                        color: _primary),
                  ),
                )
                    : const Icon(Icons.person, size: 32, color: _primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transport.driverName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _driverInfoRow(
                        Icons.phone_rounded, transport.driverNumber),
                    if (transport.capacity != null &&
                        transport.capacity!.isNotEmpty)
                      _driverInfoRow(Icons.person_outline,
                          'Capacity: ${transport.capacity}'),
                    if (transport.schoolType != null &&
                        transport.schoolType!.isNotEmpty)
                      _driverInfoRow(
                          Icons.school_rounded, transport.schoolType!),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _driverInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 13, color: _primary),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12.5,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentList(List<StudentData> students) {
    if (students.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Center(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _primaryLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person_off_outlined,
                    size: 32, color: _primary),
              ),
              const SizedBox(height: 10),
              const Text(
                'No students assigned',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: _primaryLight,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.school_rounded,
                  size: 12, color: _primary),
            ),
            const SizedBox(width: 8),
            Text(
              'Assigned Students (${students.length})',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: students.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            return _buildStudentTile(students[index]);
          },
        ),
      ],
    );
  }

  Widget _buildStudentTile(StudentData student) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
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
                student.studentName.isNotEmpty
                    ? student.studentName[0].toUpperCase()
                    : '?',
                style: const TextStyle(
                  fontSize: 17,
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
                  student.studentName.isNotEmpty
                      ? student.studentName
                      : 'Unknown Student',
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  'ID: ${student.studentId.isNotEmpty ? student.studentId : 'N/A'}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (student.address != null && student.address!.isNotEmpty)
                  Text(
                    'Address: ${student.address}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          if (student.pickupTime != null &&
              student.pickupTime!.isNotEmpty) ...[
            _buildTimeBadge(
              Icons.arrow_upward_rounded,
              student.pickupTime!,
              Colors.green,
            ),
            const SizedBox(width: 6),
          ],
          if (student.dropTime != null &&
              student.dropTime!.isNotEmpty) ...[
            _buildTimeBadge(
              Icons.arrow_downward_rounded,
              student.dropTime!,
              Colors.orange,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimeBadge(IconData icon, String time, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 3),
          Text(
            time,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}