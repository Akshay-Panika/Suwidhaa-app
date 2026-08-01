// lib/screens/dashboard/it_service_order_screen.dart
import 'package:flutter/material.dart';
import '../../../core/utils/app_color.dart';

class ItServiceOrderScreen extends StatefulWidget {
  const ItServiceOrderScreen({super.key});

  @override
  State<ItServiceOrderScreen> createState() => _ItServiceOrderScreenState();
}

class _ItServiceOrderScreenState extends State<ItServiceOrderScreen> {
  String _selectedFilter = 'All';
  int _selectedIndex = 0;

  final List<String> _filterOptions = [
    'All',
    'In Progress',
    'Completed',
    'On Hold',
    'Cancelled'
  ];

  final List<Map<String, dynamic>> _orders = [
    {
      'id': '#PROJ-001',
      'items': [
        {'name': 'E-Commerce Mobile App', 'quantity': 1, 'price': '₹1,50,000'},
        {'name': 'API Integration', 'quantity': 1, 'price': '₹30,000'},
      ],
      'total': '₹1,80,000',
      'date': '2024-01-15',
      'status': 'Completed',
      'statusColor': AppColors.success,
      'icon': Icons.check_circle_rounded,
      'image': 'https://images.unsplash.com/photo-1551650975-87deedd944c3?q=80&w=100',
      'tracking': [
        {'label': 'Project Initiated', 'time': 'Jan 15, 10:30 AM', 'completed': true},
        {'label': 'Development Phase', 'time': 'Jan 20, 2:00 PM', 'completed': true},
        {'label': 'Testing Phase', 'time': 'Jan 28, 9:00 AM', 'completed': true},
        {'label': 'Delivered', 'time': 'Feb 5, 3:30 PM', 'completed': true},
      ],
      'deliveryAddress': '123 Tech Park, Mumbai, 400001',
      'paymentMethod': 'Credit Card',
      'provider': 'CodeCraft Studios',
    },
    {
      'id': '#PROJ-002',
      'items': [
        {'name': 'Smart Home System', 'quantity': 1, 'price': '₹2,00,000'},
      ],
      'total': '₹2,00,000',
      'date': '2024-01-20',
      'status': 'In Progress',
      'statusColor': AppColors.primary,
      'icon': Icons.hourglass_top_rounded,
      'image': 'https://images.unsplash.com/photo-1485827404703-89b55fcc595e?q=80&w=100',
      'tracking': [
        {'label': 'Project Initiated', 'time': 'Jan 20, 11:00 AM', 'completed': true},
        {'label': 'Design Phase', 'time': 'Jan 25, 3:30 PM', 'completed': true},
        {'label': 'Development Phase', 'time': 'Feb 5, In Progress', 'completed': false},
        {'label': 'Testing Phase', 'time': 'Feb 15, Pending', 'completed': false},
      ],
      'deliveryAddress': '456 IoT Street, Mumbai, 400002',
      'paymentMethod': 'Bank Transfer',
      'provider': 'RoboTech Innovations',
    },
    {
      'id': '#PROJ-003',
      'items': [
        {'name': '3D Adventure Game', 'quantity': 1, 'price': '₹4,00,000'},
        {'name': 'Multiplayer Setup', 'quantity': 1, 'price': '₹1,00,000'},
      ],
      'total': '₹5,00,000',
      'date': '2024-01-25',
      'status': 'On Hold',
      'statusColor': AppColors.school,
      'icon': Icons.pause_circle_rounded,
      'image': 'https://images.unsplash.com/photo-1552820728-8b83bb6b773f?q=80&w=100',
      'tracking': [
        {'label': 'Project Initiated', 'time': 'Jan 25, 9:00 AM', 'completed': true},
        {'label': 'Design Phase', 'time': 'Feb 1, 2:00 PM', 'completed': true},
        {'label': 'Development Phase', 'time': 'Feb 10, On Hold', 'completed': false},
        {'label': 'Testing Phase', 'time': 'Feb 20, Pending', 'completed': false},
      ],
      'deliveryAddress': '789 Game City, Mumbai, 400003',
      'paymentMethod': 'Google Pay',
      'provider': 'GameForge Studios',
    },
    {
      'id': '#PROJ-004',
      'items': [
        {'name': 'Corporate Website', 'quantity': 1, 'price': '₹80,000'},
      ],
      'total': '₹80,000',
      'date': '2024-02-01',
      'status': 'Completed',
      'statusColor': AppColors.success,
      'icon': Icons.check_circle_rounded,
      'image': 'https://images.unsplash.com/photo-1547658719-da2b51169166?q=80&w=100',
      'tracking': [
        {'label': 'Project Initiated', 'time': 'Feb 1, 4:00 PM', 'completed': true},
        {'label': 'Design Phase', 'time': 'Feb 5, Completed', 'completed': true},
        {'label': 'Development Phase', 'time': 'Feb 12, Completed', 'completed': true},
        {'label': 'Delivered', 'time': 'Feb 20, 5:00 PM', 'completed': true},
      ],
      'deliveryAddress': '321 Web Avenue, Mumbai, 400004',
      'paymentMethod': 'Credit Card',
      'provider': 'WebWizards Inc',
    },
    {
      'id': '#PROJ-005',
      'items': [
        {'name': 'SaaS Dashboard', 'quantity': 1, 'price': '₹2,00,000'},
      ],
      'total': '₹2,00,000',
      'date': '2024-02-10',
      'status': 'Cancelled',
      'statusColor': AppColors.textSecondary,
      'icon': Icons.cancel_rounded,
      'image': 'https://images.unsplash.com/photo-1460925895917-afdab827c52f?q=80&w=100',
      'tracking': [
        {'label': 'Project Initiated', 'time': 'Feb 10, 8:00 AM', 'completed': true},
        {'label': 'Design Phase', 'time': 'Feb 15, Cancelled', 'completed': false},
        {'label': 'Development Phase', 'time': 'Feb 20, Cancelled', 'completed': false},
        {'label': 'Delivered', 'time': 'Feb 25, Cancelled', 'completed': false},
      ],
      'deliveryAddress': '654 Web Park, Mumbai, 400005',
      'paymentMethod': 'UPI',
      'provider': 'WebApp Masters',
    },
  ];

