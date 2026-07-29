import 'package:flutter/material.dart';

class EcommerceProductOrderScreen extends StatefulWidget {
  const EcommerceProductOrderScreen({super.key});

  @override
  State<EcommerceProductOrderScreen> createState() => _EcommerceProductOrderScreenState();
}

class _EcommerceProductOrderScreenState extends State<EcommerceProductOrderScreen> {
  String _selectedFilter = 'All';
  int _selectedIndex = 0;

  final List<String> _filterOptions = ['All', 'Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled'];

  final List<Map<String, dynamic>> _orders = [
    {
      'id': '#ORD-001',
      'items': [
        {'name': 'Wireless Headphones', 'quantity': 1, 'price': '\$49.99'},
        {'name': 'Phone Case', 'quantity': 2, 'price': '\$12.99'},
      ],
      'total': '\$75.97',
      'date': '2024-01-15',
      'status': 'Delivered',
      'statusColor': const Color(0xFF10B981),
      'icon': Icons.check_circle_rounded,
      'image': 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=100',
      'tracking': [
        {'label': 'Order Placed', 'time': 'Jan 15, 10:30 AM', 'completed': true},
        {'label': 'Processing', 'time': 'Jan 15, 2:00 PM', 'completed': true},
        {'label': 'Shipped', 'time': 'Jan 16, 9:00 AM', 'completed': true},
        {'label': 'Delivered', 'time': 'Jan 17, 3:30 PM', 'completed': true},
      ],
      'deliveryAddress': '123 Main St, Mumbai, 400001',
      'paymentMethod': 'Credit Card',
    },
    {
      'id': '#ORD-002',
      'items': [
        {'name': 'Smart Watch', 'quantity': 1, 'price': '\$89.99'},
      ],
      'total': '\$89.99',
      'date': '2024-01-14',
      'status': 'Shipped',
      'statusColor': const Color(0xFF3B82F6),
      'icon': Icons.local_shipping_rounded,
      'image': 'https://images.unsplash.com/photo-1546868871-704132a5d082?q=80&w=100',
      'tracking': [
        {'label': 'Order Placed', 'time': 'Jan 14, 11:00 AM', 'completed': true},
        {'label': 'Processing', 'time': 'Jan 14, 3:30 PM', 'completed': true},
        {'label': 'Shipped', 'time': 'Jan 15, 10:00 AM', 'completed': true},
        {'label': 'Delivered', 'time': 'Jan 16, Expected', 'completed': false},
      ],
      'deliveryAddress': '456 Tech Park, Mumbai, 400002',
      'paymentMethod': 'PayPal',
    },
    {
      'id': '#ORD-003',
      'items': [
        {'name': 'Cotton T-Shirt', 'quantity': 3, 'price': '\$19.99'},
        {'name': 'Denim Jeans', 'quantity': 1, 'price': '\$39.99'},
      ],
      'total': '\$99.96',
      'date': '2024-01-13',
      'status': 'Processing',
      'statusColor': const Color(0xFFF59E0B),
      'icon': Icons.hourglass_top_rounded,
      'image': 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?q=80&w=100',
      'tracking': [
        {'label': 'Order Placed', 'time': 'Jan 13, 9:00 AM', 'completed': true},
        {'label': 'Processing', 'time': 'Jan 13, 2:00 PM', 'completed': true},
        {'label': 'Shipped', 'time': 'Jan 14, In Progress', 'completed': false},
        {'label': 'Delivered', 'time': 'Jan 15, Pending', 'completed': false},
      ],
      'deliveryAddress': '789 Fashion St, Mumbai, 400003',
      'paymentMethod': 'Google Pay',
    },
    {
      'id': '#ORD-004',
      'items': [
        {'name': 'Vitamin C Supplement', 'quantity': 2, 'price': '\$12.99'},
        {'name': 'Pain Relief Gel', 'quantity': 1, 'price': '\$8.99'},
      ],
      'total': '\$34.97',
      'date': '2024-01-12',
      'status': 'Pending',
      'statusColor': const Color(0xFFEF4444),
      'icon': Icons.pending_rounded,
      'image': 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?q=80&w=100',
      'tracking': [
        {'label': 'Order Placed', 'time': 'Jan 12, 4:00 PM', 'completed': true},
        {'label': 'Processing', 'time': 'Jan 12, Pending', 'completed': false},
        {'label': 'Shipped', 'time': 'Jan 13, Pending', 'completed': false},
        {'label': 'Delivered', 'time': 'Jan 14, Pending', 'completed': false},
      ],
      'deliveryAddress': '321 Health Ave, Mumbai, 400004',
      'paymentMethod': 'Credit Card',
    },
    {
      'id': '#ORD-005',
      'items': [
        {'name': 'Decorative Wall Clock', 'quantity': 1, 'price': '\$34.99'},
      ],
      'total': '\$34.99',
      'date': '2024-01-11',
      'status': 'Cancelled',
      'statusColor': const Color(0xFF9CA3AF),
      'icon': Icons.cancel_rounded,
      'image': 'https://images.unsplash.com/photo-1563861826100-9cb868fdbe1c?q=80&w=100',
      'tracking': [
        {'label': 'Order Placed', 'time': 'Jan 11, 8:00 AM', 'completed': true},
        {'label': 'Processing', 'time': 'Jan 11, Cancelled', 'completed': false},
        {'label': 'Shipped', 'time': 'Jan 12, Cancelled', 'completed': false},
        {'label': 'Delivered', 'time': 'Jan 13, Cancelled', 'completed': false},
      ],
      'deliveryAddress': '654 Home St, Mumbai, 400005',
      'paymentMethod': 'UPI',
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
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: const Text(
          'My Orders',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // ====== FILTER CHIPS ======
          Container(
            color: Colors.white,
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
                          color: isSelected ? Colors.white : const Color(0xFF333333),
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (_) {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      },
                      backgroundColor: const Color(0xFFF0F0F0),
                      selectedColor: const Color(0xFFE63E3E),
                      checkmarkColor: Colors.white,
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

          // ====== ORDER LIST ======
          Expanded(
            child: _filteredOrders.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox_rounded,
                    size: 64,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No orders found',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Try changing the filter',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[400],
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
            builder: (context) => EcommerceOrderDetailScreen(order: order),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Header
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
                          color: Colors.grey[200],
                          child: const Icon(Icons.image_not_supported_rounded, size: 24, color: Colors.grey),
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
                            color: Color(0xFF333333),
                          ),
                        ),
                        Text(
                          order['date'],
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF999999),
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
            const Divider(height: 24, color: Color(0xFFF0F0F0)),
            // Order Items
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
                            color: Color(0xFF666666),
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
                          color: Color(0xFF333333),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const Divider(height: 16, color: Color(0xFFF0F0F0)),
            // Order Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Amount',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF666666),
                  ),
                ),
                Text(
                  order['total'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE63E3E),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EcommerceOrderDetailScreen(order: order),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFE63E3E)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: const Text(
                      'View Details',
                      style: TextStyle(
                        color: Color(0xFFE63E3E),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (order['status'] == 'Pending' || order['status'] == 'Processing')
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _showCancelDialog(context, order);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE63E3E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                if (order['status'] == 'Delivered')
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Order reviewed successfully!'),
                            backgroundColor: Color(0xFF10B981),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF10B981)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      child: const Text(
                        'Review Order',
                        style: TextStyle(
                          color: Color(0xFF10B981),
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
        title: const Text('Cancel Order'),
        content: Text('Are you sure you want to cancel ${order['id']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Order cancelled successfully!'),
                  backgroundColor: Color(0xFFE63E3E),
                ),
              );
            },
            child: const Text(
              'Yes, Cancel',
              style: TextStyle(color: Color(0xFFE63E3E)),
            ),
          ),
        ],
      ),
    );
  }
}

