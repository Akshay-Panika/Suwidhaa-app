// lib/feature/school/sports/screen/annual_sports_meet_screen.dart

import 'package:flutter/material.dart';

class AnnualSportsMeetScreen extends StatefulWidget {
  const AnnualSportsMeetScreen({super.key});

  @override
  State<AnnualSportsMeetScreen> createState() =>
      _AnnualSportsMeetScreenState();
}

class _AnnualSportsMeetScreenState extends State<AnnualSportsMeetScreen> {
  static const Color _primary = Colors.indigo;
  static const Color _primaryDark = Color(0xFF283593);

  // ============================================================
  // TABS
  // ============================================================
  int _tabIndex = 0;

  // ============================================================
  // EVENT INFO
  // ============================================================
  final Map<String, dynamic> _event = {
    "title": "Annual Sports Meet 2025",
    "startDate": "15 Oct 2025",
    "endDate": "18 Oct 2025",
    "venue": "Springfield Sports Complex",
    "status": "Upcoming",
    "daysLeft": 12,
  };

  // ============================================================
  // SPORTS LIST
  // ============================================================
  final List<Map<String, dynamic>> _sports = [
    {
      "id": 1,
      "name": "Cricket",
      "icon": Icons.sports_cricket_rounded,
      "color": Colors.green,
      "type": "Team",
      "teamSize": 11,
    },
    {
      "id": 2,
      "name": "Football",
      "icon": Icons.sports_soccer_rounded,
      "color": Colors.blue,
      "type": "Team",
      "teamSize": 11,
    },
    {
      "id": 3,
      "name": "Basketball",
      "icon": Icons.sports_basketball_rounded,
      "color": Colors.orange,
      "type": "Team",
      "teamSize": 5,
    },
    {
      "id": 4,
      "name": "Volleyball",
      "icon": Icons.sports_volleyball_rounded,
      "color": Colors.amber,
      "type": "Team",
      "teamSize": 6,
    },
    {
      "id": 5,
      "name": "Kabaddi",
      "icon": Icons.sports_kabaddi_rounded,
      "color": Colors.red,
      "type": "Team",
      "teamSize": 7,
    },
    {
      "id": 6,
      "name": "Athletics",
      "icon": Icons.directions_run_rounded,
      "color": Colors.deepOrange,
      "type": "Individual",
      "teamSize": 1,
    },
    {
      "id": 7,
      "name": "Badminton",
      "icon": Icons.sports_tennis_rounded,
      "color": Colors.purple,
      "type": "Individual",
      "teamSize": 2,
    },
    {
      "id": 8,
      "name": "Table Tennis",
      "icon": Icons.sports_tennis_rounded,
      "color": Colors.teal,
      "type": "Individual",
      "teamSize": 2,
    },
    {
      "id": 9,
      "name": "Chess",
      "icon": Icons.sports_esports_rounded,
      "color": Colors.brown,
      "type": "Individual",
      "teamSize": 1,
    },
    {
      "id": 10,
      "name": "Kho-Kho",
      "icon": Icons.directions_run_rounded,
      "color": Colors.pink,
      "type": "Team",
      "teamSize": 9,
    },
  ];

  // ============================================================
  // GROUPS (created by teacher — mutable)
  // ============================================================
  final List<Map<String, dynamic>> _groups = [
    {
      "id": 1,
      "name": "Class 10-A Tigers",
      "className": "10-A",
      "sportId": 1,
      "captain": "Aarav Sharma",
      "members": [
        "Aarav Sharma",
        "Rohan Gupta",
        "Kabir Singh",
        "Vivaan Patel",
        "Arjun Mehta"
      ],
      "color": Colors.green,
      "createdBy": "Mr. Sharma",
    },
    {
      "id": 2,
      "name": "Class 10-B Lions",
      "className": "10-B",
      "sportId": 1,
      "captain": "Priya Verma",
      "members": [
        "Priya Verma",
        "Sneha Patel",
        "Ananya Rao",
        "Diya Kapoor",
        "Riya Singh"
      ],
      "color": Colors.blue,
      "createdBy": "Mr. Sharma",
    },
    {
      "id": 3,
      "name": "Class 9-A Eagles",
      "className": "9-A",
      "sportId": 2,
      "captain": "Rohit Kumar",
      "members": ["Rohit Kumar", "Sahil Khan", "Manish Yadav"],
      "color": Colors.orange,
      "createdBy": "Mr. Sharma",
    },
  ];

