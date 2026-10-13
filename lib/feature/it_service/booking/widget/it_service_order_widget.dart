// lib/screens/dashboard/it_service_order_widget.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/feature/it_service/service/screen/it_service_details_screen.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/widget/flutter_toast.dart';
import '../../service/controller/it_service_controller.dart';
import '../../service/model/it_service_model.dart';

class ItServiceOrderWidget extends StatefulWidget {
  const ItServiceOrderWidget({super.key});

  @override
  State<ItServiceOrderWidget> createState() => _ItServiceOrderWidgetState();
}

class _ItServiceOrderWidgetState extends State<ItServiceOrderWidget> {
  String _selectedFilter = 'All';

  final List<String> _filterOptions = [
    'All',
    'Pending',
    'Confirmed',
    'Completed',
    'Cancelled',
  ];

  final ItServiceController _ctrl = Get.find<ItServiceController>();

  @override
  void initState() {
    super.initState();
    // refresh on open (uses cached value if already loaded)
    Future.microtask(() => _ctrl.fetchBookedServices());
  }

  // ===== Helpers =====
  String _statusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'confirmed':
        return 'Confirmed';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppColors.primary;
      case 'confirmed':
        return AppColors.itServices;
      case 'completed':
        return AppColors.success;
      case 'cancelled':
        return AppColors.textSecondary;
      default:
        return AppColors.textSecondary;
    }
  }

  IconData _statusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.hourglass_top_rounded;
      case 'confirmed':
        return Icons.verified_rounded;
      case 'completed':
        return Icons.check_circle_rounded;
      case 'cancelled':
        return Icons.cancel_rounded;
      default:
        return Icons.info_outline_rounded;
    }
  }

  List<ItServiceData> get _filteredOrders {
    final all = _ctrl.bookedServices;
    if (_selectedFilter == 'All') return all;

    return all.where((s) {
      final status = s.booking?.status ?? 'pending';
      return _statusLabel(status) == _selectedFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = _ctrl.isBookedLoading.value;
      final orders = _filteredOrders;

      return Column(
        children: [
          // ===== FILTER CHIPS =====
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _filterOptions.length,
                itemBuilder: (context, index) {
                  final filter = _filterOptions[index];
                  final isSelected = _selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(
                        filter,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                          color:
                          isSelected ? AppColors.white : AppColors.textMain,
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (_) {
                        setState(() => _selectedFilter = filter);
                      },
                      backgroundColor: AppColors.background,
                      selectedColor: AppColors.itServices,
                      checkmarkColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      visualDensity: VisualDensity.compact,
                    ),
                  );
                },
              ),
            ),
          ),

          // ===== CONTENT =====
          if (isLoading && orders.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 60),
              child: Center(
                child: CircularProgressIndicator(color: AppColors.itServices),
              ),
            )
          else if (orders.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 60),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inbox_rounded,
                      size: 64,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No bookings yet',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _selectedFilter == 'All'
                          ? 'Book a service to see it here'
                          : 'Try changing the filter',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(10),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return _buildOrderCard(orders[index]);
              },
            ),

          SizedBox(height: 100,)
        ],
      );
    });
  }

  // ===== CARD =====
  Widget _buildOrderCard(ItServiceData service) {
    final booking = service.booking;
    final status = booking?.status ?? 'pending';
    final color = _statusColor(status);
    final icon = _statusIcon(status);
    final statusLabel = _statusLabel(status);

    // format date
    final dateLabel = _formatDate(booking?.createdAt ?? '');

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ItServiceDetailsScreen(serviceId: service.id,),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === HEADER ===
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          service.image,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 50,
                            height: 50,
                            color: AppColors.background,
                            child: const Icon(
                              Icons.image_not_supported_rounded,
                              size: 24,
                              color: AppColors.textSecondary,
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
                              '#BK-${booking?.id ?? service.id}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textMain,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              dateLabel,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            if (booking != null &&
                                booking.fullName.isNotEmpty)
                              Text(
                                booking.fullName,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, size: 14, color: color),
                      const SizedBox(width: 4),
                      Text(
                        statusLabel,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const Divider(height: 24, color: AppColors.border),

            // === SERVICE DETAILS ===
            Row(
              children: [
                Expanded(
                  child: Text(
                    service.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textMain,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '₹${service.oldPrice}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ),

            if (service.category != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.category_rounded,
                      size: 12, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    service.category!.name,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],

            const Divider(height: 24, color: AppColors.border),

            // === TOTAL ===
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Amount',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  '₹${service.price}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.itServices,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // === ACTIONS ===
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ItServiceDetailsScreen(serviceId: service.id),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.itServices),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: const Text(
                      'View Details',
                      style: TextStyle(
                        color: AppColors.itServices,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (status == 'pending' || status == 'confirmed')
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _showUnbookDialog(context, service),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.itServices,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.bookmark_remove_rounded,
                              size: 14, color: AppColors.white),
                          SizedBox(width: 4),
                          Text(
                            'Unbook',
                            style: TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String iso) {
    if (iso.isEmpty) return '';
    try {
      final dt = DateTime.parse(iso).toLocal();
      return '${dt.day.toString().padLeft(2, '0')}/'
          '${dt.month.toString().padLeft(2, '0')}/'
          '${dt.year}';
    } catch (_) {
      return iso.split('T').first;
    }
  }

  Future<void> _showUnbookDialog(
      BuildContext context,
      ItServiceData service,
      ) async {
    final bookingId = service.booking?.id;
    if (bookingId == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Unbook Service',
          style: TextStyle(color: AppColors.textMain),
        ),
        content: Text(
          'Are you sure you want to unbook "${service.title}"?',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'No',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Yes, Unbook',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: AppColors.itServices),
      ),
    );

    final ok = await _ctrl.unbookService(service.id);

    if (!context.mounted) return;
    Navigator.pop(context); // close loader

    if (ok) {
      FlutterToast.success('Service unbooked successfully');
    } else {
      final msg = _ctrl.errorMessage.value.isEmpty
          ? 'Failed to unbook service'
          : _ctrl.errorMessage.value;
      FlutterToast.error(msg);
    }
  }
}
