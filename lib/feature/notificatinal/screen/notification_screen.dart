import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Notifications',
          style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Mark all read', style: TextStyle(color: Color(0xFF5F259F))),
          )
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: 5,
        separatorBuilder: (context, index) => const Divider(height: 1, indent: 70),
        itemBuilder: (context, index) {
          // Mock data logic: first 2 are unread
          final isUnread = index < 2;
          return _buildNotificationTile(
            isUnread: isUnread,
            title: isUnread ? 'New Order Update!' : 'Payment Successful',
            subtitle: 'Your order #${1000 + index} has been dispatched from our hub.',
            time: '2h ago',
          );
        },
      ),
    );
  }

  Widget _buildNotificationTile({
    required bool isUnread,
    required String title,
    required String subtitle,
    required String time,
  }) {
    return Container(
      color: isUnread ? const Color(0xFF5F259F).withOpacity(0.04) : Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: isUnread ? const Color(0xFF5F259F) : Colors.grey[200],
          child: Icon(
            isUnread ? Icons.notifications_active_rounded : Icons.notifications_none_rounded,
            color: isUnread ? Colors.white : Colors.grey[600],
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isUnread ? FontWeight.bold : FontWeight.w500,
            color: const Color(0xFF1E293B),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(fontSize: 13, color: Colors.grey)),
            const SizedBox(height: 4),
            Text(time, style: const TextStyle(fontSize: 11, color: Colors.blueGrey)),
          ],
        ),
        onTap: () {},
      ),
    );
  }
}