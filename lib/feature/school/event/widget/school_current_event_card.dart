import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/school_event_controller.dart';
import '../model/school_event_model.dart';
import '../screen/school_event_details_screen.dart';

class SchoolCurrentEventCard extends StatelessWidget {
  const SchoolCurrentEventCard({super.key});

  // ==================== HELPERS ====================
  Color _categoryColor(String c) {
    switch (c) {
      case "Sports": return Colors.green;
      case "Cultural": return Colors.purple;
      case "Academic": return Colors.blue;
      case "Holiday": return Colors.teal;
      case "Meeting": return Colors.orange;
      default: return Colors.grey;
    }
  }

  IconData _categoryIcon(String c) {
    switch (c) {
      case "Sports": return Icons.sports_soccer_rounded;
      case "Cultural": return Icons.theater_comedy_rounded;
      case "Academic": return Icons.school_rounded;
      case "Holiday": return Icons.beach_access_rounded;
      case "Meeting": return Icons.groups_rounded;
      default: return Icons.event_rounded;
    }
  }

  Color _statusColor(String s) {
    switch (s) {
      case "Upcoming": return Colors.blue;
      case "Ongoing": return Colors.green;
      case "Completed": return Colors.grey;
      case "Cancelled": return Colors.red;
      default: return Colors.grey;
    }
  }

  DateTime? _parseCreatedAt(String s) {
    if (s.trim().isEmpty) return null;
    try {
      return DateTime.parse(s);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<SchoolEventController>();

    return Obx(() {
      // 🔑 Pick the FIRST pinned event from the list (same as NoticePinedCard)
      final pinnedList = ctrl.events.where((e) => e.isPinned).toList();
      if (pinnedList.isEmpty) return const SizedBox.shrink();

      // Sort by newest first (in case multiple pinned)
      pinnedList.sort((a, b) {
        final da = _parseCreatedAt(a.createdAt);
        final db = _parseCreatedAt(b.createdAt);
        if (da != null && db != null) return db.compareTo(da);
        if (da != null) return -1;
        if (db != null) return 1;
        return b.id.compareTo(a.id);
      });

      final e = pinnedList.first;

      final cc = _categoryColor(e.category);
      final sc = _statusColor(e.status);

      return Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          border: Border.all(color: Colors.indigo, width: 0.3),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // ==================== HEADER ====================
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: cc.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.event_available_rounded,
                      color: cc,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 🔑 Main header — category + class/audience
                        Text(
                          "Current Event • ${e.category}",
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        // 🔑 Sub header — date range + status
                        Text(
                          e.isMultiDay
                              ? "${e.startDate} → ${e.endDate} • ${e.status}"
                              : "${e.startDate} • ${e.status}",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // Pin indicator (badge)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.push_pin_rounded,
                        size: 13, color: Colors.orange),
                  ),
                ],
              ),
            ),

            // ==================== CARD ====================
            Card(
              elevation: 0,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              color: Colors.grey.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Get.to(() => SchoolEventDetailsScreen(event: e));
                  ctrl.fetchEvents(silent: true);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Banner
                    if (e.hasBanner)
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12)),
                        child: Image.network(
                          e.bannerUrl!,
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          loadingBuilder: (_, child, progress) {
                            if (progress == null) return child;
                            return Container(
                              height: 120,
                              color: Colors.grey.shade100,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          },
                          errorBuilder: (_, __, ___) => Container(
                            height: 120,
                            color: cc.withOpacity(0.15),
                            child: Center(
                              child: Icon(_categoryIcon(e.category),
                                  size: 40, color: cc),
                            ),
                          ),
                        ),
                      )
                    else
                      Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: cc.withOpacity(0.08),
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12)),
                        ),
                        child: Center(
                          child: Icon(_categoryIcon(e.category),
                              size: 28, color: cc),
                        ),
                      ),

                    // Body
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ====== TOP ROW: PIN + PRIORITY + STATUS ======
                          Row(
                            children: [
                              // Pinned badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.push_pin_rounded,
                                        size: 11, color: Colors.orange),
                                    SizedBox(width: 4),
                                    Text(
                                      "PINNED",
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.orange,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              // Status chip
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: sc.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  e.status,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: sc,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          // ====== TITLE ======
                          Text(
                            e.title,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                          const SizedBox(height: 4),

                          // ====== DESCRIPTION ======
                          Text(
                            e.description,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                              height: 1.4,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                          const SizedBox(height: 10),

                          // ====== TIME + VENUE ======
                          Row(
                            children: [
                              const Icon(Icons.access_time_rounded,
                                  size: 12, color: Colors.indigo),
                              const SizedBox(width: 4),
                              Text(
                                "${e.startTime} - ${e.endTime}",
                                style: TextStyle(
                                    fontSize: 11, color: Colors.grey[700]),
                              ),
                              const SizedBox(width: 10),
                              const Icon(Icons.location_on_rounded,
                                  size: 12, color: Colors.redAccent),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  e.venue,
                                  style: TextStyle(
                                      fontSize: 11, color: Colors.grey[700]),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          // ====== BOTTOM ROW: TAGS + DATE ======
                          Row(
                            children: [
                              _tag(e.category, cc,
                                  icon: _categoryIcon(e.category)),
                              const SizedBox(width: 6),
                              _tag(e.audience, Colors.indigo,
                                  icon: Icons.groups_rounded),
                              if (e.hasBanner) ...[
                                const SizedBox(width: 6),
                                _tag(
                                  "Banner",
                                  Colors.blue,
                                  icon: Icons.image_rounded,
                                ),
                              ],
                              const Spacer(),
                              Text(
                                e.displayDate,
                                style: TextStyle(
                                    fontSize: 10, color: Colors.grey[500]),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      );
    });
  }

  Widget _tag(String text, Color color, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 10, color: color),
            const SizedBox(width: 3),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: 9.5,
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}