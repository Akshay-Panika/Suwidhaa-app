import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../auth/controller/auth_controller.dart';
import '../../services/controller/ngo_history_controller.dart';
import '../../services/controller/ngo_service_controller.dart';
import '../../services/model/ngo_history_model.dart';
import '../../services/model/ngo_service_model.dart';

class NgoProfileScreen extends StatefulWidget {
  const NgoProfileScreen({super.key});

  @override
  State<NgoProfileScreen> createState() => _NgoProfileScreenState();
}

class _NgoProfileScreenState extends State<NgoProfileScreen> {
  final AuthController authController = Get.find<AuthController>();
  final NgoHistoryController historyController =
  Get.find<NgoHistoryController>();
  final NgoServiceController serviceController =
  Get.find<NgoServiceController>();

  /// 🗺️ serviceId → full NgoServiceData (already fetched)
  final Map<int, NgoServiceData> _serviceCache = {};

  /// Track which service IDs we're currently fetching (avoid duplicate calls)
  final Set<int> _fetching = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      historyController.loadMyHistory().then((_) {
        _fetchServiceDetails();
      });
    });
  }

  /// 🔥 Fetch full service data for each unique service_id in history
  Future<void> _fetchServiceDetails() async {
    final ids = historyController.historyList
        .map((h) => h.service)
        .where((id) => id != null)
        .cast<int>()
        .toSet();

    for (final id in ids) {
      if (_serviceCache.containsKey(id) || _fetching.contains(id)) continue;

      _fetching.add(id);
      try {
        final service = await serviceController.fetchServiceById(id);
        if (service != null && mounted) {
          setState(() {
            _serviceCache[id] = service;
          });
        }
      } catch (_) {
        // silent — fallback to snapshot data
      } finally {
        _fetching.remove(id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final filtered = historyController.historyList;

      // Refresh service cache when history changes
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fetchServiceDetails();
      });

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal.shade400, Colors.teal.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.teal.withOpacity(0.25),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  spacing: 10,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        image: const DecorationImage(
                          image: NetworkImage(
                            "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          authController.getUserName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.location_on,
                                  color: Colors.white, size: 12),
                              const SizedBox(width: 4),
                              Text(
                                "Singrauli, MP",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.95),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  height: 1,
                  color: Colors.white.withOpacity(0.2),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatItem(
                      "₹${historyController.totalDonated.value.toStringAsFixed(0)}",
                      "Donated",
                      Icons.volunteer_activism,
                    ),
                    _verticalDivider(),
                    _buildStatItem(
                      "${historyController.totalDonations.value}",
                      "Donations",
                      Icons.campaign_outlined,
                    ),
                    _verticalDivider(),
                    _buildStatItem(
                      "${historyController.uniqueServices.value}",
                      "Services",
                      Icons.workspace_premium_outlined,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Card(
              elevation: 0.3,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Recent Donations",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "${filtered.length} items",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Total: ₹${historyController.totalDonated.value.toStringAsFixed(0)}",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Filter chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip("Today", "today"),
                          const SizedBox(width: 8),
                          _buildFilterChip("This Week", "week"),
                          const SizedBox(width: 8),
                          _buildFilterChip("This Month", "month"),
                          const SizedBox(width: 8),
                          _buildFilterChip("All", "all"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // List / loading / empty
                    if (historyController.isLoading.value)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.teal,
                          ),
                        ),
                      )
                    else if (filtered.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.receipt_long_outlined,
                                size: 48,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "No donations in this period",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            return _buildRecentDonation(filtered[index]);
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      );
    });
  }

  // ═══════════════════════════════════════════════════════════════
  // RECENT DONATION CARD (with image + progress from service detail)
  // ═══════════════════════════════════════════════════════════════
  Widget _buildRecentDonation(NgoHistoryModel item) {
    // ✅ service_id se cached full data
    final service = item.service != null ? _serviceCache[item.service!] : null;

    // Image — prefer live service, fallback to history snapshot
    final imageUrl = (service?.images.isNotEmpty == true)
        ? service!.images.first
        : item.serviceImage;

    // Progress — prefer live service, fallback to history snapshot
    final target = service?.progress.targetAmount ??
        item.serviceProgress?.targetAmount ??
        0;
    final total = service?.progress.totalAmount ??
        item.serviceProgress?.totalAmount ??
        0.0;
    final donor = service?.progress.donor ??
        item.serviceProgress?.donor ??
        0;

    final ratio = target == 0 ? 0.0 : (total / target).clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.teal, width: 0.3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Row: thumbnail + info + amount ───
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🖼️ Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 56,
                  height: 56,
                  child: (imageUrl ?? '').isNotEmpty
                      ? Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _thumbFallback(),
                    loadingBuilder: (context, child, p) {
                      if (p == null) return child;
                      return Container(
                        color: Colors.teal.withOpacity(0.08),
                        child: const Center(
                          child: SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.teal,
                            ),
                          ),
                        ),
                      );
                    },
                  )
                      : _thumbFallback(),
                ),
              ),
              const SizedBox(width: 10),

              // 📝 Name + category + time
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service?.name ?? item.serviceName ?? "Donation",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    if ((service?.categoryName ?? item.categoryName ?? '')
                        .isNotEmpty)
                      Text(
                        service?.categoryName ?? item.categoryName!,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.schedule,
                            size: 11, color: Colors.grey[500]),
                        const SizedBox(width: 3),
                        Text(
                          _formatDate(item.createdAt),
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 💰 Your donation
              const SizedBox(width: 8),
              Text(
                "₹${item.donateAmount.toStringAsFixed(0)}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),

          // ─── Progress bar (target vs raised) ───
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: ratio,
              backgroundColor: Colors.grey.shade200,
              color: Colors.teal,
              minHeight: 5,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "₹${total.toStringAsFixed(0)} raised",
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.teal,
                ),
              ),
              Text(
                "Target: ₹$target",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$donor donors",
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                "${(ratio * 100).toStringAsFixed(0)}% funded",
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.teal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _thumbFallback() {
    return Container(
      color: Colors.teal.withOpacity(0.1),
      alignment: Alignment.center,
      child: const Icon(
        Icons.volunteer_activism,
        color: Colors.teal,
        size: 24,
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // HELPERS
  // ═══════════════════════════════════════════════════════════════

  Widget _verticalDivider() {
    return Container(
      width: 1,
      height: 36,
      color: Colors.white.withOpacity(0.2),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.9), size: 18),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.75),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, String filterKey) {
    final selected = historyController.selectedFilter.value == filterKey;
    return GestureDetector(
      onTap: () => historyController.applyFilter(filterKey),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Colors.teal : Colors.teal.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? Colors.teal : Colors.transparent,
            width: 1.2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.bold : FontWeight.w500,
            color: selected ? Colors.white : Colors.teal,
          ),
        ),
      ),
    );
  }

  String _formatDate(String isoDate) {
    if (isoDate.isEmpty) return "";
    try {
      final dt = DateTime.parse(isoDate).toLocal();
      final now = DateTime.now();
      final diff = now.difference(dt);

      if (diff.inMinutes < 1) return "Just now";
      if (diff.inMinutes < 60) return "${diff.inMinutes} min ago";
      if (diff.inHours < 24) return "${diff.inHours} hrs ago";
      if (diff.inDays < 30) return "${diff.inDays} days ago";
      return "${dt.day}/${dt.month}/${dt.year}";
    } catch (_) {
      return "";
    }
  }
}