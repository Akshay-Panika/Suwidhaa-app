// lib/feature/college/screen/college_booking_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/app_color.dart';
import '../../controller/college_booking_controller.dart';
import '../../model/college_booking_model.dart';

class CollegeBookingScreen extends StatefulWidget {
  const CollegeBookingScreen({super.key});

  @override
  State<CollegeBookingScreen> createState() => _CollegeBookingScreenState();
}

class _CollegeBookingScreenState extends State<CollegeBookingScreen> {
  // ✅ Filter state
  String _selectedFilter = 'All';

  final List<String> _filters = ['All', 'College', 'Room', 'Tiffin'];

  @override
  void initState() {
    super.initState();

    final controller = Get.find<CollegeBookingController>();

    // ✅ Fetch on open
    if (controller.bookings.isEmpty && !controller.isBookingsLoading.value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.fetchBookings();
      });
    }
  }

  // ✅ Filtered bookings
  List<CollegeBooking> _filterBookings(List<CollegeBooking> bookings) {
    switch (_selectedFilter) {
      case 'College':
      // Sirf college-only bookings (no room, no tiffin)
        return bookings
            .where((b) => b.room == null && b.tiffin == null)
            .toList();

      case 'Room':
      // Room bookings (with or without tiffin)
        return bookings.where((b) => b.room != null).toList();

      case 'Tiffin':
      // Tiffin bookings (with or without room)
        return bookings.where((b) => b.tiffin != null).toList();

      case 'All':
      default:
        return bookings;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CollegeBookingController>();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Obx(() {
        // 1️⃣ Loading
        if (controller.isBookingsLoading.value && controller.bookings.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        // 2️⃣ Error
        if (controller.bookingsError.isNotEmpty && controller.bookings.isEmpty) {
          return _buildErrorState(controller);
        }

        // 3️⃣ Empty
        if (controller.bookings.isEmpty) {
          return _buildEmptyState();
        }

        // 4️⃣ Filtered list
        final filteredBookings = _filterBookings(controller.bookings);

        return Column(
          children: [
            // ✅ Filter chips
            _buildFilterChips(controller.bookings),

            // ✅ Filtered list
            Expanded(
              child: filteredBookings.isEmpty
                  ? _buildFilterEmptyState()
                  : RefreshIndicator(
                onRefresh: controller.refreshBookings,
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: filteredBookings.length,
                  itemBuilder: (context, index) {
                    final booking = filteredBookings[index];
                    return _buildBookingCard(booking);
                  },
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  // ─────────────────────────────────────────────
  // Filter Chips
  // ─────────────────────────────────────────────
  Widget _buildFilterChips(List<CollegeBooking> allBookings) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: _filters.map((filter) {
          final isSelected = _selectedFilter == filter;

          // ✅ Count nikalo
          final count = _getCountForFilter(filter, allBookings);

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedFilter = filter;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    spacing: 10,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$count',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? Colors.white.withOpacity(0.9)
                              : Colors.grey.shade500,
                        ),
                      ),
                      Text(
                        filter,
                        style: TextStyle(
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Count per filter
  // ─────────────────────────────────────────────
  int _getCountForFilter(String filter, List<CollegeBooking> bookings) {
    switch (filter) {
      case 'College':
        return bookings.where((b) => b.room == null && b.tiffin == null).length;
      case 'Room':
        return bookings.where((b) => b.room != null).length;
      case 'Tiffin':
        return bookings.where((b) => b.tiffin != null).length;
      case 'All':
      default:
        return bookings.length;
    }
  }

  // ─────────────────────────────────────────────
  // Filter Empty State
  // ─────────────────────────────────────────────
  Widget _buildFilterEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.filter_alt_off_rounded,
            size: 60,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          Text(
            "No $_selectedFilter bookings",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Try a different filter",
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Empty State
  // ─────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.book_rounded, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            "No Bookings",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Your bookings will appear here",
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Error State
  // ─────────────────────────────────────────────
  Widget _buildErrorState(CollegeBookingController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline_rounded,
              size: 60, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            controller.bookingsError.value,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => controller.fetchBookings(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Booking Card (same as before)
  // ─────────────────────────────────────────────
  Widget _buildBookingCard(CollegeBooking booking) {
    final bool isRoomBooking = booking.room != null;
    final bool isTiffinBooking = booking.tiffin != null;

    Color typeColor = AppColors.primary;
    IconData typeIcon = Icons.school_rounded;
    String typeLabel = 'College Enquiry';

    if (isRoomBooking && isTiffinBooking) {
      typeColor = Colors.purple;
      typeIcon = Icons.home_work_rounded;
      typeLabel = 'Room + Tiffin';
    } else if (isRoomBooking) {
      typeColor = Colors.blue;
      typeIcon = Icons.bed_rounded;
      typeLabel = 'Room Booking';
    } else if (isTiffinBooking) {
      typeColor = Colors.orange;
      typeIcon = Icons.restaurant_rounded;
      typeLabel = 'Tiffin Enquiry';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 0.4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: typeColor.withOpacity(0.08),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: typeColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(typeIcon, color: typeColor, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        typeLabel,
                        style: TextStyle(
                          fontSize: 14,
                          color: typeColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'College #${booking.collegeId}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: booking.booking
                        ? Colors.green.withOpacity(0.15)
                        : Colors.red.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        booking.booking
                            ? Icons.check_circle_rounded
                            : Icons.cancel_rounded,
                        size: 12,
                        color: booking.booking ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        booking.booking ? 'Booked' : 'Cancelled',
                        style: TextStyle(
                          fontSize: 11,
                          color:
                          booking.booking ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Body
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isRoomBooking) ...[
                  _buildSectionTitle(
                    Icons.bed_rounded,
                    'Room Details',
                    Colors.blue,
                  ),
                  const SizedBox(height: 8),
                  _buildRoomInfo(booking.room!),
                  const SizedBox(height: 14),
                ],
                if (isTiffinBooking) ...[
                  _buildSectionTitle(
                    Icons.restaurant_rounded,
                    'Tiffin Details',
                    Colors.orange,
                  ),
                  const SizedBox(height: 8),
                  _buildTiffinInfo(booking.tiffin!),
                  const SizedBox(height: 14),
                ],
                if (booking.message.isNotEmpty) ...[
                  _buildSectionTitle(
                    Icons.message_rounded,
                    'Message',
                    Colors.grey.shade700,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: Colors.grey.shade200, width: 0.5),
                    ),
                    child: Text(
                      booking.message,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: Colors.grey.shade800,
                        height: 1.5,
                      ),
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 14),
                ],
                const Divider(height: 1),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _buildDateInfo(
                        'Created',
                        booking.createdAt,
                        Colors.grey.shade600,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 30,
                      color: Colors.grey.shade200,
                    ),
                    Expanded(
                      child: _buildDateInfo(
                        'Updated',
                        booking.updatedAt,
                        Colors.grey.shade600,
                      ),
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

  // ─────────────────────────────────────────────
  // Section Title
  // ─────────────────────────────────────────────
  Widget _buildSectionTitle(IconData icon, String title, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: color,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // Room Info
  // ─────────────────────────────────────────────
  Widget _buildRoomInfo(BookingRoom room) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50.withOpacity(0.4),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue.shade100, width: 0.6),
      ),
      child: Column(
        children: [
          _buildInfoRow('Room', room.roomName),
          const SizedBox(height: 6),
          _buildInfoRow('Type', room.roomType),
          const SizedBox(height: 6),
          _buildInfoRow(
            'Amount',
            '₹${room.roomAmount}',
            valueColor: AppColors.primary,
            valueBold: true,
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Tiffin Info
  // ─────────────────────────────────────────────
  Widget _buildTiffinInfo(BookingTiffin tiffin) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade50.withOpacity(0.4),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.orange.shade100, width: 0.6),
      ),
      child: Column(
        children: [
          _buildInfoRow('Tiffin', tiffin.tiffinName),
          const SizedBox(height: 6),
          _buildInfoRow('Type', tiffin.tiffinType),
          const SizedBox(height: 6),
          _buildInfoRow(
            'Amount',
            '₹${tiffin.tiffinAmount}',
            valueColor: AppColors.primary,
            valueBold: true,
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Info Row
  // ─────────────────────────────────────────────
  Widget _buildInfoRow(
      String label,
      String value, {
        Color? valueColor,
        bool valueBold = false,
      }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 65,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Text(':  ',
            style: TextStyle(fontSize: 12, color: Colors.grey)),
        Expanded(
          child: Text(
            value.isEmpty ? 'N/A' : value,
            style: TextStyle(
              fontSize: 12.5,
              color: valueColor ?? Colors.black87,
              fontWeight: valueBold ? FontWeight.w700 : FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // Date Info
  // ─────────────────────────────────────────────
  Widget _buildDateInfo(String label, DateTime date, Color color) {
    final formatted = _formatDate(date);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 3),
        Row(
          children: [
            Icon(Icons.schedule_rounded, size: 12, color: color),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                formatted,
                style: TextStyle(
                  fontSize: 11.5,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // Date Formatter
  // ─────────────────────────────────────────────
  String _formatDate(DateTime date) {
    try {
      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inMinutes < 1) return 'Just now';
      if (diff.inHours < 1) return '${diff.inMinutes}m ago';
      if (diff.inDays < 1) return '${diff.inHours}h ago';
      if (diff.inDays < 7) return '${diff.inDays}d ago';

      return DateFormat('dd MMM yyyy').format(date);
    } catch (e) {
      return date.toString().split(' ')[0];
    }
  }
}