import 'package:flutter/material.dart';
import '../../../../core/utils/app_color.dart';

class TransportScreen extends StatefulWidget {
  const TransportScreen({super.key});

  @override
  State<TransportScreen> createState() => _TransportScreenState();
}

class _TransportScreenState extends State<TransportScreen> {
  int selectedIndex = 0;
  String _selectedFilter = 'All';

  final List<Map<String, dynamic>> buses = [
    {
      'id': 'BUS-001',
      'name': 'Bus A - Red',
      'route': 'Route 1: City Center → School',
      'driver': 'Mr. Rajesh Kumar',
      'driverContact': '+91 98765 43001',
      'totalSeats': 40,
      'occupiedSeats': 36,
      'availableSeats': 4,
      'status': 'Running',
      'speed': '45 km/h',
      'location': 'Near City Mall',
      'eta': '10 min',
      'lastUpdate': '2 min ago',
      'color': Colors.red,
      'icon': Icons.directions_bus,
    },
    {
      'id': 'BUS-002',
      'name': 'Bus B - Blue',
      'route': 'Route 2: Railway Station → School',
      'driver': 'Mrs. Priya Sharma',
      'driverContact': '+91 98765 43002',
      'totalSeats': 45,
      'occupiedSeats': 38,
      'availableSeats': 7,
      'status': 'Running',
      'speed': '50 km/h',
      'location': 'Railway Station Area',
      'eta': '15 min',
      'lastUpdate': '1 min ago',
      'color': Colors.blue,
      'icon': Icons.directions_bus,
    },
    {
      'id': 'BUS-003',
      'name': 'Bus C - Green',
      'route': 'Route 3: Bus Stand → School',
      'driver': 'Mr. Suresh Singh',
      'driverContact': '+91 98765 43003',
      'totalSeats': 35,
      'occupiedSeats': 30,
      'availableSeats': 5,
      'status': 'Running',
      'speed': '40 km/h',
      'location': 'Bus Stand',
      'eta': '20 min',
      'lastUpdate': '3 min ago',
      'color': Colors.green,
      'icon': Icons.directions_bus,
    },
    {
      'id': 'BUS-004',
      'name': 'Bus D - Yellow',
      'route': 'Route 4: Market Road → School',
      'driver': 'Mr. Amit Verma',
      'driverContact': '+91 98765 43004',
      'totalSeats': 50,
      'occupiedSeats': 42,
      'availableSeats': 8,
      'status': 'Running',
      'speed': '48 km/h',
      'location': 'Market Road',
      'eta': '12 min',
      'lastUpdate': '4 min ago',
      'color': Colors.orange,
      'icon': Icons.directions_bus,
    },
    {
      'id': 'BUS-005',
      'name': 'Bus E - White',
      'route': 'Route 5: Hospital Road → School',
      'driver': 'Mrs. Meera Gupta',
      'driverContact': '+91 98765 43005',
      'totalSeats': 30,
      'occupiedSeats': 28,
      'availableSeats': 2,
      'status': 'Running',
      'speed': '42 km/h',
      'location': 'Hospital Road',
      'eta': '18 min',
      'lastUpdate': '2 min ago',
      'color': Colors.grey,
      'icon': Icons.directions_bus,
    },
    {
      'id': 'BUS-006',
      'name': 'Winger - Silver',
      'route': 'Route 6: Colony A → School',
      'driver': 'Mr. Ravi Patel',
      'driverContact': '+91 98765 43006',
      'totalSeats': 15,
      'occupiedSeats': 12,
      'availableSeats': 3,
      'status': 'Running',
      'speed': '55 km/h',
      'location': 'Colony A',
      'eta': '8 min',
      'lastUpdate': '1 min ago',
      'color': Colors.cyan,
      'icon': Icons.airport_shuttle,
    },
    {
      'id': 'BUS-007',
      'name': 'Van - Blue',
      'route': 'Route 7: Township → School',
      'driver': 'Mr. Ramesh Singh',
      'driverContact': '+91 98765 43007',
      'totalSeats': 10,
      'occupiedSeats': 8,
      'availableSeats': 2,
      'status': 'Off',
      'speed': '0 km/h',
      'location': 'Garage',
      'eta': 'Under Maintenance',
      'lastUpdate': '30 min ago',
      'color': Colors.purple,
      'icon': Icons.local_shipping,
    },
    {
      'id': 'BUS-008',
      'name': 'Mini Bus - Orange',
      'route': 'Route 8: Village Road → School',
      'driver': 'Mr. Sanjay Kumar',
      'driverContact': '+91 98765 43008',
      'totalSeats': 20,
      'occupiedSeats': 18,
      'availableSeats': 2,
      'status': 'Off',
      'speed': '0 km/h',
      'location': 'Workshop',
      'eta': 'Under Maintenance',
      'lastUpdate': '45 min ago',
      'color': Colors.orange,
      'icon': Icons.directions_bus,
    },
  ];

