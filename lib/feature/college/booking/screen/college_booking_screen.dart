import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/app_color.dart';
import '../../controller/college_booking_controller.dart';
import '../../model/college_booking_model.dart';


class CollegeBookingScreen extends StatelessWidget {
  const CollegeBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CollegeBookingController>();

    // ✅ Screen open hote hi fetch karo (agar list empty hai)
    if (controller.bookings.isEmpty && !controller.isBookingsLoading.value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.fetchBookings();
      });
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade50,

      body: Obx(() {
        // 1️⃣ Loading
        if (controller.isBookingsLoading.value &&
            controller.bookings.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        // 2️⃣ Error
        if (controller.bookingsError.isNotEmpty &&
            controller.bookings.isEmpty) {
          return _buildErrorState(controller);
        }

        // 3️⃣ Empty
        if (controller.bookings.isEmpty) {
          return _buildEmptyState();
        }

        // 4️⃣ List
        return RefreshIndicator(
          onRefresh: controller.refreshBookings,
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: controller.bookings.length,
            itemBuilder: (context, index) {
              final booking = controller.bookings[index];
              return _buildBookingCard(booking);
            },
          ),
        );
      }),
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
          Icon(
            Icons.book_rounded,
            size: 80,
            color: Colors.grey.shade400,
          ),
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
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
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
          Icon(
            Icons.error_outline_rounded,
            size: 60,
            color: Colors.grey.shade400,
          ),
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
  // Booking Card
  // ─────────────────────────────────────────────
  Widget _buildBookingCard(CollegeBooking booking) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border, width: 0.4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header — college id + status
          Row(
            children: [
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'College #${booking.collegeId}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: booking.booking
                      ? Colors.green.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  booking.bookingStatusText,
                  style: TextStyle(
                    fontSize: 12,
                    color: booking.booking ? Colors.green : Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Message
          Text(
            booking.message,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade800,
              height: 1.5,
            ),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 10),

          // Date
          Row(
            children: [
              Icon(Icons.calendar_today_rounded,
                  size: 14, color: Colors.grey.shade500),
              const SizedBox(width: 6),
              Text(
                booking.formattedDate,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}