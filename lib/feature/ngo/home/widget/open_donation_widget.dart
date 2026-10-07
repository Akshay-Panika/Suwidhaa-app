import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart'; // ✅ shimmer import
import '../../services/controller/ngo_service_controller.dart';
import '../../services/model/ngo_service_model.dart';
import '../../services/screen/donation_details_screen.dart';

class OpenDonationWidget extends StatelessWidget {
  final String headline;
  final Color color;
  const OpenDonationWidget({super.key, required this.headline, required this.color});

  static const Color primaryColor = Colors.teal;

  // ═══════════════════════════════════════════════════════════════
  // CATEGORY → COLOR MAPPING (fallback for card accent)
  // ═══════════════════════════════════════════════════════════════
  Color _colorForCategory(String? name) {
    final lower = (name ?? '').toLowerCase();
    if (lower.contains("education")) return Colors.blue;
    if (lower.contains("health") || lower.contains("medical")) {
      return Colors.red;
    }
    if (lower.contains("environment")) return Colors.green;
    if (lower.contains("animal")) return Colors.orange;
    if (lower.contains("women")) return Colors.purple;
    if (lower.contains("child")) return Colors.pink;
    if (lower.contains("elderly")) return Colors.brown;
    if (lower.contains("water")) return Colors.cyan;
    if (lower.contains("food")) return Colors.orange;
    if (lower.contains("sport")) return Colors.indigo;
    return primaryColor;
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NgoServiceController>();

    return Container(
      color: color,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            headline,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 400,
            child: Obx(() {
              // ── Loading (Shimmer) ──
              if (controller.isLoading.value &&
                  controller.services.isEmpty) {
                return _buildShimmerGrid();
              }

              // ── Empty ──
              if (controller.services.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.volunteer_activism,
                          size: 48, color: Colors.grey[400]),
                      const SizedBox(height: 8),
                      Text(
                        "No open donations right now",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                );
              }

              // ── Loaded ──
              return GridView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.zero,
                itemCount: controller.services.length,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (context, index) {
                  return _buildDonationCard(
                    context,
                    controller.services[index],
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // SHIMMER GRID — same shape as the real card grid
  // ═══════════════════════════════════════════════════════════════
  Widget _buildShimmerGrid() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade50,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemCount: 4, // placeholder count
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.7,
        ),
        itemBuilder: (context, index) => _buildShimmerCard(),
      ),
    );
  }

  Widget _buildShimmerCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: primaryColor.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Image placeholder ──
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(14),
                ),
              ),
            ),
          ),

          // ── Content placeholders ──
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title bar
                Container(
                  width: 90,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 6),

                // Category bar
                Container(
                  width: 60,
                  height: 9,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 10),

                // Progress bar
                Container(
                  width: double.infinity,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),

                // Amount row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 40,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Bottom row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 50,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
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

  // ═══════════════════════════════════════════════════════════════
  // SERVICE CARD (uses NgoServiceData from API)
  // ═══════════════════════════════════════════════════════════════
  Widget _buildDonationCard(BuildContext context, NgoServiceData service) {
    final raised = service.progress.totalAmount;
    final target = service.progress.targetAmount;
    final donor = service.progress.donor;

    final progress = target == 0
        ? 0.0
        : (raised / target).clamp(0.0, 1.0);

    final color = _colorForCategory(service.categoryName);
    final primaryImage =
    service.images.isNotEmpty ? service.images.first : null;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DonationDetailsScreen(serviceId: service.id),
          ),
        );
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: primaryColor.withOpacity(0.15),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image + Badges ──
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(14),
                ),
                child: primaryImage != null
                    ? Image.network(
                  primaryImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  gaplessPlayback: true, // ✅ smooth image swap
                  errorBuilder: (_, __, ___) => Container(
                    color: color.withOpacity(0.1),
                    child: Icon(
                      Icons.image_not_supported,
                      color: color,
                      size: 40,
                    ),
                  ),
                  loadingBuilder:
                      (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: color.withOpacity(0.06),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: color,
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  },
                )
                    : Container(
                  color: color.withOpacity(0.1),
                  child: Icon(
                    Icons.volunteer_activism,
                    color: color,
                    size: 40,
                  ),
                ),
              ),
            ),

            // ── Content ──
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        service.name,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(0.03),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          service.categoryName!,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: color,
                          ),
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey.shade200,
                      color: color,
                      minHeight: 5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "₹${raised.toStringAsFixed(0)}",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      Text(
                        "₹$target",
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${(progress * 100).toStringAsFixed(0)}% funded",
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                      Text(
                        "$donor donors",
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}