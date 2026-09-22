import 'package:flutter/material.dart';

class AnnualSportsMeetScreen extends StatefulWidget {
  const AnnualSportsMeetScreen({super.key});

  @override
  State<AnnualSportsMeetScreen> createState() =>
      _AnnualSportsMeetScreenState();
}

class _AnnualSportsMeetScreenState extends State<AnnualSportsMeetScreen> {
  // ============================================================
  // PRIMARY COLOR
  // ============================================================
  static const Color _primary = Colors.indigo;
  static const Color _primaryDark = Color(0xFF283593);

  // ============================================================
  // FILTER STATE
  // ============================================================
  String _sportFilter = "All";

  // ============================================================
  // EVENT INFO
  // ============================================================
  final Map<String, dynamic> _event = {
    "title": "Annual Sports Meet 2025",
    "startDate": "15 Oct",
    "endDate": "18 Oct 2025",
    "venue": "Springfield Sports Complex",
    "registrationDeadline": "10 Oct 2025",
    "status": "Upcoming",
  };

  // ============================================================
  // STATS
  // ============================================================
  final List<Map<String, dynamic>> _stats = [
    {"label": "Events", "value": "42", "color": _primary},
    {"label": "Athletes", "value": "850", "color": Colors.teal},
    {"label": "Teams", "value": "4", "color": Colors.orange},
    {"label": "Days", "value": "4", "color": Colors.purple},
  ];

  // ============================================================
  // SPORTS
  // ============================================================
  final List<Map<String, dynamic>> _sports = [
    {"name": "Cricket", "icon": Icons.sports_cricket_rounded, "color": Colors.green, "type": "Team"},
    {"name": "Football", "icon": Icons.sports_soccer_rounded, "color": Colors.blue, "type": "Team"},
    {"name": "Basketball", "icon": Icons.sports_basketball_rounded, "color": Colors.orange, "type": "Team"},
    {"name": "Athletics", "icon": Icons.directions_run_rounded, "color": Colors.red, "type": "Individual"},
    {"name": "Badminton", "icon": Icons.sports_tennis_rounded, "color": Colors.purple, "type": "Individual"},
    {"name": "Chess", "icon": Icons.sports_esports_rounded, "color": Colors.brown, "type": "Individual"},
  ];

  List<Map<String, dynamic>> get _filteredSports {
    if (_sportFilter == "All") return _sports;
    return _sports.where((s) => s['type'] == _sportFilter).toList();
  }

  // ============================================================
  // SCHEDULE
  // ============================================================
  final List<Map<String, dynamic>> _schedule = [
    {
      "day": "Day 1", "date": "15 Oct", "color": _primary,
      "events": [
        {"time": "08:00 AM", "title": "Opening Ceremony"},
        {"time": "10:00 AM", "title": "100m Sprint - Heats"},
        {"time": "02:00 PM", "title": "Cricket - Match 1"},
      ],
    },
    {
      "day": "Day 2", "date": "16 Oct", "color": Colors.teal,
      "events": [
        {"time": "09:00 AM", "title": "Football - Semi Finals"},
        {"time": "11:00 AM", "title": "Long Jump"},
      ],
    },
    {
      "day": "Day 3", "date": "17 Oct", "color": Colors.orange,
      "events": [
        {"time": "09:00 AM", "title": "Basketball - Finals"},
        {"time": "03:00 PM", "title": "Volleyball - Finals"},
      ],
    },
    {
      "day": "Day 4", "date": "18 Oct", "color": Colors.purple,
      "events": [
        {"time": "09:00 AM", "title": "Cricket - Grand Final"},
        {"time": "03:00 PM", "title": "Closing Ceremony"},
      ],
    },
  ];

