import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// ==================== CATEGORY ====================
enum NotifCategory { teacher, ecommerce, ott, school, transport, fee }

extension NotifCategoryX on NotifCategory {
  String get label {
    switch (this) {
      case NotifCategory.teacher:   return 'Teacher';
      case NotifCategory.ecommerce: return 'Ecommerce';
      case NotifCategory.ott:       return 'OTT';
      case NotifCategory.school:    return 'School';
      case NotifCategory.transport: return 'Transport';
      case NotifCategory.fee:       return 'Fee';
    }
  }

  IconData get icon {
    switch (this) {
      case NotifCategory.teacher:   return Icons.school_rounded;
      case NotifCategory.ecommerce: return Icons.shopping_bag_rounded;
      case NotifCategory.ott:       return Icons.movie_rounded;
      case NotifCategory.school:    return Icons.campaign_rounded;
      case NotifCategory.transport: return Icons.directions_bus_rounded;
      case NotifCategory.fee:       return Icons.currency_rupee_rounded;
    }
  }

  Color get color {
    switch (this) {
      case NotifCategory.teacher:   return Colors.indigo;
      case NotifCategory.ecommerce: return const Color(0xFFE91E63);
      case NotifCategory.ott:       return const Color(0xFF7C4DFF);
      case NotifCategory.school:    return const Color(0xFF00897B);
      case NotifCategory.transport: return const Color(0xFFF57C00);
      case NotifCategory.fee:       return const Color(0xFF2E7D32);
    }
  }
}

// ==================== MODEL ====================
class NotificationItem {
  final String id;
  final NotifCategory category;
  final String title;
  final String message;
  final DateTime time;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.category,
    required this.title,
    required this.message,
    required this.time,
    this.isRead = false,
  });
}

// ==================== FILTER ====================
enum NotifFilter { all, unread, teacher, ecommerce, ott, school, transport, fee }

extension NotifFilterX on NotifFilter {
  String get label {
    switch (this) {
      case NotifFilter.all:       return 'All';
      case NotifFilter.unread:    return 'Unread';
      case NotifFilter.teacher:   return 'Teacher';
      case NotifFilter.ecommerce: return 'Ecommerce';
      case NotifFilter.ott:       return 'OTT';
      case NotifFilter.school:    return 'School';
      case NotifFilter.transport: return 'Transport';
      case NotifFilter.fee:       return 'Fee';
    }
  }

  NotifCategory? get category {
    switch (this) {
      case NotifFilter.teacher:   return NotifCategory.teacher;
      case NotifFilter.ecommerce: return NotifCategory.ecommerce;
      case NotifFilter.ott:       return NotifCategory.ott;
      case NotifFilter.school:    return NotifCategory.school;
      case NotifFilter.transport: return NotifCategory.transport;
      case NotifFilter.fee:       return NotifCategory.fee;
      case NotifFilter.all:
      case NotifFilter.unread:
        return null;
    }
  }
}