  List<Map<String, dynamic>> get _filteredOrders {
    if (_selectedFilter == 'All') {
      return _orders;
    }
    return _orders.where((order) => order['status'] == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        surfaceTintColor: AppColors.white,
        automaticallyImplyLeading: false,
        title: const Text(
          'My Projects',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: AppColors.textMain,
          ),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_rounded, color: AppColors.textMain),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
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
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected ? AppColors.white : AppColors.textMain,
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (_) {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      },
                      backgroundColor: AppColors.background,
                      selectedColor: AppColors.itServices,
                      checkmarkColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      visualDensity: VisualDensity.compact,
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: _filteredOrders.isEmpty
                ? Center(
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
                    'No projects found',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Try changing the filter',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _filteredOrders.length,
              itemBuilder: (context, index) {
                final order = _filteredOrders[index];
                return _buildOrderCard(order);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProjectDetailScreen(order: order),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        order['image'],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 50,
                          height: 50,
                          color: AppColors.background,
                          child: const Icon(Icons.image_not_supported_rounded, size: 24, color: AppColors.textSecondary),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order['id'],
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textMain,
                          ),
                        ),
                        Text(
                          order['date'],
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          order['provider'],
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: order['statusColor'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        order['icon'],
                        size: 14,
                        color: order['statusColor'],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        order['status'],
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: order['statusColor'],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24, color: AppColors.border),
            Column(
              children: (order['items'] as List<Map<String, dynamic>>).map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${item['quantity']}x ${item['name']}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        item['price'],
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textMain,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const Divider(height: 16, color: AppColors.border),
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
                  order['total'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.itServices,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProjectDetailScreen(order: order),
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
                if (order['status'] == 'In Progress' || order['status'] == 'On Hold')
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _showCancelDialog(context, order);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.itServices,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                if (order['status'] == 'Completed')
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Project reviewed successfully!'),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.success),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      child: const Text(
                        'Review Project',
                        style: TextStyle(
                          color: AppColors.success,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
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

  void _showCancelDialog(BuildContext context, Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Project', style: TextStyle(color: AppColors.textMain)),
        content: Text('Are you sure you want to cancel ${order['id']}?', style: const TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Project cancelled successfully!'),
                  backgroundColor: AppColors.itServices,
                ),
              );
            },
            child: const Text(
              'Yes, Cancel',
              style: TextStyle(color: AppColors.itServices),
            ),
          ),
        ],
      ),
    );
  }
}

