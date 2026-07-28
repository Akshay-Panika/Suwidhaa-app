import 'package:flutter/material.dart';

class NgoHistoryScreen extends StatefulWidget {
  const NgoHistoryScreen({super.key});

  @override
  State<NgoHistoryScreen> createState() => _NgoHistoryScreenState();
}

class _NgoHistoryScreenState extends State<NgoHistoryScreen> {
  final List<Map<String, dynamic>> _history = [
    {
      "title": "Education Fund",
      "amount": "\$500",
      "date": "15 Feb 2024",
      "status": "Completed",
      "type": "Donation",
      "icon": Icons.school,
      "color": Colors.blue,
    },
    {
      "title": "Medical Camp",
      "amount": "\$250",
      "date": "14 Feb 2024",
      "status": "Completed",
      "type": "Donation",
      "icon": Icons.medical_services,
      "color": Colors.green,
    },
    {
      "title": "Bank Withdrawal",
      "amount": "\$1000",
      "date": "13 Feb 2024",
      "status": "Pending",
      "type": "Withdrawal",
      "icon": Icons.account_balance,
      "color": Colors.orange,
    },
    {
      "title": "Tree Plantation",
      "amount": "\$150",
      "date": "12 Feb 2024",
      "status": "Completed",
      "type": "Donation",
      "icon": Icons.nature,
      "color": Colors.green,
    },
    {
      "title": "Animal Shelter",
      "amount": "\$300",
      "date": "10 Feb 2024",
      "status": "Completed",
      "type": "Donation",
      "icon": Icons.pets,
      "color": Colors.orange,
    },
    {
      "title": "Women Empowerment",
      "amount": "\$750",
      "date": "08 Feb 2024",
      "status": "Completed",
      "type": "Donation",
      "icon": Icons.woman,
      "color": Colors.purple,
    },
    {
      "title": "PayPal Withdrawal",
      "amount": "\$500",
      "date": "06 Feb 2024",
      "status": "Failed",
      "type": "Withdrawal",
      "icon": Icons.payment,
      "color": Colors.red,
    },
  ];

  String _selectedFilter = "All";
  final List<String> _filters = ["All", "Donation", "Withdrawal"];

  List<Map<String, dynamic>> get _filteredHistory {
    if (_selectedFilter == "All") {
      return _history;
    }
    return _history.where((item) => item["type"] == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        spacing: 10,
        children: [
          // Filter Chips
          Container(
            child: Row(
              children: _filters.map((filter) {
                bool isSelected = _selectedFilter == filter;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: FilterChip(
                      label: Center(
                        child: Text(
                          filter,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey[700],
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      },
                      backgroundColor: Colors.grey[100],
                      selectedColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // History List
          Expanded(
            child: _filteredHistory.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 60, color: Colors.grey[400]),
                  const SizedBox(height: 12),
                  Text(
                    "No history found",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: _filteredHistory.length,
              itemBuilder: (context, index) {
                final item = _filteredHistory[index];
                return _buildHistoryCard(item);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> item) {
    Color statusColor;
    if (item["status"] == "Completed") {
      statusColor = Colors.green;
    } else if (item["status"] == "Pending") {
      statusColor = Colors.orange;
    } else {
      statusColor = Colors.red;
    }

    return Card(
      elevation: 0.3,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // Icon
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: item["color"].withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                item["icon"],
                color: item["color"],
                size: 22,
              ),
            ),
            const SizedBox(width: 14),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item["title"],
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          item["status"],
                          style: TextStyle(
                            fontSize: 11,
                            color: statusColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        item["date"],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Amount
            Text(
              item["amount"],
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: item["type"] == "Donation" ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}