// ==================== SCREEN ====================
class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  static const Color _primary = Colors.indigo;
  static const Color _primaryLight = Color(0xFFE8EAF6);

  final List<NotificationItem> _items = [];
  NotifFilter _filter = NotifFilter.all;

  @override
  void initState() {
    super.initState();
    _loadDemoData(); // 🔁 future: replace with API call
  }

  // ==================== DEMO DATA ====================
  void _loadDemoData() {
    final now = DateTime.now();
    _items.addAll([
      // ---- Teacher ----
      NotificationItem(
        id: 't1',
        category: NotifCategory.teacher,
        title: 'Homework Assigned',
        message: 'Mrs. Sharma assigned Chapter 5 — Quadratic Equations. Due tomorrow 4:00 PM.',
        time: now.subtract(const Duration(minutes: 3)),
      ),
      NotificationItem(
        id: 't2',
        category: NotifCategory.teacher,
        title: 'Parent Meeting Today',
        message: 'Mr. Verma scheduled a meeting at 3:00 PM in Room 12. Zoom link available.',
        time: now.subtract(const Duration(minutes: 45)),
      ),
      NotificationItem(
        id: 't3',
        category: NotifCategory.teacher,
        title: 'Leave Approved',
        message: 'Your leave request for 12 Nov has been approved by class teacher.',
        time: now.subtract(const Duration(hours: 3)),
        isRead: true,
      ),

      // ---- Ecommerce ----
      NotificationItem(
        id: 'e1',
        category: NotifCategory.ecommerce,
        title: 'Order Shipped 🚚',
        message: 'Order #SWD-2048 (School Shoes, Size 8) is out for delivery.',
        time: now.subtract(const Duration(minutes: 12)),
      ),
      NotificationItem(
        id: 'e2',
        category: NotifCategory.ecommerce,
        title: '50% OFF Today 🔥',
        message: 'Flat 50% off on all school bags. Ends midnight. Shop now!',
        time: now.subtract(const Duration(hours: 1)),
      ),
      NotificationItem(
        id: 'e3',
        category: NotifCategory.ecommerce,
        title: 'Order Delivered ✅',
        message: 'Order #SWD-2033 has been delivered. Rate your experience.',
        time: now.subtract(const Duration(days: 1, hours: 2)),
        isRead: true,
      ),

      // ---- OTT ----
      NotificationItem(
        id: 'o1',
        category: NotifCategory.ott,
        title: 'New Movie Added 🎬',
        message: '"Ram Setu" is now streaming in HD. Watch now on Suwidhaa OTT.',
        time: now.subtract(const Duration(minutes: 20)),
      ),
      NotificationItem(
        id: 'o2',
        category: NotifCategory.ott,
        title: 'Trending Web Series',
        message: '"The Railway Men" is trending at #1 this week. 4 episodes of 45 min each.',
        time: now.subtract(const Duration(hours: 5)),
      ),
      NotificationItem(
        id: 'o3',
        category: NotifCategory.ott,
        title: 'Continue Watching',
        message: 'You stopped watching "Chhota Bheem" at 12:45. Pick up where you left off!',
        time: now.subtract(const Duration(days: 1)),
        isRead: true,
      ),

      // ---- School ----
      NotificationItem(
        id: 's1',
        category: NotifCategory.school,
        title: 'Annual Sports Meet 2026 🏆',
        message: 'Sports meet scheduled on 25 Nov. Register before 20 Nov with your class teacher.',
        time: now.subtract(const Duration(minutes: 30)),
      ),
      NotificationItem(
        id: 's2',
        category: NotifCategory.school,
        title: 'Exam Timetable Published',
        message: 'Half Yearly exam timetable for Class 10th is now available.',
        time: now.subtract(const Duration(hours: 6)),
      ),

      // ---- Transport ----
      NotificationItem(
        id: 'tr1',
        category: NotifCategory.transport,
        title: 'Bus Arriving in 5 min 🚌',
        message: 'Bus MH12AB1234 (Route A) is 5 minutes away from your stop.',
        time: now.subtract(const Duration(minutes: 5)),
      ),
      NotificationItem(
        id: 'tr2',
        category: NotifCategory.transport,
        title: 'Route Change Notice',
        message: 'Bus route A will take a detour via MG Road tomorrow due to road work.',
        time: now.subtract(const Duration(days: 1, hours: 4)),
        isRead: true,
      ),

      // ---- Fee ----
      NotificationItem(
        id: 'f1',
        category: NotifCategory.fee,
        title: 'Fee Due Reminder 💰',
        message: 'Term 2 fee ₹8,500 is due on 30 Nov. Pay now to avoid late fee.',
        time: now.subtract(const Duration(hours: 2)),
      ),
      NotificationItem(
        id: 'f2',
        category: NotifCategory.fee,
        title: 'Payment Received',
        message: 'Your payment of ₹5,000 for Term 1 is successful. Thank you!',
        time: now.subtract(const Duration(days: 2)),
        isRead: true,
      ),
    ]);
    setState(() {});
  }

  // ==================== HELPERS ====================
  List<NotificationItem> get _filtered {
    var list = _items.toList();
    if (_filter == NotifFilter.unread) {
      list = list.where((n) => !n.isRead).toList();
    } else {
      final cat = _filter.category;
      if (cat != null) list = list.where((n) => n.category == cat).toList();
    }
    list.sort((a, b) => b.time.compareTo(a.time));
    return list;
  }

  int get _unreadCount => _items.where((n) => !n.isRead).length;

  void _markAllRead() {
    setState(() {
      for (final n in _items) n.isRead = true;
    });
  }

  void _markRead(NotificationItem n) {
    if (!n.isRead) setState(() => n.isRead = true);
  }

  void _deleteOne(NotificationItem n) {
    setState(() => _items.remove(n));
  }

  // ==================== GROUPING ====================
  String _groupLabel(DateTime t) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(t.year, t.month, t.day);
    final diff = today.difference(d).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    if (diff < 7) return 'This Week';
    return 'Earlier';
  }

  String _relativeTime(DateTime t) {
    final d = DateTime.now().difference(t);
    if (d.inMinutes < 1) return 'Just now';
    if (d.inMinutes < 60) return '${d.inMinutes}m ago';
    if (d.inHours < 24) return '${d.inHours}h ago';
    if (d.inDays == 1) return 'Yesterday';
    if (d.inDays < 7) return '${d.inDays}d ago';
    return DateFormat('dd MMM').format(t);
  }

  Map<String, List<NotificationItem>> get _grouped {
    final map = <String, List<NotificationItem>>{};
    for (final n in _filtered) {
      map.putIfAbsent(_groupLabel(n.time), () => []).add(n);
    }
    const order = ['Today', 'Yesterday', 'This Week', 'Earlier'];
    final sorted = <String, List<NotificationItem>>{};
    for (final k in order) {
      if (map.containsKey(k)) sorted[k] = map[k]!;
    }
    return sorted;
  }

  // ==================== BUILD ====================
  @override
  Widget build(BuildContext context) {
    final grouped = _grouped;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: _primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios, size: 20),
        ),
        title: Row(
          children: [
            const Text(
              'Notifications',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
            ),
            if (_unreadCount > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$_unreadCount',
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
        actions: [
          if (_unreadCount > 0)
            TextButton.icon(
              onPressed: _markAllRead,
              icon: const Icon(Icons.done_all_rounded,
                  size: 16, color: Colors.white),
              label: const Text(
                'Read all',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          const SizedBox(width: 4),
        ],
      ),
      body: _items.isEmpty
          ? _emptyState()
          : Column(
        children: [
          _filterStrip(),
          const Divider(height: 1, color: Color(0xFFEEF0F5)),
          Expanded(
            child: grouped.isEmpty
                ? _noResults()
                : RefreshIndicator(
              color: _primary,
              onRefresh: () async {
                await Future.delayed(
                    const Duration(milliseconds: 500));
                setState(() {});
              },
              child: ListView(
                padding:
                const EdgeInsets.fromLTRB(12, 12, 12, 24),
                children: [
                  for (final entry in grouped.entries) ...[
                    _sectionHeader(entry.key),
                    ...entry.value
                        .map((n) => _notifCard(n))
                        .toList(),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== FILTER STRIP ====================
  Widget _filterStrip() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: NotifFilter.values.map((f) {
            final selected = _filter == f;
            final color = (f.category?.color) ?? _primary;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InkWell(
                onTap: () => setState(() => _filter = f),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: selected ? color : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: selected ? color : Colors.grey.shade300,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (f == NotifFilter.unread)
                        Icon(
                          Icons.mark_email_unread_rounded,
                          size: 12,
                          color: selected ? Colors.white : color,
                        )
                      else if (f.category != null)
                        Icon(
                          f.category!.icon,
                          size: 12,
                          color: selected ? Colors.white : color,
                        ),
                      if (f == NotifFilter.unread || f.category != null)
                        const SizedBox(width: 5),
                      Text(
                        f.label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: selected ? Colors.white : color,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ==================== SECTION HEADER ====================
  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 10),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 14,
            decoration: BoxDecoration(
              color: _primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: Colors.black54,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }

  // ==================== NOTIF CARD ====================
  Widget _notifCard(NotificationItem n) {
    final c = n.category.color;
    return Dismissible(
      key: ValueKey(n.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.delete_outline_rounded,
            color: Colors.white, size: 24),
      ),
      onDismissed: (_) => _deleteOne(n),
      child: InkWell(
        onTap: () => _markRead(n),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: n.isRead ? Colors.white : c.withOpacity(0.04),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: n.isRead
                  ? Colors.grey.shade200
                  : c.withOpacity(0.28),
              width: n.isRead ? 1 : 1.3,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon bubble
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: c.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(n.category.icon, color: c, size: 20),
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
                            n.title,
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: n.isRead
                                  ? FontWeight.w600
                                  : FontWeight.w800,
                              color: const Color(0xFF1A1F36),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (!n.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(left: 6),
                            decoration: BoxDecoration(
                              color: c,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      n.message,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                        height: 1.35,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: c.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            n.category.label,
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              color: c,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Icon(Icons.schedule_rounded,
                            size: 11, color: Colors.grey.shade500),
                        const SizedBox(width: 3),
                        Text(
                          _relativeTime(n.time),
                          style: TextStyle(
                            fontSize: 10.5,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
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

  // ==================== EMPTY / NO-RESULTS ====================
  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: _primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.notifications_off_rounded,
                  size: 44, color: _primary),
            ),
            const SizedBox(height: 16),
            const Text(
              'No notifications yet',
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1F36),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "You're all caught up!",
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _noResults() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: const BoxDecoration(
              color: _primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.filter_alt_off_rounded,
                size: 36, color: _primary),
          ),
          const SizedBox(height: 12),
          Text(
            'No ${_filter.label.toLowerCase()} notifications',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1F36),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Try a different filter',
            style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}