// Project Detail Screen (included in same file for completeness)
class ProjectDetailScreen extends StatefulWidget {
  final Map<String, dynamic> order;

  const ProjectDetailScreen({super.key, required this.order});

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  bool _showTracking = true;

  @override
  Widget build(BuildContext context) {
    final order = widget.order;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Project ${order['id']}',
          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textMain),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20, color: AppColors.textMain),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded, color: AppColors.textMain),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Project Status',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                order['icon'],
                                color: order['statusColor'],
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                order['status'],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: order['statusColor'],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        order['date'],
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Progress Tracking',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textMain,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...(order['tracking'] as List<Map<String, dynamic>>).asMap().entries.map((entry) {
                    final index = entry.key;
                    final track = entry.value;
                    final isCompleted = track['completed'];
                    final isLast = index == (order['tracking'] as List).length - 1;

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isCompleted ? order['statusColor'] : AppColors.border,
                                border: Border.all(
                                  color: isCompleted ? order['statusColor'] : AppColors.border,
                                  width: 2,
                                ),
                              ),
                              child: isCompleted
                                  ? const Icon(
                                Icons.check_rounded,
                                color: AppColors.white,
                                size: 12,
                              )
                                  : null,
                            ),
                            if (!isLast)
                              Container(
                                width: 2,
                                height: 30,
                                color: isCompleted ? order['statusColor'] : AppColors.border,
                              ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  track['label'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: isCompleted ? FontWeight.w600 : FontWeight.w400,
                                    color: isCompleted ? AppColors.textMain : AppColors.textSecondary,
                                  ),
                                ),
                                Text(
                                  track['time'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isCompleted ? AppColors.textSecondary : AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Project Details',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMain,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...(order['items'] as List<Map<String, dynamic>>).map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '${item['quantity']}x ${item['name']}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textMain,
                              ),
                            ),
                          ),
                          Text(
                            item['price'],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textMain,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const Divider(height: 16, color: AppColors.border),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Amount',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textMain,
                        ),
                      ),
                      Text(
                        order['total'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.itServices,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Project Information',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMain,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.business_rounded, 'Provider', order['provider']),
                  _buildInfoRow(Icons.location_on_rounded, 'Address', order['deliveryAddress']),
                  _buildInfoRow(Icons.payment_rounded, 'Payment Method', order['paymentMethod']),
                  _buildInfoRow(Icons.calendar_today_rounded, 'Start Date', order['date']),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.itServices),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Back to Projects',
                      style: TextStyle(
                        color: AppColors.itServices,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                if (order['status'] == 'In Progress' || order['status'] == 'On Hold')
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _showCancelDialog(context, order);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.itServices,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Cancel Project',
                        style: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textMain,
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext context, Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Project', style: TextStyle(color: AppColors.textMain)),
        content: Text('Are you sure you want to cancel ${order['id']}?', style: const TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Project cancelled successfully!'),
                  backgroundColor: AppColors.itServices,
                ),
              );
            },
            child: const Text(
              'Yes, Cancel',
              style: TextStyle(color: AppColors.itServices),
            ),
          ),
        ],
      ),
    );
  }
}