  // ============================================================
  // MY EVENTS (Student)
  // ============================================================
  final List<Map<String, dynamic>> _myEvents = [
    {"sport": "Cricket", "role": "Batsman", "status": "Registered", "color": Colors.green},
    {"sport": "Athletics - 100m", "role": "Runner", "status": "Registered", "color": Colors.red},
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
      appBar: AppBar(
        elevation: 0,
        backgroundColor: _primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text("Sports Meet 2025",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _heroCard(),
            const SizedBox(height: 12),

            // Stats
            Row(
              children: _stats.map((s) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: s == _stats.last ? 0 : 6),
                    child: _compactStat(s),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // My Events
            if (_myEvents.isNotEmpty) ...[
              _sectionHeader("My Events", Icons.person_pin_rounded),
              const SizedBox(height: 8),
              ..._myEvents.map((e) => _myEventTile(e)),
              const SizedBox(height: 16),
            ],

            // Sports
            _sectionHeader("Sports", Icons.sports_rounded),
            const SizedBox(height: 8),
            _filterChips(
              options: ["All", "Team", "Individual"],
              selected: _sportFilter,
              onSelect: (v) => setState(() => _sportFilter = v),
            ),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _filteredSports.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 2.4,
              ),
              itemBuilder: (context, i) => _sportCard(_filteredSports[i]),
            ),

            const SizedBox(height: 16),

            // Schedule
            _sectionHeader("Schedule", Icons.schedule_rounded),
            const SizedBox(height: 10),
            ..._schedule.map((d) => _dayCard(d)),

            const SizedBox(height: 100),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showRegistrationSheet,
        backgroundColor: _primary,
        icon: const Icon(Icons.how_to_reg_rounded, color: Colors.white),
        label: const Text("Register",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
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
            right: -20, top: -20,
            child: Icon(Icons.sports_soccer_rounded,
                size: 100, color: Colors.white.withOpacity(0.08)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(_event['status'] as String,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700)),
              ),
              const SizedBox(height: 10),
              Text(_event['title'] as String,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.calendar_today_rounded,
                      color: Colors.white70, size: 12),
                  const SizedBox(width: 4),
                  Text("${_event['startDate']} - ${_event['endDate']}",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.location_on_rounded,
                      color: Colors.white70, size: 12),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(_event['venue'] as String,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.event_available_rounded,
                      color: Colors.amber, size: 12),
                  const SizedBox(width: 4),
                  Text("Register before ${_event['registrationDeadline']}",
                      style: const TextStyle(
                          color: Colors.amber,
                          fontSize: 11,
                          fontWeight: FontWeight.w700)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STAT
  // ============================================================
  Widget _compactStat(Map<String, dynamic> s) {
    final c = s['color'] as Color;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Text(s['value'] as String,
              style: TextStyle(
                  fontSize: 15, color: c, fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(s['label'] as String,
              style: TextStyle(fontSize: 9.5, color: Colors.grey[600]),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  // ============================================================
  // MY EVENT TILE
  // ============================================================
  Widget _myEventTile(Map<String, dynamic> e) {
    final c = e['color'] as Color;
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: c.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: c.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.sports_rounded, color: c, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(e['sport'] as String,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w700)),
                Text(e['role'] as String,
                    style: TextStyle(fontSize: 10, color: Colors.grey[600])),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(e['status'] as String,
                style: const TextStyle(
                    fontSize: 9.5,
                    color: Colors.green,
                    fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SPORT CARD
  // ============================================================
  Widget _sportCard(Map<String, dynamic> s) {
    final c = s['color'] as Color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: c.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(s['icon'] as IconData, color: c, size: 14),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(s['name'] as String,
                style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w700),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DAY CARD
  // ============================================================
  Widget _dayCard(Map<String, dynamic> d) {
    final c = d['color'] as Color;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: c,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(d['day'] as String,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w800)),
              ),
              const SizedBox(width: 8),
              Text(d['date'] as String,
                  style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 10),
          ...(d['events'] as List).map((e) {
            final ev = e as Map<String, dynamic>;
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Container(
                    width: 6, height: 6,
                    decoration: BoxDecoration(color: c, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 8),
                  Text(ev['time'] as String,
                      style: TextStyle(
                          fontSize: 10,
                          color: c,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(ev['title'] as String,
                        style: const TextStyle(
                            fontSize: 11.5, fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            );
          }),
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
        Text(title,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w700)),
      ],
    );
  }

  // ============================================================
  // FILTER CHIPS
  // ============================================================
  Widget _filterChips({
    required List<String> options,
    required String selected,
    required Function(String) onSelect,
  }) {
    return SizedBox(
      height: 32,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: options.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (context, i) {
          final o = options[i];
          final sel = selected == o;
          return InkWell(
            onTap: () => onSelect(o),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: sel ? _primary : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: sel ? _primary : Colors.grey.shade300,
                ),
              ),
              child: Text(o,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: sel ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w700,
                  )),
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // REGISTRATION SHEET
  // ============================================================
  void _showRegistrationSheet() {
    final nameCtrl = TextEditingController();
    final rollCtrl = TextEditingController();
    String selectedSport = _sports.first['name'] as String;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40, height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: const [
                      Icon(Icons.how_to_reg_rounded, color: _primary),
                      SizedBox(width: 8),
                      Text("Register for Event",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text("Deadline: ${_event['registrationDeadline']}",
                      style: const TextStyle(
                          fontSize: 11,
                          color: _primary,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 16),

                  _inputField(nameCtrl, "Full Name", "e.g. Aarav Sharma",
                      Icons.person_rounded),
                  const SizedBox(height: 10),
                  _inputField(rollCtrl, "Roll Number", "e.g. 24",
                      Icons.tag_rounded,
                      keyboard: TextInputType.number),
                  const SizedBox(height: 12),

                  const Text("Select Sport",
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedSport,
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down_rounded,
                            color: _primary),
                        style: const TextStyle(
                            color: Colors.black87, fontSize: 13),
                        items: _sports
                            .map((s) => DropdownMenuItem(
                          value: s['name'] as String,
                          child: Row(
                            children: [
                              Icon(s['icon'] as IconData,
                                  size: 16, color: s['color'] as Color),
                              const SizedBox(width: 10),
                              Text(s['name'] as String),
                            ],
                          ),
                        ))
                            .toList(),
                        onChanged: (v) => setModal(() => selectedSport = v!),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (nameCtrl.text.trim().isEmpty ||
                            rollCtrl.text.trim().isEmpty) {
                          _snack("Please fill all fields", color: Colors.red);
                          return;
                        }
                        Navigator.pop(ctx);
                        _snack("Registered for $selectedSport!",
                            color: Colors.green);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primary,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.check_circle_rounded,
                          color: Colors.white, size: 18),
                      label: const Text("Confirm Registration",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 13)),
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
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