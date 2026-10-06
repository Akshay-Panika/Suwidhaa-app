import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
           Text(headline,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 400,
            child: Obx(() {
              // ── Loading ──
              if (controller.isLoading.value && controller.services.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(color: primaryColor),
                );
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
  // SERVICE CARD (uses NgoServiceData from API)
  // ═══════════════════════════════════════════════════════════════
  Widget _buildDonationCard(BuildContext context,NgoServiceData service) {
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
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(14),
                    ),
                    child: primaryImage != null
                        ? Image.network(
                      primaryImage,
                      fit: BoxFit.cover,
                      width: double.infinity,
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

                  // Category badge (top-left)
                  if (service.categoryName != null)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          service.categoryName!,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: color,
                          ),
                        ),
                      ),
                    ),

                  // Donor count badge (top-right, replaces rating)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.people,
                              color: Colors.white, size: 11),
                          const SizedBox(width: 2),
                          Text(
                            "$donor",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Content ──
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  const SizedBox(height: 2),
                  if (service.categoryName != null)
                    Row(
                      children: [
                        Icon(Icons.category_outlined,
                            size: 11, color: Colors.grey[600]),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            service.categoryName!,
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
                        "₹$raised",
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