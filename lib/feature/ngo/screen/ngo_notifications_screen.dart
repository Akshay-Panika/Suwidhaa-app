import 'package:flutter/material.dart';

class NgoNotificationsScreen extends StatefulWidget {
  const NgoNotificationsScreen({super.key});

  @override
  State<NgoNotificationsScreen> createState() => _NgoNotificationsScreenState();
}

class _NgoNotificationsScreenState extends State<NgoNotificationsScreen> {
  final List<Map<String, dynamic>> _notifications = [
    {
      "title": "New Donation Received",
      "message": "John Doe donated \$500 to Education Fund",
      "time": "2 minutes ago",
      "icon": Icons.volunteer_activism,
      "color": Colors.green,
      "isRead": false,
    },
    {
      "title": "Campaign Update",
      "message": "Medical Camp has reached 80% of its target goal",
      "time": "1 hour ago",
      "icon": Icons.medical_services,
      "color": Colors.blue,
      "isRead": false,
    },
    {
      "title": "New Follower",
      "message": "Sarah Johnson started following your NGO",
      "time": "3 hours ago",
      "icon": Icons.person_add,
      "color": Colors.purple,
      "isRead": true,
    },
    {
      "title": "Donation Milestone",
      "message": "Tree Plantation campaign has reached 50 donors",
      "time": "5 hours ago",
      "icon": Icons.celebration,
      "color": Colors.orange,
      "isRead": true,
    },
    {
      "title": "Campaign Completed",
      "message": "Animal Shelter campaign has successfully completed",
      "time": "1 day ago",
      "icon": Icons.check_circle,
      "color": Colors.green,
      "isRead": true,
    },
    {
      "title": "New Comment",
      "message": "Emma Williams commented on your campaign",
      "time": "2 days ago",
      "icon": Icons.comment,
      "color": Colors.blue,
      "isRead": true,
    },
    {
      "title": "Weekly Report",
      "message": "Your NGO raised \$2,500 this week across all campaigns",
      "time": "3 days ago",
      "icon": Icons.analytics,
      "color": Colors.teal,
      "isRead": true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        titleTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20
        ),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: () {
              setState(() {
                for (var notification in _notifications) {
                  notification["isRead"] = true;
                }
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All notifications marked as read'),
                  duration: Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
      body: _notifications.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_off,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              "No notifications",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "You're all caught up!",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final notification = _notifications[index];
          return _buildNotificationCard(notification, index);
        },
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification, int index) {
    return Card(
      elevation: 0.5,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: notification["isRead"] ? Colors.transparent : Colors.teal.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            notification["isRead"] = true;
          });
          // Show notification details
          _showNotificationDialog(context, notification);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: notification["color"].withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  notification["icon"],
                  color: notification["color"],
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification["title"],
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: notification["isRead"]
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                              color: notification["isRead"]
                                  ? Colors.black87
                                  : Colors.black,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (!notification["isRead"])
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.teal,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification["message"],
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification["time"],
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNotificationDialog(BuildContext context, Map<String, dynamic> notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: notification["color"].withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                notification["icon"],
                color: notification["color"],
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                notification["title"],
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification["message"],
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                notification["time"],
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to relevant screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
            ),
            child: const Text("View Details"),
          ),
        ],
      ),
    );
  }
}