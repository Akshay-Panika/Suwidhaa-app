import 'package:flutter/material.dart';

class SchoolMeetingScreen extends StatefulWidget {
  const SchoolMeetingScreen({super.key});

  @override
  State<SchoolMeetingScreen> createState() => _SchoolMeetingScreenState();
}

class _SchoolMeetingScreenState extends State<SchoolMeetingScreen>
    with SingleTickerProviderStateMixin {
  // ==================== TAB ====================
  late TabController _tabController;

  // ==================== FILTER ====================
  String _typeFilter = "All"; // All | Today | Upcoming | Past

  // ==================== MEETINGS DATA ====================
  final List<Map<String, dynamic>> _meetings = [
    {
      "id": "MT001",
      "title": "Parent-Teacher Meeting",
      "description":
      "Discuss student progress and academic performance for Q3.",
      "type": "PTM",
      "date": "25 Sep 2025",
      "time": "10:00 AM",
      "duration": "60 min",
      "venue": "Auditorium Hall",
      "mode": "In-Person",
      "status": "Upcoming",
      "organizer": "Principal Sharma",
      "participants": ["Parents", "Class Teachers", "Principal"],
      "attendees": 45,
      "maxSeats": 60,
      "rsvp": "Accepted",
      "color": Colors.indigo,
      "link": "",
      "agenda": [
        "Welcome note by Principal",
        "Subject-wise progress review",
        "Parent feedback session",
        "Q&A and closing",
      ],
    },
    {
      "id": "MT002",
      "title": "Maths Department Review",
      "description": "Monthly review of Maths syllabus & test scores.",
      "type": "Department",
      "date": "23 Sep 2025",
      "time": "02:00 PM",
      "duration": "45 min",
      "venue": "Google Meet",
      "mode": "Online",
      "status": "Today",
      "organizer": "HOD - Maths",
      "participants": ["Maths Teachers"],
      "attendees": 8,
      "maxSeats": 10,
      "rsvp": "Pending",
      "color": Colors.teal,
      "link": "https://meet.google.com/abc-defg-hij",
      "agenda": [
        "Chapter-wise completion status",
        "Upcoming unit test planning",
        "Remedial class schedule",
      ],
    },
    {
      "id": "MT003",
      "title": "Annual Day Planning",
      "description": "Committee meeting for Annual Day event planning.",
      "type": "Event",
      "date": "28 Sep 2025",
      "time": "11:30 AM",
      "duration": "90 min",
      "venue": "Conference Room 2",
      "mode": "In-Person",
      "status": "Upcoming",
      "organizer": "Vice Principal",
      "participants": ["Event Committee"],
      "attendees": 12,
      "maxSeats": 15,
      "rsvp": "Pending",
      "color": Colors.orange,
      "link": "",
      "agenda": [
        "Theme finalization",
        "Budget approval",
        "Program schedule",
        "Volunteer allocation",
      ],
    },
    {
      "id": "MT004",
      "title": "Staff General Meeting",
      "description": "Monthly staff meeting for announcements & updates.",
      "type": "Staff",
      "date": "20 Sep 2025",
      "time": "03:00 PM",
      "duration": "60 min",
      "venue": "Staff Room",
      "mode": "In-Person",
      "status": "Past",
      "organizer": "Principal Sharma",
      "participants": ["All Staff"],
      "attendees": 38,
      "maxSeats": 40,
      "rsvp": "Accepted",
      "color": Colors.blueGrey,
      "link": "",
      "agenda": [
        "Fee collection status",
        "New admission updates",
        "Exam schedule",
      ],
    },
    {
      "id": "MT005",
      "title": "Science Fair Committee",
      "description": "Discussion on Science Fair 2025 organization.",
      "type": "Event",
      "date": "15 Sep 2025",
      "time": "09:00 AM",
      "duration": "45 min",
      "venue": "Lab 3",
      "mode": "In-Person",
      "status": "Past",
      "organizer": "HOD - Science",
      "participants": ["Science Teachers"],
      "attendees": 6,
      "maxSeats": 8,
      "rsvp": "Accepted",
      "color": Colors.purple,
      "link": "",
      "agenda": [
        "Project categories",
        "Judging criteria",
        "Prizes & certificates",
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ==================== HELPERS ====================
  List<Map<String, dynamic>> get _upcomingMeetings =>
      _meetings.where((m) => m['status'] != "Past").toList()
        ..sort((a, b) {
          // Today first, then Upcoming
          final ta = a['status'] == "Today" ? 0 : 1;
          final tb = b['status'] == "Today" ? 0 : 1;
          return ta.compareTo(tb);
        });

  List<Map<String, dynamic>> get _pastMeetings =>
      _meetings.where((m) => m['status'] == "Past").toList();

  List<Map<String, dynamic>> get _filteredUpcoming {
    if (_typeFilter == "All") return _upcomingMeetings;
    if (_typeFilter == "Today")
      return _upcomingMeetings.where((m) => m['status'] == "Today").toList();
    if (_typeFilter == "Upcoming")
      return _upcomingMeetings.where((m) => m['status'] == "Upcoming").toList();
    return _upcomingMeetings;
  }

  Color _statusColor(String s) {
    switch (s) {
      case "Today":
        return Colors.red;
      case "Upcoming":
        return Colors.blue;
      case "Past":
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  Color _rsvpColor(String r) {
    switch (r) {
      case "Accepted":
        return Colors.green;
      case "Declined":
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  IconData _modeIcon(String m) {
    return m == "Online" ? Icons.videocam_rounded : Icons.location_on_rounded;
  }

  void _snack(String msg, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        backgroundColor: color ?? Colors.green,
      ),
    );
  }

  // ==================== RSVP ====================
  void _updateRsvp(Map<String, dynamic> m, String rsvp) {
    setState(() => m['rsvp'] = rsvp);
    _snack("RSVP updated: $rsvp", color: _rsvpColor(rsvp));
  }

  // ==================== DETAIL SHEET ====================
  void _showMeetingDetail(Map<String, dynamic> m) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
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
                  width: 45,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Type + Status
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: (m['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(m['type'] as String,
                        style: TextStyle(
                          fontSize: 11,
                          color: m['color'] as Color,
                          fontWeight: FontWeight.w700,
                        )),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _statusColor(m['status'] as String)
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(m['status'] as String,
                        style: TextStyle(
                          fontSize: 11,
                          color: _statusColor(m['status'] as String),
                          fontWeight: FontWeight.w700,
                        )),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Title
              Text(m['title'] as String,
                  style: const TextStyle(
                      fontSize: 19, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text(m['description'] as String,
                  style: TextStyle(
                      fontSize: 13, color: Colors.grey[700], height: 1.4)),
              const SizedBox(height: 18),

              // Info grid
              _infoTile(Icons.calendar_today_rounded, "Date",
                  m['date'] as String),
              _infoTile(Icons.access_time_rounded, "Time",
                  "${m['time']} • ${m['duration']}"),
              _infoTile(_modeIcon(m['mode'] as String), "Mode",
                  m['mode'] as String),
              _infoTile(Icons.location_on_rounded, "Venue",
                  m['venue'] as String),
              _infoTile(Icons.person_rounded, "Organizer",
                  m['organizer'] as String),
              _infoTile(Icons.people_alt_rounded, "Attendees",
                  "${m['attendees']} / ${m['maxSeats']} seats"),

              const SizedBox(height: 16),

              // Participants
              const Text("Participants",
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (m['participants'] as List)
                    .map((p) => Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.indigo.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color:
                        Colors.indigo.withOpacity(0.2)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.person_rounded,
                          size: 12, color: Colors.indigo),
                      const SizedBox(width: 4),
                      Text(p as String,
                          style: const TextStyle(
                              fontSize: 11,
                              color: Colors.indigo,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ))
                    .toList(),
              ),

              const SizedBox(height: 18),

              // Agenda
              const Text("Agenda",
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              ...(m['agenda'] as List).asMap().entries.map((e) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.indigo.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text("${e.key + 1}",
                              style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.indigo,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(e.value as String,
                            style: const TextStyle(
                                fontSize: 12.5,
                                color: Colors.black87,
                                height: 1.4)),
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 18),

              // RSVP buttons (only for non-past)
              if (m['status'] != "Past") ...[
                const Text("Your RSVP",
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
                Row(
                  children: ["Accepted", "Pending", "Declined"]
                      .map((r) {
                    final sel = m['rsvp'] == r;
                    final c = _rsvpColor(r);
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                            right: r == "Declined" ? 0 : 8),
                        child: InkWell(
                          onTap: () {
                            _updateRsvp(m, r);
                            Navigator.pop(context);
                          },
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10),
                            decoration: BoxDecoration(
                              color: sel
                                  ? c.withOpacity(0.1)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: sel ? c : Colors.grey.shade300,
                                width: sel ? 1.5 : 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  r == "Accepted"
                                      ? Icons.check_circle_rounded
                                      : r == "Declined"
                                      ? Icons.cancel_rounded
                                      : Icons.help_outline_rounded,
                                  size: 18,
                                  color: sel ? c : Colors.grey,
                                ),
                                const SizedBox(height: 4),
                                Text(r,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: sel
                                          ? c
                                          : Colors.grey.shade700,
                                      fontWeight: sel
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
              ],

              // Action buttons
              Row(
                children: [
                  if (m['mode'] == "Online" &&
                      m['status'] != "Past") ...[
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _snack("Joining meeting...");
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding:
                          const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.videocam_rounded,
                            color: Colors.white, size: 18),
                        label: const Text("Join Meeting",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _snack("Reminder set!");
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        side: const BorderSide(color: Colors.indigo),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(
                          Icons.notifications_active_rounded,
                          color: Colors.indigo,
                          size: 18),
                      label: const Text("Remind",
                          style: TextStyle(
                              color: Colors.indigo,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.indigo, size: 14),
          ),
          const SizedBox(width: 10),
          Text(label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          const Spacer(),
          Flexible(
            child: Text(value,
                style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w600),
                textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }

  // ==================== CREATE MEETING SHEET ====================
  void _showCreateMeetingSheet() {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final venueCtrl = TextEditingController();
    final linkCtrl = TextEditingController();
    String mode = "In-Person";
    String type = "Staff";
    DateTime? date;
    TimeOfDay? time;

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
              borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 45,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: const [
                      Icon(Icons.event_available_rounded,
                          color: Colors.indigo),
                      SizedBox(width: 8),
                      Text("Schedule Meeting",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 18),

                  _inputField(
                      controller: titleCtrl,
                      label: "Meeting Title",
                      hint: "e.g. Parent-Teacher Meeting",
                      icon: Icons.title_rounded),
                  const SizedBox(height: 12),
                  _inputField(
                      controller: descCtrl,
                      label: "Description",
                      hint: "Purpose of the meeting...",
                      icon: Icons.notes_rounded,
                      maxLines: 3),

                  const SizedBox(height: 14),
                  // Type
                  const Text("Meeting Type",
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                    ["Staff", "PTM", "Department", "Event", "Other"]
                        .map((t) => ChoiceChip(
                      label: Text(t),
                      selected: type == t,
                      onSelected: (_) =>
                          setModal(() => type = t),
                      selectedColor: Colors.indigo,
                      labelStyle: TextStyle(
                        color: type == t
                            ? Colors.white
                            : Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                      backgroundColor: Colors.white,
                      side: BorderSide(
                          color: Colors.grey.shade300),
                    ))
                        .toList(),
                  ),

                  const SizedBox(height: 14),
                  // Mode
                  const Text("Mode",
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Row(
                    children: ["In-Person", "Online"].map((m) {
                      final sel = mode == m;
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                              right: m == "Online" ? 0 : 8),
                          child: InkWell(
                            onTap: () => setModal(() => mode = m),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12),
                              decoration: BoxDecoration(
                                color: sel
                                    ? Colors.indigo.withOpacity(0.08)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: sel
                                      ? Colors.indigo
                                      : Colors.grey.shade300,
                                  width: sel ? 1.5 : 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    m == "Online"
                                        ? Icons.videocam_rounded
                                        : Icons.location_on_rounded,
                                    size: 16,
                                    color: sel
                                        ? Colors.indigo
                                        : Colors.grey,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(m,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: sel
                                            ? Colors.indigo
                                            : Colors.grey.shade700,
                                        fontWeight: sel
                                            ? FontWeight.w700
                                            : FontWeight.w500,
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 14),
                  // Venue/Link
                  if (mode == "In-Person")
                    _inputField(
                        controller: venueCtrl,
                        label: "Venue",
                        hint: "e.g. Conference Room 2",
                        icon: Icons.location_on_rounded)
                  else
                    _inputField(
                        controller: linkCtrl,
                        label: "Meeting Link",
                        hint: "https://meet.google.com/...",
                        icon: Icons.link_rounded),

                  const SizedBox(height: 14),
                  // Date + Time
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: ctx,
                              initialDate:
                              date ?? DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now()
                                  .add(const Duration(days: 365)),
                              builder: (c, child) => Theme(
                                data: Theme.of(c).copyWith(
                                  colorScheme: const ColorScheme.light(
                                      primary: Colors.indigo),
                                ),
                                child: child!,
                              ),
                            );
                            if (picked != null)
                              setModal(() => date = picked);
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 14),
                            decoration: BoxDecoration(
                              color: date != null
                                  ? Colors.indigo.withOpacity(0.08)
                                  : Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: date != null
                                    ? Colors.indigo.withOpacity(0.4)
                                    : Colors.grey.shade200,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.calendar_today_rounded,
                                    color: date != null
                                        ? Colors.indigo
                                        : Colors.grey,
                                    size: 16),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    date == null
                                        ? "Select Date"
                                        : "${date!.day}/${date!.month}/${date!.year}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: date != null
                                          ? Colors.indigo
                                          : Colors.grey.shade700,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final picked = await showTimePicker(
                              context: ctx,
                              initialTime:
                              time ?? TimeOfDay.now(),
                              builder: (c, child) => Theme(
                                data: Theme.of(c).copyWith(
                                  colorScheme: const ColorScheme.light(
                                      primary: Colors.indigo),
                                ),
                                child: child!,
                              ),
                            );
                            if (picked != null)
                              setModal(() => time = picked);
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 14),
                            decoration: BoxDecoration(
                              color: time != null
                                  ? Colors.indigo.withOpacity(0.08)
                                  : Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: time != null
                                    ? Colors.indigo.withOpacity(0.4)
                                    : Colors.grey.shade200,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.access_time_rounded,
                                    color: time != null
                                        ? Colors.indigo
                                        : Colors.grey,
                                    size: 16),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    time == null
                                        ? "Select Time"
                                        : time!.format(ctx),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: time != null
                                          ? Colors.indigo
                                          : Colors.grey.shade700,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (titleCtrl.text.isEmpty) {
                          _snack("Please enter meeting title",
                              color: Colors.red);
                          return;
                        }
                        if (date == null || time == null) {
                          _snack("Please select date & time",
                              color: Colors.red);
                          return;
                        }

                        const months = [
                          "Jan", "Feb", "Mar", "Apr", "May", "Jun",
                          "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
                        ];
                        final dateStr =
                            "${date!.day} ${months[date!.month - 1]} ${date!.year}";

                        setState(() {
                          _meetings.insert(0, {
                            "id": "MT${DateTime.now().millisecondsSinceEpoch}",
                            "title": titleCtrl.text,
                            "description": descCtrl.text.isEmpty
                                ? "No description"
                                : descCtrl.text,
                            "type": type,
                            "date": dateStr,
                            "time": time!.format(ctx),
                            "duration": "60 min",
                            "venue": mode == "Online"
                                ? "Online Meeting"
                                : (venueCtrl.text.isEmpty
                                ? "TBD"
                                : venueCtrl.text),
                            "mode": mode,
                            "status": "Upcoming",
                            "organizer": "You",
                            "participants": [type],
                            "attendees": 0,
                            "maxSeats": 30,
                            "rsvp": "Pending",
                            "color": Colors.indigo,
                            "link": linkCtrl.text,
                            "agenda": ["Agenda to be added"],
                          });
                        });
                        Navigator.pop(ctx);
                        _tabController.animateTo(0);
                        _snack("Meeting scheduled successfully!");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        padding:
                        const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.check_rounded,
                          color: Colors.white, size: 18),
                      label: const Text("Schedule Meeting",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14)),
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

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 13),
        labelStyle: const TextStyle(fontSize: 12),
        prefixIcon: Icon(icon, color: Colors.indigo, size: 18),
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
          borderSide: const BorderSide(color: Colors.indigo, width: 1.4),
        ),
      ),
    );
  }

  // ==================== BUILD ====================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text("Meetings",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
        actions: [
          IconButton(
            tooltip: "Schedule Meeting",
            onPressed: _showCreateMeetingSheet,
            icon: const Icon(Icons.add_circle_outline_rounded),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle:
          const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          tabs: const [
            Tab(text: "Upcoming"),
            Tab(text: "Past"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildUpcomingTab(),
          _buildPastTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateMeetingSheet,
        backgroundColor: Colors.indigo,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text("Schedule",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }

  // ==================== TAB 1: UPCOMING ====================
  Widget _buildUpcomingTab() {
    return Column(
      children: [
        // Filter chips
        Container(
          color: Colors.white,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
              horizontal: 14, vertical: 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ["All", "Today", "Upcoming"].map((f) {
                final sel = _typeFilter == f;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(f),
                    selected: sel,
                    onSelected: (_) =>
                        setState(() => _typeFilter = f),
                    selectedColor: Colors.indigo,
                    labelStyle: TextStyle(
                      color: sel ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: _filteredUpcoming.isEmpty
              ? _emptyState("No meetings scheduled")
              : ListView.separated(
            padding: const EdgeInsets.all(14),
            itemCount: _filteredUpcoming.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) =>
                _buildMeetingTile(_filteredUpcoming[index]),
          ),
        ),
      ],
    );
  }

  // ==================== TAB 2: PAST ====================
  Widget _buildPastTab() {
    if (_pastMeetings.isEmpty) {
      return _emptyState("No past meetings");
    }
    return ListView.separated(
      padding: const EdgeInsets.all(14),
      itemCount: _pastMeetings.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) =>
          _buildMeetingTile(_pastMeetings[index], isPast: true),
    );
  }

  // ==================== MEETING TILE ====================
  Widget _buildMeetingTile(Map<String, dynamic> m, {bool isPast = false}) {
    final status = m['status'] as String;
    final sc = _statusColor(status);
    final rc = _rsvpColor(m['rsvp'] as String);
    final color = m['color'] as Color;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _showMeetingDetail(m),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            // Top color strip
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(14)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Date badge
                      Container(
                        width: 46,
                        padding:
                        const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Text(
                              (m['date'] as String).split(' ')[0],
                              style: TextStyle(
                                fontSize: 18,
                                color: color,
                                fontWeight: FontWeight.w800,
                                height: 1,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              (m['date'] as String).split(' ')[1],
                              style: TextStyle(
                                fontSize: 10,
                                color: color,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(m['title'] as String,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.access_time_rounded,
                                    size: 11, color: Colors.grey[600]),
                                const SizedBox(width: 3),
                                Text(m['time'] as String,
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey[600])),
                                const SizedBox(width: 8),
                                Icon(
                                  _modeIcon(m['mode'] as String),
                                  size: 11,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 3),
                                Text(m['mode'] as String,
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey[600])),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Status badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: sc.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(status,
                            style: TextStyle(
                              fontSize: 10,
                              color: sc,
                              fontWeight: FontWeight.w700,
                            )),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Description
                  Text(m['description'] as String,
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey[700]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 10),
                  // Bottom row: venue + attendees + RSVP
                  Row(
                    children: [
                      Icon(Icons.location_on_rounded,
                          size: 12, color: Colors.grey[600]),
                      const SizedBox(width: 3),
                      Flexible(
                        child: Text(m['venue'] as String,
                            style: TextStyle(
                                fontSize: 11, color: Colors.grey[600]),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ),
                      const Spacer(),
                      Icon(Icons.people_alt_rounded,
                          size: 12, color: Colors.grey[600]),
                      const SizedBox(width: 3),
                      Text("${m['attendees']}",
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey[600])),
                      if (!isPast) ...[
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: rc.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(m['rsvp'] as String,
                              style: TextStyle(
                                  fontSize: 10,
                                  color: rc,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState(String msg) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.event_busy_rounded,
              size: 60, color: Colors.grey.shade400),
          const SizedBox(height: 10),
          Text(msg,
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}