  // ============================================================
  // MATCHES (set by teacher — mutable)
  // ============================================================
  final List<Map<String, dynamic>> _matches = [
    {
      "id": 1,
      "sportId": 1,
      "sportName": "Cricket",
      "sportIcon": Icons.sports_cricket_rounded,
      "sportColor": Colors.green,
      "teamA": "Class 10-A Tigers",
      "teamB": "Class 10-B Lions",
      "date": "15 Oct 2025",
      "time": "10:00 AM",
      "venue": "Main Ground",
      "status": "Scheduled",
      "scoreA": null,
      "scoreB": null,
      "winner": null,
    },
    {
      "id": 2,
      "sportId": 2,
      "sportName": "Football",
      "sportIcon": Icons.sports_soccer_rounded,
      "sportColor": Colors.blue,
      "teamA": "Class 9-A Eagles",
      "teamB": "Class 9-B Falcons",
      "date": "16 Oct 2025",
      "time": "02:00 PM",
      "venue": "Football Field",
      "status": "Scheduled",
      "scoreA": null,
      "scoreB": null,
      "winner": null,
    },
    {
      "id": 3,
      "sportId": 1,
      "sportName": "Cricket",
      "sportIcon": Icons.sports_cricket_rounded,
      "sportColor": Colors.green,
      "teamA": "Class 10-A Tigers",
      "teamB": "Class 10-C Panthers",
      "date": "17 Oct 2025",
      "time": "10:00 AM",
      "venue": "Main Ground",
      "status": "Live",
      "scoreA": "145/3",
      "scoreB": "120/8",
      "winner": null,
    },
    {
      "id": 4,
      "sportId": 3,
      "sportName": "Basketball",
      "sportIcon": Icons.sports_basketball_rounded,
      "sportColor": Colors.orange,
      "teamA": "Class 11-A Warriors",
      "teamB": "Class 11-B Titans",
      "date": "14 Oct 2025",
      "time": "04:00 PM",
      "venue": "Indoor Court",
      "status": "Completed",
      "scoreA": "78",
      "scoreB": "65",
      "winner": "Class 11-A Warriors",
    },
  ];

  // ============================================================
  // STATS
  // ============================================================
  List<Map<String, dynamic>> get _stats => [
    {"label": "Sports", "value": "${_sports.length}", "color": _primary},
    {"label": "Groups", "value": "${_groups.length}", "color": Colors.teal},
    {
      "label": "Matches",
      "value": "${_matches.length}",
      "color": Colors.orange
    },
    {
      "label": "Live",
      "value":
      "${_matches.where((m) => m['status'] == 'Live').length}",
      "color": Colors.red,
    },
  ];

