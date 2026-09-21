import 'package:flutter/material.dart';

class SpringfieldHighSchoolScreen extends StatefulWidget {
  const SpringfieldHighSchoolScreen({super.key});

  @override
  State<SpringfieldHighSchoolScreen> createState() =>
      _SpringfieldHighSchoolScreenState();
}

class _SpringfieldHighSchoolScreenState
    extends State<SpringfieldHighSchoolScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // ============================================================
  // STATIC DATA — no allocations at app start
  // ============================================================
  static const Map<String, String> _school = {
    "name": "Springfield High School",
    "tagline": "Excellence in Education Since 1985",
    "type": "Co-Educational • CBSE",
    "code": "SCH-2025-001",
    "principal": "Dr. Rajesh Sharma",
    "address": "123 Education Lane, Springfield, Mumbai - 400001",
    "phone": "+91 22 1234 5678",
    "email": "info@springfieldhigh.edu",
    "website": "www.springfieldhigh.edu",
    "session": "2025-2026",
    "rating": "4.8",
    "reviews": "2450",
    "accreditation": "NAAC A+",
  };

  static const List<Map<String, Object>> _stats = [
    {"label": "Students", "value": "1,240", "icon": Icons.people_alt_rounded, "color": Colors.indigo},
    {"label": "Teachers", "value": "82", "icon": Icons.school_rounded, "color": Colors.teal},
    {"label": "Classes", "value": "42", "icon": Icons.class_rounded, "color": Colors.orange},
    {"label": "Years", "value": "40+", "icon": Icons.emoji_events_rounded, "color": Colors.purple},
  ];

  static const List<Map<String, Object>> _facilities = [
    {"title": "Smart Classrooms", "desc": "42 digital rooms", "icon": Icons.smart_display_rounded, "color": Colors.indigo},
    {"title": "Science Labs", "desc": "Phy • Chem • Bio", "icon": Icons.science_rounded, "color": Colors.teal},
    {"title": "Library", "desc": "15,000+ books", "icon": Icons.menu_book_rounded, "color": Colors.brown},
    {"title": "Computer Lab", "desc": "80 high-end PCs", "icon": Icons.computer_rounded, "color": Colors.blue},
    {"title": "Sports Ground", "desc": "Football • Cricket", "icon": Icons.sports_soccer_rounded, "color": Colors.green},
    {"title": "Auditorium", "desc": "500-seat A/C hall", "icon": Icons.theater_comedy_rounded, "color": Colors.deepPurple},
    {"title": "Transport", "desc": "24 GPS buses", "icon": Icons.directions_bus_rounded, "color": Colors.amber},
    {"title": "Medical Room", "desc": "Full-time nurse", "icon": Icons.local_hospital_rounded, "color": Colors.red},
  ];

  static const List<Map<String, Object>> _faculty = [
    {"name": "Dr. Rajesh Sharma", "role": "Principal", "subject": "Administration", "exp": "25 yrs", "color": Colors.indigo},
    {"name": "Mrs. Sunita Verma", "role": "Vice Principal", "subject": "English", "exp": "20 yrs", "color": Colors.teal},
    {"name": "Mr. Ahmed Khan", "role": "HOD - Mathematics", "subject": "Mathematics", "exp": "15 yrs", "color": Colors.orange},
    {"name": "Ms. Priya Sharma", "role": "HOD - Science", "subject": "Physics", "exp": "12 yrs", "color": Colors.purple},
    {"name": "Mr. Ravi Kumar", "role": "HOD - Social Studies", "subject": "History", "exp": "14 yrs", "color": Colors.brown},
    {"name": "Ms. Neha Verma", "role": "HOD - Computer", "subject": "Computer Science", "exp": "10 yrs", "color": Colors.blue},
  ];

  static const List<Map<String, Object>> _achievements = [
    {"title": "Best CBSE School 2024", "desc": "By Education Council", "icon": Icons.emoji_events_rounded, "color": Colors.amber, "year": "2024"},
    {"title": "100% Board Results", "desc": "5 consecutive years", "icon": Icons.workspace_premium_rounded, "color": Colors.green, "year": "2025"},
    {"title": "National Sports Champion", "desc": "State Cricket Winners", "icon": Icons.sports_cricket_rounded, "color": Colors.orange, "year": "2025"},
    {"title": "Science Olympiad Gold", "desc": "3 national medals", "icon": Icons.science_rounded, "color": Colors.indigo, "year": "2025"},
  ];

  static const List<Map<String, Object>> _contacts = [
    {"title": "Admissions", "person": "Mrs. Kavita Singh", "phone": "+91 22 1234 5679", "icon": Icons.how_to_reg_rounded, "color": Colors.green},
    {"title": "Accounts", "person": "Mr. Suresh Patel", "phone": "+91 22 1234 5680", "icon": Icons.payments_rounded, "color": Colors.teal},
    {"title": "Transport", "person": "Mr. Rajan Yadav", "phone": "+91 22 1234 5681", "icon": Icons.directions_bus_rounded, "color": Colors.amber},
    {"title": "Emergency", "person": "24x7 Support", "phone": "+91 22 1234 5699", "icon": Icons.sos_rounded, "color": Colors.red},
  ];

  // ============================================================
  // FILTER STATE
  // ============================================================
  String _facultyFilter = "All";
  String _facilityFilter = "All";
  String _achievementYearFilter = "All";

  List<String> get _facultySubjects =>
      ["All", ...{for (final f in _faculty) f["subject"] as String}];

  List<String> get _facilityCategories {
    // Simple grouping by broad category
    return const ["All", "Academic", "Sports", "Support"];
  }

  List<String> get _achievementYears =>
      ["All", ...{for (final a in _achievements) a["year"] as String}];

  List<Map<String, Object>> get _filteredFaculty {
    if (_facultyFilter == "All") return _faculty;
    return _faculty.where((f) => f["subject"] == _facultyFilter).toList();
  }

  List<Map<String, Object>> get _filteredFacilities {
    if (_facilityFilter == "All") return _facilities;
    return _facilities.where((f) {
      final t = f["title"] as String;
      switch (_facilityFilter) {
        case "Academic":
          return t.contains("Class") || t.contains("Lab") || t.contains("Library");
        case "Sports":
          return t.contains("Sports");
        case "Support":
          return t.contains("Transport") || t.contains("Medical") || t.contains("Auditorium");
        default:
          return true;
      }
    }).toList();
  }

  List<Map<String, Object>> get _filteredAchievements {
    if (_achievementYearFilter == "All") return _achievements;
    return _achievements.where((a) => a["year"] == _achievementYearFilter).toList();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _snack(String msg, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        backgroundColor: color ?? Colors.indigo,
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
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          _buildSliverAppBar(),
          SliverToBoxAdapter(child: _buildHeaderCard()),
          SliverPersistentHeader(
            pinned: true,
            delegate: _TabBarDelegate(
              TabBar(
                controller: _tabController,
                indicatorColor: Colors.indigo,
                labelColor: Colors.indigo,
                unselectedLabelColor: Colors.grey.shade600,
                labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                tabs: const [
                  Tab(text: "Overview"),
                  Tab(text: "Faculty"),
                  Tab(text: "Contact"),
                ],
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildOverviewTab(),
            _buildFacultyTab(),
            _buildContactTab(),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SLIVER APP BAR
  // ============================================================
  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 170,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.indigo,
      foregroundColor: Colors.white,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_ios),
      ),
      actions: [
        IconButton(
          tooltip: "Share",
          onPressed: () => _snack("Sharing school profile..."),
          icon: const Icon(Icons.share_rounded),
        ),
        IconButton(
          tooltip: "Bookmark",
          onPressed: () => _snack("Added to favorites", color: Colors.green),
          icon: const Icon(Icons.bookmark_border_rounded),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.indigo, Color(0xFF3F51B5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Center(
                          child: Icon(Icons.school_rounded,
                              color: Colors.indigo, size: 30),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _school["name"]!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 3),
                            Text(
                              _school["tagline"]!,
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 11),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.amber,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.star_rounded,
                                          color: Colors.white, size: 10),
                                      const SizedBox(width: 2),
                                      Text(
                                        _school["rating"]!,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "${_school["reviews"]} reviews",
                                  style: const TextStyle(
                                      color: Colors.white70, fontSize: 10),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HEADER CARD — scrollable via Wrap (no overflow on small screens)
  // ============================================================
  Widget _buildHeaderCard() {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            _infoRow(Icons.tag_rounded, "School Code", _school["code"]!),
            _divider(),
            _infoRow(Icons.verified_rounded, "Accreditation",
                _school["accreditation"]!),
            _divider(),
            _infoRow(Icons.category_rounded, "Type", _school["type"]!),
            _divider(),
            _infoRow(Icons.event_rounded, "Session", _school["session"]!),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
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
          const SizedBox(width: 12),
          Text(label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w600),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() =>
      Divider(height: 1, color: Colors.grey.shade100, indent: 40);

  // ============================================================
  // FILTER CHIP ROW (reusable)
  // ============================================================
  Widget _filterRow({
    required List<String> options,
    required String selected,
    required ValueChanged<String> onSelected,
  }) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: options.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final opt = options[i];
          final isSelected = opt == selected;
          return ChoiceChip(
            label: Text(opt, style: const TextStyle(fontSize: 12)),
            selected: isSelected,
            onSelected: (_) => onSelected(opt),
            selectedColor: Colors.indigo.withOpacity(0.15),
            labelStyle: TextStyle(
              color: isSelected ? Colors.indigo : Colors.grey[700],
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
            side: BorderSide(
              color: isSelected ? Colors.indigo : Colors.grey.shade300,
            ),
            backgroundColor: Colors.white,
          );
        },
      ),
    );
  }

  // ============================================================
  // TAB 1: OVERVIEW
  // ============================================================
  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // STATS — horizontal scroll so no overflow
          SizedBox(
            height: 92,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _stats.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) => SizedBox(
                width: 90,
                child: _statCard(_stats[i]),
              ),
            ),
          ),

          const SizedBox(height: 20),

          _sectionTitle("About School", Icons.info_rounded),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Text(
              "Springfield High School is a premier co-educational institution established in 1985, "
                  "affiliated to the Central Board of Secondary Education (CBSE). With over 40 years of "
                  "academic excellence, we nurture young minds through a holistic curriculum.\n\n"
                  "Our state-of-the-art infrastructure and highly qualified faculty have consistently "
                  "produced top rankers in board examinations and national competitions.",
              style: TextStyle(
                fontSize: 12.5,
                color: Colors.grey[800],
                height: 1.55,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // FACILITIES with filter
          _sectionTitle("Facilities", Icons.apartment_rounded),
          const SizedBox(height: 10),
          _filterRow(
            options: _facilityCategories,
            selected: _facilityFilter,
            onSelected: (v) => setState(() => _facilityFilter = v),
          ),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _filteredFacilities.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.6,
            ),
            itemBuilder: (context, i) =>
                _facilityCard(_filteredFacilities[i]),
          ),

          const SizedBox(height: 20),

          // ACHIEVEMENTS with year filter
          _sectionTitle("Achievements", Icons.emoji_events_rounded),
          const SizedBox(height: 10),
          _filterRow(
            options: _achievementYears,
            selected: _achievementYearFilter,
            onSelected: (v) => setState(() => _achievementYearFilter = v),
          ),
          const SizedBox(height: 10),
          ..._filteredAchievements.map(_achievementTile),

          const SizedBox(height: 20),

          // QUICK ACTIONS
          Row(
            children: [
              Expanded(
                child: _quickActionButton(
                  icon: Icons.call_rounded,
                  label: "Call",
                  color: Colors.green,
                  onTap: () => _snack("Calling school...", color: Colors.green),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _quickActionButton(
                  icon: Icons.email_rounded,
                  label: "Email",
                  color: Colors.blue,
                  onTap: () => _snack("Opening email..."),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _quickActionButton(
                  icon: Icons.map_rounded,
                  label: "Map",
                  color: Colors.red,
                  onTap: () => _snack("Opening map..."),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _quickActionButton(
                  icon: Icons.language_rounded,
                  label: "Website",
                  color: Colors.indigo,
                  onTap: () => _snack("Opening website..."),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ============================================================
  // TAB 2: FACULTY (with subject filter)
  // ============================================================
  Widget _buildFacultyTab() {
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.teal.withOpacity(0.06),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.teal.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.school_rounded,
                    color: Colors.teal, size: 22),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Meet Our Faculty",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700)),
                    SizedBox(height: 2),
                    Text("82 experienced educators",
                        style: TextStyle(
                            fontSize: 11, color: Colors.black54)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Filter chips
        _filterRow(
          options: _facultySubjects,
          selected: _facultyFilter,
          onSelected: (v) => setState(() => _facultyFilter = v),
        ),
        const SizedBox(height: 16),

        if (_filteredFaculty.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Text("No faculty matches the filter",
                  style: TextStyle(color: Colors.grey)),
            ),
          )
        else
          ..._filteredFaculty.map(_facultyCard),

        const SizedBox(height: 24),
      ],
    );
  }

  Widget _facultyCard(Map<String, Object> f) {
    final color = f["color"] as Color;
    final initials = (f["name"] as String)
        .replaceAll(RegExp(r'(Dr\.|Mr\.|Mrs\.|Ms\.)\s*'), '')
        .split(' ')
        .map((e) => e[0])
        .take(2)
        .join();

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: color.withOpacity(0.15),
            child: Text(
              initials,
              style: TextStyle(
                  fontSize: 16, color: color, fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(f["name"] as String,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(f["role"] as String,
                    style: TextStyle(
                        fontSize: 11,
                        color: color,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.book_rounded,
                        size: 11, color: Colors.grey[600]),
                    const SizedBox(width: 3),
                    Text(f["subject"] as String,
                        style: TextStyle(
                            fontSize: 10.5, color: Colors.grey[600])),
                    const SizedBox(width: 10),
                    Icon(Icons.workspace_premium_rounded,
                        size: 11, color: Colors.grey[600]),
                    const SizedBox(width: 3),
                    Text(f["exp"] as String,
                        style: TextStyle(
                            fontSize: 10.5, color: Colors.grey[600])),
                  ],
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => _snack("Contacting ${f["name"]}..."),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.mail_rounded, color: color, size: 16),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TAB 3: CONTACT
  // ============================================================
  Widget _buildContactTab() {
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.indigo, Color(0xFF3F51B5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.location_on_rounded,
                      color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text("Visit Us",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700)),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                _school["address"]!,
                style: const TextStyle(
                    color: Colors.white70, fontSize: 12, height: 1.4),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        _sectionTitle("Direct Contacts", Icons.contacts_rounded),
        const SizedBox(height: 10),
        ..._contacts.map(_contactTile),

        const SizedBox(height: 20),

        _sectionTitle("Office Hours", Icons.schedule_rounded),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              _officeRow("Monday - Friday", "8:00 AM - 4:00 PM"),
              _divider(),
              _officeRow("Saturday", "8:00 AM - 1:00 PM"),
              _divider(),
              _officeRow("Sunday", "Closed", color: Colors.red),
              _divider(),
              _officeRow("Holidays", "Closed", color: Colors.red),
            ],
          ),
        ),

        const SizedBox(height: 24),
      ],
    );
  }

  Widget _officeRow(String day, String time, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(day,
              style: TextStyle(fontSize: 12, color: Colors.grey[700])),
          Text(time,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: color ?? Colors.black87)),
        ],
      ),
    );
  }

  Widget _contactTile(Map<String, Object> c) {
    final color = c["color"] as Color;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(c["icon"] as IconData, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(c["title"] as String,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(c["person"] as String,
                    style: TextStyle(
                        fontSize: 11, color: Colors.grey[600])),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _snack("Calling ${c["phone"]}...",
                color: Colors.green),
            icon: const Icon(Icons.call_rounded,
                color: Colors.green, size: 18),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SHARED WIDGETS
  // ============================================================
  Widget _sectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: Colors.indigo.withOpacity(0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.indigo, size: 16),
        ),
        const SizedBox(width: 10),
        Text(title,
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.w700)),
      ],
    );
  }

  Widget _statCard(Map<String, Object> s) {
    final color = s["color"] as Color;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(s["icon"] as IconData, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            s["value"] as String,
            style: TextStyle(
                fontSize: 16, color: color, fontWeight: FontWeight.w800),
          ),
          Text(
            s["label"] as String,
            style: TextStyle(
                fontSize: 10,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _facilityCard(Map<String, Object> f) {
    final color = f["color"] as Color;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(f["icon"] as IconData, color: color, size: 18),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(f["title"] as String,
                  style: const TextStyle(
                      fontSize: 12.5, fontWeight: FontWeight.w700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 2),
              Text(f["desc"] as String,
                  style: TextStyle(
                      fontSize: 10.5, color: Colors.grey[600]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ],
          ),
        ],
      ),
    );
  }

  Widget _achievementTile(Map<String, Object> a) {
    final color = a["color"] as Color;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(a["icon"] as IconData, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(a["title"] as String,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(a["desc"] as String,
                    style: TextStyle(
                        fontSize: 11, color: Colors.grey[600])),
              ],
            ),
          ),
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(a["year"] as String,
                style: TextStyle(
                    fontSize: 10,
                    color: color,
                    fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  Widget _quickActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(label,
                style: TextStyle(
                    fontSize: 11,
                    color: color,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// STICKY TAB BAR DELEGATE
// ============================================================
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  _TabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox(
      height: minExtent,
      child: ColoredBox(color: Colors.white, child: tabBar),
    );
  }

  @override
  bool shouldRebuild(_TabBarDelegate oldDelegate) =>
      oldDelegate.tabBar != tabBar;
}