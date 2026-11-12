// ngo_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../auth/controller/auth_controller.dart';
import '../../history/controller/ngo_history_controller.dart';
import '../../history/model/ngo_history_model.dart';

class NgoProfileScreen extends StatelessWidget {
  const NgoProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final historyController = Get.find<NgoHistoryController>();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: RefreshIndicator(
        onRefresh: () => historyController.loadMyHistory(),
        color: Colors.teal,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            // 1. Top Summary Card
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.teal.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  )
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child:
                        Icon(Icons.person, size: 36, color: Colors.teal),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              authController.getUserName,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              authController.getUserPhone,
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _statItem(
                          "₹${historyController.totalDonated.value.toStringAsFixed(0)}",
                          "Total Donated"),
                      _statItem(
                          "${historyController.totalDonations.value}",
                          "Donations"),
                      _statItem(
                          "${historyController.uniqueServices.value}",
                          "Services"),
                    ],
                  )),
                ],
              ),
            ),

            // 2. Filter Chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip(historyController, "Today", "today"),
                    const SizedBox(width: 8),
                    _buildFilterChip(
                        historyController, "This Week", "week"),
                    const SizedBox(width: 8),
                    _buildFilterChip(
                        historyController, "This Month", "month"),
                    const SizedBox(width: 8),
                    _buildFilterChip(historyController, "All", "all"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text("My Donation History",
                  style:
                  TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),

            // 3. Dynamic History List
            Obx(() {
              if (historyController.isLoading.value &&
                  historyController.groupedHistoryList.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 50),
                  child: Center(
                      child: CircularProgressIndicator(color: Colors.teal)),
                );
              }

              if (historyController.groupedHistoryList.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.receipt_long_outlined,
                            size: 50, color: Colors.grey.shade400),
                        const SizedBox(height: 8),
                        const Text("No donations in this period",
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                );
              }

              return Column(
                children: [
                  if (historyController.isLoading.value)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              color: Colors.teal, strokeWidth: 2),
                        ),
                      ),
                    ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: historyController.groupedHistoryList.length,
                    itemBuilder: (context, index) {
                      final item =
                      historyController.groupedHistoryList[index];
                      return _buildGroupedHistoryCard(item);
                    },
                  ),
                ],
              );
            }),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _statItem(String value, String label) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  Widget _buildFilterChip(
      NgoHistoryController controller, String label, String filterKey) {
    final selected = controller.selectedFilter.value == filterKey;
    return GestureDetector(
      onTap: () => controller.applyFilter(filterKey),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Colors.teal : Colors.teal.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border:
          Border.all(color: selected ? Colors.teal : Colors.transparent),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: selected ? FontWeight.bold : FontWeight.w500,
            color: selected ? Colors.white : Colors.teal,
          ),
        ),
      ),
    );
  }

  // ✅ UPDATED: Now uses helper methods from the model
  Widget _buildGroupedHistoryCard(GroupedServiceDonationModel item) {
    final service = item.service;

    // Helper properties se seedha data lein
    final int donationCount = item.myDonationCount;
    final double totalDonated = item.myTotalDonated;
    final List<double> donationAmounts = item.myDonationAmounts;

    final target = service.serviceProgress.targetAmount;
    final raised = service.serviceProgress.totalAmount;
    final ratio = target == 0 ? 0.0 : (raised / target).clamp(0.0, 1.0);

    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300, width: 0.1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header (Image + Name)
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: service.serviceImage.isNotEmpty
                      ? Image.network(service.serviceImage,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _imgFallback())
                      : _imgFallback(),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(service.serviceName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 2),
                      Text(service.categoryName,
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),

            // Donation Details
            if (donationCount > 0) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "You donated: ₹${totalDonated.toStringAsFixed(0)}",
                    style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "$donationCount times", // 👈 Ab sahi count dikhega
                      style: const TextStyle(
                          color: Colors.green,
                          fontSize: 11,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: donationAmounts.map((amount) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Text(
                      "₹${amount.toStringAsFixed(0)}",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 14),
            ],

            // Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                  value: ratio,
                  backgroundColor: Colors.grey.shade200,
                  color: Colors.teal,
                  minHeight: 6),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("₹${raised.toStringAsFixed(0)} raised",
                    style: const TextStyle(
                        fontSize: 11,
                        color: Colors.teal,
                        fontWeight: FontWeight.bold)),
                Text("Target: ₹$target",
                    style: TextStyle(
                        fontSize: 11, color: Colors.grey.shade700)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _imgFallback() {
    return Container(
      width: 60,
      height: 60,
      color: Colors.teal.withOpacity(0.1),
      child: const Icon(Icons.volunteer_activism,
          color: Colors.teal, size: 30),
    );
  }
}