  void _snack(String msg, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        backgroundColor: color ?? _primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _heroCard(),
            const SizedBox(height: 12),

            // Stats row
            Row(
              children: _stats.asMap().entries.map((entry) {
                final s = entry.value;
                final isLast = entry.key == _stats.length - 1;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: isLast ? 0 : 6),
                    child: _compactStat(s),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            _buildTabBar(),

            const SizedBox(height: 14),

            if (_tabIndex == 0) _sportsTab(),
            if (_tabIndex == 1) _groupsTab(),
            if (_tabIndex == 2) _matchesTab(),

            const SizedBox(height: 100),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onFabPressed,
        backgroundColor: _primary,
        icon: Icon(_fabIcon(), color: Colors.white),
        label: Text(
          _fabLabel(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // APP BAR
  // ============================================================
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: _primary,
      foregroundColor: Colors.white,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_ios),
      ),
      title: const Text(
        "Sports Meet 2025",
        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
      ),
      actions: [
        IconButton(
          onPressed: () => _snack("Showing results & standings"),
          icon: const Icon(Icons.emoji_events_rounded),
        ),
      ],
    );
  }

  // ============================================================
  // HERO CARD
  // ============================================================
  Widget _heroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_primary, _primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Icon(
              Icons.sports_soccer_rounded,
              size: 100,
              color: Colors.white.withOpacity(0.08),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _event['status'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "${_event['daysLeft']} days left",
                      style: const TextStyle(
                        color: Colors.amber,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                _event['title'] as String,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.calendar_today_rounded,
                      color: Colors.white70, size: 12),
                  const SizedBox(width: 4),
                  Text(
                    "${_event['startDate']} - ${_event['endDate']}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.location_on_rounded,
                      color: Colors.white70, size: 12),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      _event['venue'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // COMPACT STAT
  // ============================================================
  Widget _compactStat(Map<String, dynamic> s) {
    final c = s['color'] as Color;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(
            s['value'] as String,
            style: TextStyle(
              fontSize: 15,
              color: c,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            s['label'] as String,
            style: TextStyle(fontSize: 9.5, color: Colors.grey[600]),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TAB BAR
  // ============================================================
  Widget _buildTabBar() {
    final tabs = [
      {"label": "Sports", "icon": Icons.sports_rounded},
      {"label": "Groups", "icon": Icons.groups_rounded},
      {"label": "Matches", "icon": Icons.sports_score_rounded},
    ];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: tabs.asMap().entries.map((entry) {
          final i = entry.key;
          final t = entry.value;
          final isSelected = _tabIndex == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _tabIndex = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? _primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      t['icon'] as IconData,
                      size: 15,
                      color: isSelected ? Colors.white : Colors.grey[600],
                    ),
                    const SizedBox(width: 5),
                    Text(
                      t['label'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color:
                        isSelected ? Colors.white : Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ============================================================
  // TAB 1 — SPORTS
  // ============================================================
  Widget _sportsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader("All Sports", Icons.sports_rounded),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _sports.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 2.3,
          ),
          itemBuilder: (context, i) => _sportCard(_sports[i]),
        ),
      ],
    );
  }

  // ============================================================
  // TAB 2 — GROUPS
  // ============================================================
  Widget _groupsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader("Student Groups", Icons.groups_rounded),
        const SizedBox(height: 4),
        Text(
          "Groups created by teachers for each sport",
          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
        ),
        const SizedBox(height: 10),
        if (_groups.isEmpty)
          _emptyCard(
              "No groups created yet", "Tap + to create the first group")
        else
          ..._groups.reversed.map((g) => _groupCard(g)),
      ],
    );
  }

  // ============================================================
  // TAB 3 — MATCHES
  // ============================================================
  Widget _matchesTab() {
    final live = _matches.where((m) => m['status'] == 'Live').toList();
    final scheduled =
    _matches.where((m) => m['status'] == 'Scheduled').toList();
    final completed =
    _matches.where((m) => m['status'] == 'Completed').toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (live.isNotEmpty) ...[
          _sectionHeader("🔴 Live Now", Icons.sports_score_rounded),
          const SizedBox(height: 8),
          ...live.map((m) => _matchCard(m)),
          const SizedBox(height: 14),
        ],
        if (scheduled.isNotEmpty) ...[
          _sectionHeader("Upcoming Matches", Icons.schedule_rounded),
          const SizedBox(height: 8),
          ...scheduled.reversed.map((m) => _matchCard(m)),
          const SizedBox(height: 14),
        ],
        if (completed.isNotEmpty) ...[
          _sectionHeader("Completed", Icons.check_circle_rounded),
          const SizedBox(height: 8),
          ...completed.map((m) => _matchCard(m)),
        ],
        if (_matches.isEmpty)
          _emptyCard("No matches scheduled", "Tap + to schedule a match"),
      ],
    );
  }

  // ============================================================
  // SPORT CARD
  // ============================================================
  Widget _sportCard(Map<String, dynamic> s) {
    final c = s['color'] as Color;
    final isTeam = s['type'] == "Team";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: c.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(s['icon'] as IconData, color: c, size: 16),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  s['name'] as String,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(
                    color: isTeam
                        ? Colors.blue.withOpacity(0.1)
                        : Colors.purple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    isTeam
                        ? "${s['type']} • ${s['teamSize']}v${s['teamSize']}"
                        : s['type'] as String,
                    style: TextStyle(
                      fontSize: 8.5,
                      fontWeight: FontWeight.w700,
                      color: isTeam ? Colors.blue : Colors.purple,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // GROUP CARD
  // ============================================================
  Widget _groupCard(Map<String, dynamic> g) {
    final c = g['color'] as Color;
    final sport = _sports.firstWhere((s) => s['id'] == g['sportId']);
    final members = g['members'] as List;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: c.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: c.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  sport['icon'] as IconData,
                  color: c,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      g['name'] as String,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.class_rounded,
                          size: 10,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 3),
                        Text(
                          g['className'] as String,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 1),
                          decoration: BoxDecoration(
                            color: c.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            sport['name'] as String,
                            style: TextStyle(
                              fontSize: 8.5,
                              fontWeight: FontWeight.w700,
                              color: c,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${members.length} members",
                  style: const TextStyle(
                    fontSize: 9.5,
                    color: Colors.green,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.person_rounded,
                  size: 11, color: Colors.amber[700]),
              const SizedBox(width: 4),
              Text(
                "Captain: ",
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                g['captain'] as String,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MATCH CARD
  // ============================================================
  Widget _matchCard(Map<String, dynamic> m) {
    final c = m['sportColor'] as Color;
    final status = m['status'] as String;

    Color statusColor;
    IconData statusIcon;
    if (status == 'Live') {
      statusColor = Colors.red;
      statusIcon = Icons.fiber_manual_record;
    } else if (status == 'Completed') {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle_rounded;
    } else {
      statusColor = Colors.orange;
      statusIcon = Icons.schedule_rounded;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.withOpacity(0.25)),
        boxShadow: [
          BoxShadow(
            color: c.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(m['sportIcon'] as IconData, size: 14, color: c),
              const SizedBox(width: 5),
              Text(
                m['sportName'] as String,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: c,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, size: 8, color: statusColor),
                    const SizedBox(width: 4),
                    Text(
                      status,
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      m['teamA'] as String,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (m['scoreA'] != null)
                      Text(
                        m['scoreA'] as String,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: c,
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "VS",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Colors.grey,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      m['teamB'] as String,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.end,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (m['scoreB'] != null)
                      Text(
                        m['scoreB'] as String,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: c,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today_rounded,
                    size: 11, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Text(
                  m['date'] as String,
                  style: TextStyle(fontSize: 10, color: Colors.grey[700]),
                ),
                const SizedBox(width: 10),
                Icon(Icons.access_time_rounded,
                    size: 11, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Text(
                  m['time'] as String,
                  style: TextStyle(fontSize: 10, color: Colors.grey[700]),
                ),
                const SizedBox(width: 10),
                Icon(Icons.location_on_rounded,
                    size: 11, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    m['venue'] as String,
                    style: TextStyle(fontSize: 10, color: Colors.grey[700]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          if (m['winner'] != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.emoji_events_rounded,
                      size: 14, color: Colors.amber),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      "Winner: ${m['winner']}",
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ============================================================
  // SECTION HEADER
  // ============================================================
  Widget _sectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: _primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, color: _primary, size: 14),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // EMPTY CARD
  // ============================================================
  Widget _emptyCard(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(Icons.inbox_rounded, size: 40, color: Colors.grey[300]),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(fontSize: 11, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FAB
  // ============================================================
  IconData _fabIcon() {
    switch (_tabIndex) {
      case 1:
        return Icons.group_add_rounded;
      case 2:
        return Icons.add_task_rounded;
      default:
        return Icons.info_outline_rounded;
    }
  }

  String _fabLabel() {
    switch (_tabIndex) {
      case 1:
        return "Create Group";
      case 2:
        return "Schedule Match";
      default:
        return "Sports Info";
    }
  }

  void _onFabPressed() {
    if (_tabIndex == 1) {
      _showCreateGroupSheet();
    } else if (_tabIndex == 2) {
      _showCreateMatchSheet();
    } else {
      _snack("These are the sports available in your school");
    }
  }

  // ============================================================
  // CREATE GROUP SHEET
  // ============================================================
  void _showCreateGroupSheet() {
    final nameCtrl = TextEditingController();
    final classCtrl = TextEditingController();
    final captainCtrl = TextEditingController();
    final membersCtrl = TextEditingController();
    int selectedSportId = _sports.first['id'] as int;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) => Padding(
          padding:
          EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius:
              BorderRadius.vertical(top: Radius.circular(22)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sheetHandle(),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.group_add_rounded,
                            color: _primary, size: 20),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Create Student Group",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _inputField(nameCtrl, "Group Name",
                      "e.g. Class 10-A Tigers", Icons.groups_rounded),
                  const SizedBox(height: 10),
                  _inputField(classCtrl, "Class", "e.g. 10-A",
                      Icons.class_rounded),
                  const SizedBox(height: 10),
                  _inputField(captainCtrl, "Captain Name",
                      "e.g. Aarav Sharma", Icons.person_rounded),
                  const SizedBox(height: 10),
                  _inputField(
                    membersCtrl,
                    "Members (comma separated)",
                    "e.g. Rohan, Kabir, Vivaan",
                    Icons.people_rounded,
                  ),
                  const SizedBox(height: 12),

                  const Text(
                    "Select Sport",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: selectedSportId,
                        isExpanded: true,
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: _primary,
                        ),
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 13,
                        ),
                        items: _sports
                            .map((s) => DropdownMenuItem<int>(
                          value: s['id'] as int,
                          child: Row(
                            children: [
                              Icon(
                                s['icon'] as IconData,
                                size: 16,
                                color: s['color'] as Color,
                              ),
                              const SizedBox(width: 10),
                              Text(s['name'] as String),
                            ],
                          ),
                        ))
                            .toList(),
                        onChanged: (v) =>
                            setModal(() => selectedSportId = v!),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (nameCtrl.text.trim().isEmpty ||
                            classCtrl.text.trim().isEmpty ||
                            captainCtrl.text.trim().isEmpty) {
                          _snack("Please fill all fields",
                              color: Colors.red);
                          return;
                        }

                        final sport = _sports.firstWhere(
                              (s) => s['id'] == selectedSportId,
                        );

                        // Parse members
                        final extraMembers = membersCtrl.text
                            .split(',')
                            .map((e) => e.trim())
                            .where((e) => e.isNotEmpty)
                            .toList();

                        final allMembers = [
                          captainCtrl.text.trim(),
                          ...extraMembers,
                        ];

                        // ✅ ADD TO LIST
                        setState(() {
                          _groups.add({
                            "id": _groups.length + 1,
                            "name": nameCtrl.text.trim(),
                            "className": classCtrl.text.trim(),
                            "sportId": selectedSportId,
                            "captain": captainCtrl.text.trim(),
                            "members": allMembers,
                            "color": sport['color'] as Color,
                            "createdBy": "You",
                          });
                          _tabIndex = 1; // switch to Groups tab
                        });

                        Navigator.pop(ctx);
                        _snack(
                          "Group '${nameCtrl.text.trim()}' created!",
                          color: Colors.green,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primary,
                        padding:
                        const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.check_circle_rounded,
                          color: Colors.white, size: 18),
                      label: const Text(
                        "Create Group",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // CREATE MATCH SHEET
  // ============================================================
  void _showCreateMatchSheet() {
    final venueCtrl = TextEditingController(text: "Main Ground");
    int selectedSportId = _sports.first['id'] as int;
    String? teamA;
    String? teamB;
    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
    TimeOfDay selectedTime = const TimeOfDay(hour: 10, minute: 0);

    List<Map<String, dynamic>> groupsForSport(int sportId) =>
        _groups.where((g) => g['sportId'] == sportId).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) {
          final availableGroups = groupsForSport(selectedSportId);

          return Padding(
            padding:
            EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.vertical(top: Radius.circular(22)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sheetHandle(),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.sports_score_rounded,
                              color: _primary, size: 20),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "Schedule Match",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Sport
                    const Text(
                      "Sport",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _dropdownContainer<int>(
                      value: selectedSportId,
                      items: _sports
                          .map((s) => DropdownMenuItem<int>(
                        value: s['id'] as int,
                        child: Row(
                          children: [
                            Icon(
                              s['icon'] as IconData,
                              size: 16,
                              color: s['color'] as Color,
                            ),
                            const SizedBox(width: 10),
                            Text(s['name'] as String),
                          ],
                        ),
                      ))
                          .toList(),
                      onChanged: (v) => setModal(() {
                        selectedSportId = v!;
                        teamA = null;
                        teamB = null;
                      }),
                    ),

                    // Info if not enough groups
                    if (availableGroups.length < 2) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: Colors.orange.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.info_outline_rounded,
                                size: 14, color: Colors.orange),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                "Need at least 2 groups for this sport. Create more first.",
                                style: TextStyle(
                                  fontSize: 10.5,
                                  color: Colors.orange[800],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 12),

                    // Team A
                    const Text(
                      "Team A",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _dropdownContainer<String>(
                      value: teamA,
                      hint: "Select group",
                      items: availableGroups
                          .map((g) => DropdownMenuItem<String>(
                        value: g['name'] as String,
                        child: Text(g['name'] as String),
                      ))
                          .toList(),
                      onChanged: (v) => setModal(() => teamA = v),
                    ),

                    const SizedBox(height: 12),

                    // Team B
                    const Text(
                      "Team B",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _dropdownContainer<String>(
                      value: teamB,
                      hint: "Select group",
                      items: availableGroups
                          .where((g) => g['name'] != teamA)
                          .map((g) => DropdownMenuItem<String>(
                        value: g['name'] as String,
                        child: Text(g['name'] as String),
                      ))
                          .toList(),
                      onChanged: (v) => setModal(() => teamB = v),
                    ),

                    const SizedBox(height: 12),

                    // Date + Time
                    Row(
                      children: [
                        Expanded(
                          child: _pickerTile(
                            icon: Icons.calendar_today_rounded,
                            label: "Date",
                            value:
                            "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: ctx,
                                initialDate: selectedDate,
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now()
                                    .add(const Duration(days: 365)),
                              );
                              if (picked != null) {
                                setModal(() => selectedDate = picked);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _pickerTile(
                            icon: Icons.access_time_rounded,
                            label: "Time",
                            value: selectedTime.format(ctx),
                            onTap: () async {
                              final picked = await showTimePicker(
                                context: ctx,
                                initialTime: selectedTime,
                              );
                              if (picked != null) {
                                setModal(() => selectedTime = picked);
                              }
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),
                    _inputField(venueCtrl, "Venue", "e.g. Main Ground",
                        Icons.location_on_rounded),

                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (teamA == null || teamB == null) {
                            _snack("Please select both teams",
                                color: Colors.red);
                            return;
                          }
                          if (teamA == teamB) {
                            _snack("Teams must be different",
                                color: Colors.red);
                            return;
                          }

                          final sport = _sports.firstWhere(
                                (s) => s['id'] == selectedSportId,
                          );

                          // Format date
                          const months = [
                            'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                            'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
                          ];
                          final dateStr =
                              "${selectedDate.day} ${months[selectedDate.month - 1]} ${selectedDate.year}";

                          // Format time
                          final hour = selectedTime.hourOfPeriod == 0
                              ? 12
                              : selectedTime.hourOfPeriod;
                          final minute = selectedTime.minute
                              .toString()
                              .padLeft(2, '0');
                          final period = selectedTime.period ==
                              DayPeriod.am
                              ? 'AM'
                              : 'PM';
                          final timeStr = "$hour:$minute $period";

                          // ✅ ADD TO LIST
                          setState(() {
                            _matches.add({
                              "id": _matches.length + 1,
                              "sportId": selectedSportId,
                              "sportName": sport['name'],
                              "sportIcon": sport['icon'],
                              "sportColor": sport['color'],
                              "teamA": teamA,
                              "teamB": teamB,
                              "date": dateStr,
                              "time": timeStr,
                              "venue": venueCtrl.text.trim().isEmpty
                                  ? "Main Ground"
                                  : venueCtrl.text.trim(),
                              "status": "Scheduled",
                              "scoreA": null,
                              "scoreB": null,
                              "winner": null,
                            });
                          });

                          Navigator.pop(ctx);
                          _snack("Match scheduled: $teamA vs $teamB",
                              color: Colors.green);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primary,
                          padding:
                          const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.check_circle_rounded,
                            color: Colors.white, size: 18),
                        label: const Text(
                          "Schedule Match",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // HELPERS
  // ============================================================
  Widget _sheetHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  Widget _pickerTile({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: _primary),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 9.5,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dropdownContainer<T>({
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required Function(T?) onChanged,
    String? hint,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          hint: hint != null
              ? Text(hint,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ))
              : null,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: _primary,
          ),
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 13,
          ),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _inputField(
      TextEditingController ctrl,
      String label,
      String hint,
      IconData icon, {
        TextInputType keyboard = TextInputType.text,
      }) {
    return TextField(
      controller: ctrl,
      keyboardType: keyboard,
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 12),
        labelStyle: const TextStyle(fontSize: 12),
        prefixIcon: Icon(icon, color: _primary, size: 18),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primary, width: 1.4),
        ),
      ),
    );
  }
}