  final List<String> _filters = ['All', 'Running', 'Off'];

  @override
  Widget build(BuildContext context) {
    final filteredBuses = _getFilteredBuses();
    final totalBuses = buses.length;
    final runningBuses = buses.where((b) => b['status'] == 'Running').length;
    final offBuses = buses.where((b) => b['status'] == 'Off').length;
    final totalStudents = buses.fold(0, (sum, b) => sum + (b['occupiedSeats'] as int));
    final totalCapacity = buses.fold(0, (sum, b) => sum + (b['totalSeats'] as int));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: const Text(
          'Transport Management',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.ngo,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              _showAllRoutes();
            },
            icon: const Icon(Icons.map_rounded, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats Card
          _buildStatsCard(totalBuses, runningBuses, offBuses, totalStudents, totalCapacity),
          const SizedBox(height: 8),

          // Filter Chips
          _buildFilterChips(),
          const SizedBox(height: 4),

          // Buses List
          Expanded(
            child: filteredBuses.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: filteredBuses.length,
              itemBuilder: (context, index) {
                final bus = filteredBuses[index];
                return _buildBusCard(bus);
              },
            ),
          ),
        ],
      ),
    );
  }

  // ==================== STATS CARD ====================
  Widget _buildStatsCard(int total, int running, int off, int students, int capacity) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.ngo, Color(0xFF0EA5E9)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.ngo.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('🚌', '$total', 'Total Buses', Colors.white),
              Container(width: 1, height: 40, color: Colors.white.withOpacity(0.3)),
              _buildStatItem('🟢', '$running', 'Running', Colors.white),
              Container(width: 1, height: 40, color: Colors.white.withOpacity(0.3)),
              _buildStatItem('🔴', '$off', 'Off', Colors.white),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: Colors.white.withOpacity(0.2)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('👥', '$students', 'Students Traveling', Colors.white),
              Container(width: 1, height: 40, color: Colors.white.withOpacity(0.3)),
              _buildStatItem('💺', '$capacity', 'Total Capacity', Colors.white),
              Container(width: 1, height: 40, color: Colors.white.withOpacity(0.3)),
              _buildStatItem(
                '📊',
                '${((students / capacity) * 100).toStringAsFixed(0)}%',
                'Utilization',
                Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String emoji, String value, String label, Color textColor) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: textColor.withOpacity(0.8),
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  // ==================== FILTER CHIPS ====================
  Widget _buildFilterChips() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _filters.map((filter) {
            final isSelected = _selectedFilter == filter;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                selected: isSelected,
                label: Text(
                  filter,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    fontSize: 13,
                  ),
                ),
                backgroundColor: Colors.white,
                selectedColor: AppColors.ngo,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[700],
                ),
                onSelected: (selected) {
                  setState(() {
                    _selectedFilter = filter;
                  });
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected ? AppColors.ngo : Colors.grey[300]!,
                    width: 1,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ==================== BUS CARD ====================
  Widget _buildBusCard(Map<String, dynamic> bus) {
    final bool isRunning = bus['status'] == 'Running';
    final Color statusColor = isRunning ? Colors.green : Colors.red;
    final Color busColor = bus['color'] as Color;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isRunning ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: busColor.withOpacity(0.05),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: busColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    bus['icon'],
                    color: busColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bus['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textMain,
                        ),
                      ),
                      Text(
                        bus['id'],
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        bus['status'],
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Body
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Route
                Row(
                  children: [
                    Icon(
                      Icons.route_rounded,
                      size: 14,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        bus['route'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Driver & Contact
                Row(
                  children: [
                    Icon(
                      Icons.person_rounded,
                      size: 14,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${bus['driver']}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.phone_rounded,
                      size: 12,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      bus['driverContact'],
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Bus Stats Grid
                Row(
                  children: [
                    Expanded(
                      child: _buildBusStat(
                        '💺 Seats',
                        '${bus['occupiedSeats']}/${bus['totalSeats']}',
                        Colors.blue,
                      ),
                    ),
                    Expanded(
                      child: _buildBusStat(
                        '🟢 Available',
                        '${bus['availableSeats']}',
                        Colors.green,
                      ),
                    ),
                    Expanded(
                      child: _buildBusStat(
                        '📊 Occupied',
                        '${((bus['occupiedSeats'] / bus['totalSeats']) * 100).toStringAsFixed(0)}%',
                        Colors.orange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Location & ETA
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            size: 14,
                            color: isRunning ? Colors.green : Colors.red,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            bus['location'],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 14,
                            color: isRunning ? Colors.blue : Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isRunning ? 'ETA: ${bus['eta']}' : bus['eta'],
                            style: TextStyle(
                              fontSize: 12,
                              color: isRunning ? AppColors.ngo : Colors.grey[600],
                              fontWeight: isRunning ? FontWeight.w600 : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '🕐 ${bus['lastUpdate']}',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Action Buttons
                Row(
                  children: [
                    if (isRunning)
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            _showBusDetails(bus);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.ngo,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Track Live',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            _showBusDetails(bus);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.grey,
                            side: BorderSide(color: Colors.grey[300]!),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'View Details',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        onPressed: () {
                          _showDriverContact(bus);
                        },
                        icon: Icon(
                          Icons.phone_rounded,
                          color: AppColors.ngo,
                          size: 20,
                        ),
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

  // ==================== BUS STAT ====================
  Widget _buildBusStat(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== BUS DETAILS ====================
  void _showBusDetails(Map<String, dynamic> bus) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final bool isRunning = bus['status'] == 'Running';
        final Color busColor = bus['color'] as Color;

        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 60,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: busColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      bus['icon'],
                      color: busColor,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bus['name'],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          bus['id'],
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isRunning ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isRunning ? Colors.green : Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          bus['status'],
                          style: TextStyle(
                            color: isRunning ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Divider(color: Colors.grey[200]),
              const SizedBox(height: 16),

              _buildDetailRow('🚌 Route', bus['route']),
              _buildDetailRow('👤 Driver', bus['driver']),
              _buildDetailRow('📞 Contact', bus['driverContact']),
              _buildDetailRow('💺 Occupied', '${bus['occupiedSeats']}/${bus['totalSeats']}'),
              _buildDetailRow('🟢 Available', '${bus['availableSeats']}'),
              _buildDetailRow('📍 Location', bus['location']),
              _buildDetailRow('⏱ ETA', bus['eta']),
              _buildDetailRow('🕐 Last Update', bus['lastUpdate']),
              if (isRunning) _buildDetailRow('🚀 Speed', bus['speed']),

              const SizedBox(height: 16),
              Divider(color: Colors.grey[200]),
              const SizedBox(height: 16),

              if (isRunning)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('📍 Tracking bus live...'),
                          backgroundColor: AppColors.ngo,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.ngo,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Track Live Location',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  // ==================== DRIVER CONTACT ====================
  void _showDriverContact(Map<String, dynamic> bus) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('📞 Contact Driver'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                bus['driver'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                bus['id'] + ' • ' + bus['route'].split('→')[0].trim(),
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.ngo.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.ngo.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.phone_rounded, color: AppColors.ngo),
                    const SizedBox(width: 8),
                    Text(
                      bus['driverContact'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.ngo,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('📞 Calling ${bus['driver']}...'),
                    backgroundColor: AppColors.ngo,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.ngo,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Call Now'),
            ),
          ],
        );
      },
    );
  }

  // ==================== ALL ROUTES ====================
  void _showAllRoutes() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '🗺️ All Routes',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: buses.length,
                  separatorBuilder: (context, index) => Divider(color: Colors.grey[200]),
                  itemBuilder: (context, index) {
                    final bus = buses[index];
                    final bool isRunning = bus['status'] == 'Running';
                    return ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: (bus['color'] as Color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          bus['icon'],
                          color: bus['color'],
                          size: 20,
                        ),
                      ),
                      title: Text(
                        bus['name'],
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(
                        bus['route'],
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isRunning ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          bus['status'],
                          style: TextStyle(
                            color: isRunning ? Colors.green : Colors.red,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        _showBusDetails(bus);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ==================== EMPTY STATE ====================
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.directions_bus_rounded,
            size: 64,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 12),
          Text(
            'No buses found',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Try changing the filter',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  // ==================== HELPER METHODS ====================
  List<Map<String, dynamic>> _getFilteredBuses() {
    if (_selectedFilter == 'All') {
      return buses;
    }
    return buses.where((bus) => bus['status'] == _selectedFilter).toList();
  }
}