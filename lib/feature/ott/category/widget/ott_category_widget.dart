import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../controller/ott_category_controller.dart';

class OttCategoryWidget extends StatelessWidget {
  const OttCategoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OttCategoryController>(
      init: Get.find<OttCategoryController>(),
      autoRemove: false,
      builder: (ctrl) {
        // ── LOADING ──
        if (ctrl.isLoading.value && ctrl.categories.isEmpty) {
          return _buildShimmer();
        }

        // ── ERROR ──
        if (ctrl.errorMessage.value.isNotEmpty && ctrl.categories.isEmpty) {
          return GestureDetector(
            onTap: ctrl.refreshCategories,
            child: const Center(
              child: Text('Retry',
                  style: TextStyle(color: Colors.redAccent, fontSize: 13)),
            ),
          );
        }

        // ── CHIPS ──
        return SizedBox(
          height: 38,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: ctrl.categories.length,
            itemBuilder: (context, index) {
              final cat = ctrl.categories[index];
              final isSelected = ctrl.selectedCategoryId.value == cat.id;

              return GestureDetector(
                onTap: () => ctrl.selectCategory(cat),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOut,
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    // ✅ Selected = solid white, unselected = dark grey
                    color: isSelected ? Colors.white : Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? Colors.white
                          : Colors.white.withOpacity(0.25),
                      width: isSelected ? 1.5 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.18),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ]
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isSelected) ...[
                        const Icon(Icons.check_circle,
                            size: 15, color: Colors.black),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        cat.id == 0 ? 'Home' : cat.name,
                        style: TextStyle(
                          color: isSelected ? Colors.black : Colors.white70,
                          fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildShimmer() {
    final chipWidths = [70.0, 80.0, 65.0, 85.0, 75.0, 90.0];
    return SizedBox(
      height: 38,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: chipWidths.length,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[900]!,
            highlightColor: Colors.grey[700]!,
            child: Container(
              width: chipWidths[index],
              height: 36,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        },
      ),
    );
  }
}