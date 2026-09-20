// lib/feature/school/attendance/widget/teacher_attendance_shimmer.dart

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class TeacherAttendanceShimmer extends StatelessWidget {
  const TeacherAttendanceShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            // ── Month Header Shimmer ──
            _buildMonthHeaderShimmer(),

            const SizedBox(height: 8),

            // ── Calendar Shimmer ──
            _buildCalendarShimmer(),

            const SizedBox(height: 24),

            // ── Legend Shimmer ──
            _buildLegendShimmer(),

            const SizedBox(height: 28),

            // ── Leave Section Shimmer ──
            _buildLeaveSectionShimmer(),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Month Header Shimmer
  // ─────────────────────────────────────────────
  Widget _buildMonthHeaderShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left arrow
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          // Month text
          Container(
            width: 150,
            height: 26,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          // Right arrow
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Calendar Shimmer (grid of 7 columns x 5 rows)
  // ─────────────────────────────────────────────
  Widget _buildCalendarShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: [
          // ── Weekday Header Row ──
          Row(
            children: List.generate(7, (index) {
              return Expanded(
                child: Center(
                  child: Container(
                    width: 24,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),

          // ── 5 Rows of Day Cells ──
          ...List.generate(5, (rowIndex) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: List.generate(7, (colIndex) {
                  return Expanded(
                    child: Center(
                      child: Container(
                        height: 36,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            );
          }),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Legend Shimmer (6 color dots with labels)
  // ─────────────────────────────────────────────
  Widget _buildLegendShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Wrap(
        spacing: 24,
        runSpacing: 10,
        children: List.generate(6, (index) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Color dot
              Container(
                width: 18,
                height: 18,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              // Label
              Container(
                width: 60,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Leave Section Shimmer
  // ─────────────────────────────────────────────
  Widget _buildLeaveSectionShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Container(
            width: 140,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 12),

          // Leave card
          Container(
            width: double.infinity,
            height: 90,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left text
                Container(
                  width: 200,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                // Apply button
                Container(
                  width: 60,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}