// ============ ORDER DETAIL SCREEN ============
class EcommerceOrderDetailScreen extends StatefulWidget {
  final Map<String, dynamic> order;

  const EcommerceOrderDetailScreen({super.key, required this.order});

  @override
  State<EcommerceOrderDetailScreen> createState() => _EcommerceOrderDetailScreenState();
}

class _EcommerceOrderDetailScreenState extends State<EcommerceOrderDetailScreen> {
  bool _showTracking = true;

  @override
  Widget build(BuildContext context) {
    final order = widget.order;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(
          'Order ${order['id']}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ====== ORDER STATUS CARD ======
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
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
                            'Order Status',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
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
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Tracking Progress
                  const Text(
                    'Tracking',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
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
                                color: isCompleted ? order['statusColor'] : Colors.grey[300],
                                border: Border.all(
                                  color: isCompleted ? order['statusColor'] : Colors.grey[300]!,
                                  width: 2,
                                ),
                              ),
                              child: isCompleted
                                  ? const Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                                size: 12,
                              )
                                  : null,
                            ),
                            if (!isLast)
                              Container(
                                width: 2,
                                height: 30,
                                color: isCompleted ? order['statusColor'] : Colors.grey[300],
                              ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Padding(
                            padding:  EdgeInsets.only(bottom: isLast ? 0 : 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  track['label'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: isCompleted ? FontWeight.w600 : FontWeight.w400,
                                    color: isCompleted ? const Color(0xFF333333) : const Color(0xFF999999),
                                  ),
                                ),
                                Text(
                                  track['time'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isCompleted ? const Color(0xFF666666) : const Color(0xFFCCCCCC),
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

            // ====== ORDER ITEMS ======
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Order Items',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
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
                                color: Color(0xFF333333),
                              ),
                            ),
                          ),
                          Text(
                            item['price'],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF333333),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const Divider(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Amount',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                      Text(
                        order['total'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE63E3E),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ====== DELIVERY INFORMATION ======
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Delivery Information',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.location_on_rounded, 'Address', order['deliveryAddress']),
                  _buildInfoRow(Icons.payment_rounded, 'Payment Method', order['paymentMethod']),
                  _buildInfoRow(Icons.calendar_today_rounded, 'Order Date', order['date']),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ====== ACTION BUTTONS ======
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFE63E3E)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Back to Orders',
                      style: TextStyle(
                        color: Color(0xFFE63E3E),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                if (order['status'] == 'Pending' || order['status'] == 'Processing')
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _showCancelDialog(context, order);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE63E3E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Cancel Order',
                        style: TextStyle(
                          color: Colors.white,
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
          Icon(icon, size: 18, color: const Color(0xFF666666)),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF666666),
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
        title: const Text('Cancel Order'),
        content: Text('Are you sure you want to cancel ${order['id']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Order cancelled successfully!'),
                  backgroundColor: Color(0xFFE63E3E),
                ),
              );
            },
            child: const Text(
              'Yes, Cancel',
              style: TextStyle(color: Color(0xFFE63E3E)),
            ),
          ),
        ],
      ),
    );
  }
}