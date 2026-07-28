import 'package:flutter/material.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mock Data for Orders/Transactions
  final List<Map<String, dynamic>> orders = [
    {
      'id': 'ORD-2026-8941',
      'title': 'Premium Grocery Combo',
      'category': 'E-Commerce',
      'date': '23 June 2026, 04:30 PM',
      'amount': '₹1,249.00',
      'status': 'Delivered',
      'icon': Icons.shopping_bag_rounded,
      'color': const Color(0xFF6366F1),
    },
    {
      'id': 'SRV-2026-3312',
      'title': 'Home AC Deep Cleaning',
      'category': 'IT & Home Services',
      'date': '21 June 2026, 11:15 AM',
      'amount': '₹599.00',
      'status': 'In Progress',
      'icon': Icons.build_circle_rounded,
      'color': const Color(0xFF0EA5E9),
    },
    {
      'id': 'SCH-2026-0081',
      'title': 'Quarterly Term Fees',
      'category': 'School Portal',
      'date': '15 June 2026, 10:00 AM',
      'amount': '₹12,500.00',
      'status': 'Success',
      'icon': Icons.school_rounded,
      'color': const Color(0xFF10B981),
    },
    {
      'id': 'ORD-2026-7749',
      'title': 'Wireless Gaming Mouse',
      'category': 'E-Commerce',
      'date': '10 June 2026, 08:45 PM',
      'amount': '₹2,499.00',
      'status': 'Cancelled',
      'icon': Icons.shopping_bag_rounded,
      'color': const Color(0xFFF43F5E),
    },
  ];

  @override
  void initState() {
    super.initState(); // Yahan curly brace nahi aayega, sirf semicolon
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color phonePePurple = Color(0xFF5F259F);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Ultra-clean background
      /// 1. Top Custom App Bar
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Orders & History',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded, color: Colors.grey),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.tune_rounded,
              color: Colors.grey,
            ), // Filter option
            onPressed: () {},
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: phonePePurple,
          unselectedLabelColor: Colors.grey,
          indicatorColor: phonePePurple,
          indicatorWeight: 3,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
          tabs: const [
            Tab(text: 'All Orders'),
            Tab(text: 'Ongoing'),
            Tab(text: 'Completed'),
          ],
        ),
      ),

      /// 2. Body Container
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrderList(orders), // All
          _buildOrderList(
            orders.where((o) => o['status'] == 'In Progress').toList(),
          ), // Ongoing
          _buildOrderList(
            orders
                .where(
                  (o) => o['status'] == 'Delivered' || o['status'] == 'Success',
                )
                .toList(),
          ), // Completed
        ],
      ),
    );
  }

  Widget _buildOrderList(List<Map<String, dynamic>> filteredOrders) {
    if (filteredOrders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.layers_clear_rounded, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 12),
            Text(
              'No orders found',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      itemCount: filteredOrders.length,
      itemBuilder: (context, index) {
        final order = filteredOrders[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
            boxShadow: const [
              BoxShadow(
                color: Color(0x06000000),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: InkWell(
            onTap: () {
              // Handle Order Detail View Navigation
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  // Top Row: Icon, Title & Status Badge
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: (order['color'] as Color).withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          order['icon'],
                          color: order['color'],
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order['title'],
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              order['category'],
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildStatusBadge(order['status']),
                    ],
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(color: Color(0xFFF1F5F9), thickness: 1),
                  ),

                  // Bottom Row: Date, ID and Total Amount
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order['id'],
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            order['date'],
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[400],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        order['amount'],
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;

    switch (status) {
      case 'Delivered':
      case 'Success':
        bgColor = const Color(0xFFDCFCE7);
        textColor = const Color(0xFF15803D);
        break;
      case 'In Progress':
        bgColor = const Color(0xFFE0F2FE);
        textColor = const Color(0xFF0369A1);
        break;
      case 'Cancelled':
        bgColor = const Color(0xFFFEE2E2);
        textColor = const Color(0xFFB91C1C);
        break;
      default:
        bgColor = const Color(0xFFF1F5F9);
        textColor = const Color(0xFF475569);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 10,
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
