import 'package:flutter/material.dart';

class TeacherSalaryScreen extends StatefulWidget {
  const TeacherSalaryScreen({super.key});

  @override
  State<TeacherSalaryScreen> createState() => _TeacherSalaryScreenState();
}

class _TeacherSalaryScreenState extends State<TeacherSalaryScreen>
    with SingleTickerProviderStateMixin {
  // ==================== YEAR FILTER ====================
  final List<String> _years = ["2025", "2024", "2023"];
  String _selectedYear = "2025";

  // ==================== PAGINATION ====================
  static const int _pageSize = 5;
  int _visibleCount = _pageSize;
  bool _isLoadingMore = false;

  // ==================== TAB ====================
  late TabController _tabController;

  // ==================== SEARCH & FILTER ====================
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = "";
  String _statusFilter = "All";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _searchCtrl.addListener(() {
      setState(() => _searchQuery = _searchCtrl.text.toLowerCase().trim());
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  // ==================== BANK DETAILS ====================
  final Map<String, dynamic> _bankDetails = {
    "bank": "State Bank of India",
    "accountNo": "XXXX XXXX 4521",
    "ifsc": "SBIN0001234",
    "branch": "Springfield Main",
  };

  // ==================== EARNINGS ====================
  final List<Map<String, dynamic>> _earnings = [
    {"label": "Basic Pay", "amount": 32000, "icon": Icons.account_balance_wallet_rounded, "color": Colors.indigo},
    {"label": "HRA", "amount": 8000, "icon": Icons.home_rounded, "color": Colors.teal},
    {"label": "DA", "amount": 4500, "icon": Icons.trending_up_rounded, "color": Colors.orange},
    {"label": "Bonus", "amount": 2500, "icon": Icons.card_giftcard_rounded, "color": Colors.pink},
  ];

  final List<Map<String, dynamic>> _deductions = [
    {"label": "PF", "amount": 1800},
    {"label": "Tax (TDS)", "amount": 1200},
    {"label": "Insurance", "amount": 500},
  ];

  int get _totalEarnings =>
      _earnings.fold(0, (s, e) => s + (e['amount'] as int));
  int get _totalDeductions =>
      _deductions.fold(0, (s, e) => s + (e['amount'] as int));
  int get _netSalary => _totalEarnings - _totalDeductions;

  // ==================== DATA ====================
  final Map<String, List<Map<String, dynamic>>> _monthlySalaryByYear = {
    "2025": [
      {"month": "September", "amount": 40000, "status": "Paid", "date": "30 Sep 2025", "remark": "Credited to SBI"},
      {"month": "August", "amount": 43500, "status": "Paid", "date": "31 Aug 2025", "remark": "Includes ₹2,500 bonus"},
      {"month": "July", "amount": 43500, "status": "Paid", "date": "31 Jul 2025", "remark": "-"},
      {"month": "June", "amount": 43500, "status": "Paid", "date": "30 Jun 2025", "remark": "-"},
      {"month": "May", "amount": 42000, "status": "Paid", "date": "31 May 2025", "remark": "-"},
      {"month": "April", "amount": 43500, "status": "Paid", "date": "30 Apr 2025", "remark": "-"},
      {"month": "March", "amount": 43500, "status": "Paid", "date": "31 Mar 2025", "remark": "-"},
      {"month": "February", "amount": 41000, "status": "Paid", "date": "28 Feb 2025", "remark": "-"},
      {"month": "January", "amount": 43500, "status": "Paid", "date": "31 Jan 2025", "remark": "-"},
    ],
    "2024": [
      {"month": "December", "amount": 43500, "status": "Paid", "date": "31 Dec 2024", "remark": "-"},
      {"month": "November", "amount": 43500, "status": "Paid", "date": "30 Nov 2024", "remark": "-"},
      {"month": "October", "amount": 42000, "status": "Paid", "date": "31 Oct 2024", "remark": "-"},
    ],
    "2023": [
      {"month": "December", "amount": 38000, "status": "Paid", "date": "31 Dec 2023", "remark": "-"},
      {"month": "November", "amount": 38000, "status": "Paid", "date": "30 Nov 2023", "remark": "-"},
    ],
  };

  // ==================== PENDING ====================
  final List<Map<String, dynamic>> _pendingSalary = [
    {"month": "October 2025", "amount": 43500, "status": "Pending", "dueDate": "31 Oct 2025", "daysLate": 0},
    {"month": "September Extra Class", "amount": 2500, "status": "Processing", "dueDate": "05 Oct 2025", "daysLate": 3},
  ];

  // ==================== EXTRA ====================
  final List<Map<String, dynamic>> _extraSalary = [
    {"title": "Extra Class - 10th Grade", "amount": 2500, "date": "22 Sep 2025", "status": "Approved", "type": "Teaching"},
    {"title": "Exam Invigilation", "amount": 1200, "date": "15 Sep 2025", "status": "Approved", "type": "Duty"},
    {"title": "Sports Meet Coordinator", "amount": 3000, "date": "10 Sep 2025", "status": "Paid", "type": "Event"},
    {"title": "Parent-Teacher Meeting", "amount": 800, "date": "05 Sep 2025", "status": "Paid", "type": "Meeting"},
  ];

  final List<Map<String, dynamic>> _extraRequests = [
    {"title": "Evening Tuition Batch", "amount": 5000, "date": "20 Sep 2025", "status": "Pending"},
    {"title": "Science Fair Judge", "amount": 1500, "date": "18 Sep 2025", "status": "Approved"},
    {"title": "Holiday Coaching Class", "amount": 4000, "date": "12 Sep 2025", "status": "Rejected"},
  ];

  // ==================== HELPERS ====================
  String _formatCurrency(num value) {
    final str = value.toString();
    if (str.length <= 3) return "₹ $str";
    final last3 = str.substring(str.length - 3);
    var rest = str.substring(0, str.length - 3);
    final buf = StringBuffer();
    while (rest.length > 2) {
      buf.write(",${rest.substring(rest.length - 2)}");
      rest = rest.substring(0, rest.length - 2);
    }
    buf.write(rest);
    return "₹ $buf,$last3";
  }

  // ==================== FILTERED ====================
  List<Map<String, dynamic>> get _filteredMonthly {
    var list = _monthlySalaryByYear[_selectedYear] ?? [];
    if (_searchQuery.isNotEmpty) {
      list = list.where((e) => (e['month'] as String).toLowerCase().contains(_searchQuery)).toList();
    }
    if (_statusFilter != "All") {
      list = list.where((e) => e['status'] == _statusFilter).toList();
    }
    return list;
  }

  List<Map<String, dynamic>> get _visibleMonthly =>
      _filteredMonthly.take(_visibleCount).toList();

  bool get _hasMore => _visibleCount < _filteredMonthly.length;

  int get _yearlyTotal =>
      (_monthlySalaryByYear[_selectedYear] ?? []).fold(0, (s, e) => s + (e['amount'] as int));
  int get _yearlyPaid => (_monthlySalaryByYear[_selectedYear] ?? [])
      .where((e) => e['status'] == "Paid")
      .fold(0, (s, e) => s + (e['amount'] as int));
  int get _yearlyPending => (_monthlySalaryByYear[_selectedYear] ?? [])
      .where((e) => e['status'] != "Paid")
      .fold(0, (s, e) => s + (e['amount'] as int));

  bool get _hasOverdue => _pendingSalary.any((e) => (e['daysLate'] as int) > 0);

  // ==================== LOAD MORE ====================
  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    setState(() => _isLoadingMore = true);
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() {
      _visibleCount = (_visibleCount + _pageSize).clamp(0, _filteredMonthly.length);
      _isLoadingMore = false;
    });
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Salary data refreshed"),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _onYearChanged(String? year) {
    if (year == null) return;
    setState(() {
      _selectedYear = year;
      _visibleCount = _pageSize;
      _statusFilter = "All";
    });
  }

  // ==================== BOTTOM SHEETS ====================
  void _showSalaryBreakdownSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _bottomSheetWrapper(
        title: "Earnings & Deductions",
        icon: Icons.pie_chart_rounded,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ..._earnings.map((e) => _rowItem(
              icon: e['icon'] as IconData,
              iconColor: e['color'] as Color,
              label: e['label'] as String,
              value: _formatCurrency(e['amount'] as int),
            )),
            const Divider(height: 20),
            ..._deductions.map((e) => _rowItem(
              icon: Icons.remove_circle_outline,
              iconColor: Colors.red,
              label: e['label'] as String,
              value: "- ${_formatCurrency(e['amount'] as int)}",
              valueColor: Colors.red,
            )),
            const Divider(height: 20),
            _rowItem(
              icon: Icons.account_balance_wallet_rounded,
              iconColor: Colors.indigo,
              label: "Net Salary",
              value: _formatCurrency(_netSalary),
              bold: true,
            ),
          ],
        ),
      ),
    );
  }

  void _showBankSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _bottomSheetWrapper(
        title: "Bank Details",
        icon: Icons.account_balance_rounded,
        child: Column(
          children: [
            _rowItem(icon: Icons.account_balance, iconColor: Colors.indigo,
                label: "Bank", value: _bankDetails['bank'] as String),
            _rowItem(icon: Icons.credit_card_rounded, iconColor: Colors.indigo,
                label: "Account", value: _bankDetails['accountNo'] as String),
            _rowItem(icon: Icons.qr_code_rounded, iconColor: Colors.indigo,
                label: "IFSC", value: _bankDetails['ifsc'] as String),
            _rowItem(icon: Icons.location_on_rounded, iconColor: Colors.indigo,
                label: "Branch", value: _bankDetails['branch'] as String),
          ],
        ),
      ),
    );
  }

  void _showPendingSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _bottomSheetWrapper(
        title: "Pending Salary",
        icon: Icons.hourglass_bottom_rounded,
        child: Column(
          children: _pendingSalary.map((e) => _buildPendingTile(e)).toList(),
        ),
      ),
    );
  }

  Widget _bottomSheetWrapper({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
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
              children: [
                Icon(icon, color: Colors.indigo, size: 22),
                const SizedBox(width: 8),
                Text(title,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 16),
            child,
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _rowItem({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    Color? valueColor,
    bool bold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(label,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: bold ? FontWeight.w700 : FontWeight.w500)),
          ),
          Text(value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
                color: valueColor ?? (bold ? Colors.indigo : Colors.black87),
              )),
        ],
      ),
    );
  }

  // ==================== REQUEST SHEET ====================
  void _showExtraSalaryRequestSheet() {
    final titleCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    final reasonCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
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
                    Icon(Icons.add_card_rounded, color: Colors.indigo),
                    SizedBox(width: 8),
                    Text("Request Extra Salary",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w700)),
                  ],
                ),
                const SizedBox(height: 18),
                _inputField(
                    controller: titleCtrl,
                    label: "Title / Reason",
                    hint: "e.g. Extra Class for 10th Grade",
                    icon: Icons.title_rounded),
                const SizedBox(height: 12),
                _inputField(
                    controller: amountCtrl,
                    label: "Amount (₹)",
                    hint: "e.g. 2500",
                    icon: Icons.currency_rupee_rounded,
                    keyboard: TextInputType.number),
                const SizedBox(height: 12),
                _inputField(
                    controller: reasonCtrl,
                    label: "Description",
                    hint: "Describe your work briefly...",
                    icon: Icons.notes_rounded,
                    maxLines: 3),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      if (titleCtrl.text.isEmpty || amountCtrl.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please fill title & amount"),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        return;
                      }
                      final amt = int.tryParse(amountCtrl.text) ?? 0;
                      setState(() {
                        _extraRequests.insert(0, {
                          "title": titleCtrl.text,
                          "amount": amt,
                          "date": "Today",
                          "status": "Pending",
                        });
                      });
                      Navigator.pop(ctx);
                      _tabController.animateTo(2);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Request submitted: ${titleCtrl.text}"),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    child: const Text("Submit Request",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14)),
                  ),
                ),
              ],
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
    TextInputType keyboard = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.indigo, size: 20),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.indigo, width: 1.4)),
      ),
    );
  }

  // ==================== SALARY DETAIL SHEET ====================
  void _showSalaryDetailSheet(Map<String, dynamic> item) {
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
              Text("${item['month']} $_selectedYear",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text("Paid on ${item['date']}",
                  style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.indigo.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Net Credited",
                        style:
                        TextStyle(fontSize: 13, color: Colors.black54)),
                    Text(_formatCurrency(item['amount'] as int),
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text("Breakdown",
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              ..._earnings.map((e) => _simpleRow(
                  e['label'] as String,
                  _formatCurrency(e['amount'] as int),
                  color: Colors.teal)),
              const Divider(height: 20),
              ..._deductions.map((e) => _simpleRow(
                  e['label'] as String,
                  "- ${_formatCurrency(e['amount'] as int)}",
                  color: Colors.red)),
              const Divider(height: 20),
              _simpleRow("Total", _formatCurrency(_netSalary), bold: true),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.share_rounded, size: 18),
                      label: const Text("Share"),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: Colors.indigo),
                        foregroundColor: Colors.indigo,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.download_rounded,
                          size: 18, color: Colors.white),
                      label: const Text("Download",
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _simpleRow(String label, String value,
      {Color? color, bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                  fontWeight: bold ? FontWeight.w700 : FontWeight.w500)),
          Text(value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
                color: color ?? Colors.black87,
              )),
        ],
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
        title: const Text("Salary",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
        actions: [
          IconButton(
            onPressed: _showExtraSalaryRequestSheet,
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
            Tab(text: "Monthly"),
            Tab(text: "Extra"),
            Tab(text: "Requests"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          RefreshIndicator(onRefresh: _refresh, child: _buildMonthlyTab()),
          RefreshIndicator(onRefresh: _refresh, child: _buildExtraSalaryTab()),
          RefreshIndicator(onRefresh: _refresh, child: _buildRequestsTab()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showExtraSalaryRequestSheet,
        backgroundColor: Colors.indigo,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text("Request",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }

  // ==================== TAB 1: MONTHLY (COMPACT) ====================
  Widget _buildMonthlyTab() {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        // ==== FIXED HEADER (non-scroll feel) ====
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ==== SUMMARY CARD (compact) ====
                _buildCompactSummaryCard(),

                const SizedBox(height: 12),

                // ==== QUICK ACTIONS ROW ====
                Row(
                  children: [
                    Expanded(
                      child: _quickAction(
                        icon: Icons.pie_chart_rounded,
                        label: "Breakdown",
                        color: Colors.indigo,
                        onTap: _showSalaryBreakdownSheet,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _quickAction(
                        icon: Icons.account_balance_rounded,
                        label: "Bank",
                        color: Colors.teal,
                        onTap: _showBankSheet,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _quickAction(
                        icon: Icons.hourglass_bottom_rounded,
                        label: "Pending",
                        color: Colors.orange,
                        badge: _pendingSalary.length,
                        onTap: _showPendingSheet,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // ==== YEARLY STATS (compact) ====
                _buildYearlyStatsRow(),

                const SizedBox(height: 16),

                // ==== SEARCH + YEAR ROW ====
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchCtrl,
                        style: const TextStyle(fontSize: 13),
                        decoration: InputDecoration(
                          hintText: "Search month...",
                          hintStyle: const TextStyle(fontSize: 13),
                          prefixIcon: const Icon(Icons.search_rounded,
                              color: Colors.indigo, size: 20),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                            BorderSide(color: Colors.grey.shade200),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                            BorderSide(color: Colors.grey.shade200),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Colors.indigo, width: 1.4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedYear,
                          isDense: true,
                          icon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Colors.indigo,
                              size: 20),
                          style: const TextStyle(
                            color: Colors.indigo,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                          items: _years
                              .map((y) => DropdownMenuItem(
                              value: y, child: Text(y)))
                              .toList(),
                          onChanged: _onYearChanged,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // ==== FILTER CHIPS ====
                Wrap(
                  spacing: 8,
                  children: ["All", "Paid", "Pending"].map((f) {
                    final sel = _statusFilter == f;
                    return ChoiceChip(
                      label: Text(f),
                      selected: sel,
                      onSelected: (_) {
                        setState(() {
                          _statusFilter = f;
                          _visibleCount = _pageSize;
                        });
                      },
                      selectedColor: Colors.indigo,
                      labelStyle: TextStyle(
                        color: sel ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                      backgroundColor: Colors.white,
                      side: BorderSide(color: Colors.grey.shade300),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 12),

                // ==== SECTION TITLE ====
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Month-wise Salary",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w700)),
                    Text("${_visibleMonthly.length}/${_filteredMonthly.length}",
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            ),
          ),
        ),

        // ==== SCROLLABLE LIST ====
        if (_visibleMonthly.isEmpty)
          SliverToBoxAdapter(child: _emptyState("No salary records found"))
        else
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) => Padding(
                padding: EdgeInsets.fromLTRB(
                    14, index == 0 ? 10 : 0, 14, index == _visibleMonthly.length - 1 ? 0 : 10),
                child: _buildMonthlyTile(_visibleMonthly[index]),
              ),
              childCount: _visibleMonthly.length,
            ),
          ),

        // ==== LOAD MORE / END ====
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 90),
            child: _hasMore
                ? SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _isLoadingMore ? null : _loadMore,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  side: const BorderSide(color: Colors.indigo),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: _isLoadingMore
                    ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.indigo),
                )
                    : const Icon(Icons.expand_more_rounded,
                    color: Colors.indigo),
                label: Text(
                  _isLoadingMore ? "Loading..." : "Load More",
                  style: const TextStyle(
                      color: Colors.indigo,
                      fontWeight: FontWeight.w600),
                ),
              ),
            )
                : _visibleMonthly.isEmpty
                ? const SizedBox.shrink()
                : Center(
              child: Text(
                "✓ All $_selectedYear records loaded",
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ==================== COMPACT SUMMARY CARD ====================
  Widget _buildCompactSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.indigo, Color(0xFF3F51B5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.28),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.account_balance_wallet_rounded,
                color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Net Salary (September)",
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(_formatCurrency(_netSalary),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.check_circle,
                              color: Colors.white, size: 10),
                          SizedBox(width: 3),
                          Text("Credited",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text("30 Sep 2025",
                        style: TextStyle(
                            color: Colors.white70, fontSize: 10)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== QUICK ACTION BUTTON ====================
  Widget _quickAction({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    int badge = 0,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
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
          if (badge > 0)
            Positioned(
              top: -4,
              right: -4,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                constraints:
                const BoxConstraints(minWidth: 18, minHeight: 18),
                child: Center(
                  child: Text("$badge",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ==================== YEARLY STATS ROW ====================
  Widget _buildYearlyStatsRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(
              child: _miniStat(
                  "Total", _formatCurrency(_yearlyTotal), Colors.indigo)),
          Container(width: 1, height: 28, color: Colors.grey.shade200),
          Expanded(
              child: _miniStat(
                  "Paid", _formatCurrency(_yearlyPaid), Colors.green)),
          Container(width: 1, height: 28, color: Colors.grey.shade200),
          Expanded(
              child: _miniStat(
                  "Pending", _formatCurrency(_yearlyPending), Colors.orange)),
        ],
      ),
    );
  }

  Widget _miniStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 10, color: color, fontWeight: FontWeight.w600)),
        const SizedBox(height: 3),
        Text(value,
            style: TextStyle(
                fontSize: 12, color: color, fontWeight: FontWeight.w700),
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
      ],
    );
  }

  // ==================== EMPTY STATE ====================
  Widget _emptyState(String msg) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: Column(
        children: [
          Icon(Icons.inbox_rounded, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 10),
          Text(msg,
              style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  // ==================== TAB 2: EXTRA ====================
  Widget _buildExtraSalaryTab() {
    final total =
    _extraSalary.fold<int>(0, (s, e) => s + (e['amount'] as int));

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.teal, Color(0xFF00897B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.teal.withOpacity(0.28),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.workspace_premium_rounded,
                      color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Total Extra Earned",
                        style: TextStyle(
                            color: Colors.white70, fontSize: 11)),
                    const SizedBox(height: 3),
                    Text(_formatCurrency(total),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const Text("Extra Salary Records",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          if (_extraSalary.isEmpty)
            _emptyState("No extra salary earned yet")
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _extraSalary.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) =>
                  _buildExtraTile(_extraSalary[index]),
            ),
          const SizedBox(height: 90),
        ],
      ),
    );
  }

  // ==================== TAB 3: REQUESTS ====================
  Widget _buildRequestsTab() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(0.06),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.indigo.withOpacity(0.15)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.indigo.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.info_outline_rounded,
                      color: Colors.indigo, size: 18),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    "Submit extra salary requests for additional duties, classes, or events.",
                    style: TextStyle(fontSize: 11, color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _showExtraSalaryRequestSheet,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.add_rounded,
                  color: Colors.white, size: 20),
              label: const Text("New Request",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 18),
          const Text("Request History",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          if (_extraRequests.isEmpty)
            _emptyState("No requests yet")
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _extraRequests.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) =>
                  _buildRequestTile(_extraRequests[index]),
            ),
          const SizedBox(height: 90),
        ],
      ),
    );
  }

  // ==================== PENDING TILE ====================
  Widget _buildPendingTile(Map<String, dynamic> item) {
    final isLate = (item['daysLate'] as int) > 0;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.hourglass_bottom_rounded,
                color: Colors.orange, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['month'] as String,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 3),
                Text(
                  isLate
                      ? "Overdue by ${item['daysLate']} days"
                      : "Due on ${item['dueDate']}",
                  style: TextStyle(
                    fontSize: 11,
                    color: isLate ? Colors.red : Colors.grey[600],
                    fontWeight:
                    isLate ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(_formatCurrency(item['amount'] as int),
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.bold)),
              const SizedBox(height: 3),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: item['status'] == "Processing"
                      ? Colors.blue.withOpacity(0.12)
                      : Colors.orange.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(item['status'] as String,
                    style: TextStyle(
                      fontSize: 10,
                      color: item['status'] == "Processing"
                          ? Colors.blue
                          : Colors.orange,
                      fontWeight: FontWeight.w600,
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==================== MONTHLY TILE ====================
  Widget _buildMonthlyTile(Map<String, dynamic> item) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _showSalaryDetailSheet(item),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: Colors.indigo.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.receipt_long_rounded,
                  color: Colors.indigo, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${item['month']} $_selectedYear",
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 3),
                  Text("Paid on ${item['date']}",
                      style: TextStyle(
                          fontSize: 11, color: Colors.grey[600])),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(_formatCurrency(item['amount'] as int),
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.bold)),
                const SizedBox(height: 3),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: item['status'] == "Paid"
                        ? Colors.green.withOpacity(0.1)
                        : Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(item['status'] as String,
                      style: TextStyle(
                        fontSize: 10,
                        color: item['status'] == "Paid"
                            ? Colors.green
                            : Colors.orange,
                        fontWeight: FontWeight.w600,
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ==================== EXTRA TILE ====================
  Widget _buildExtraTile(Map<String, dynamic> item) {
    Color statusColor;
    switch (item['status']) {
      case "Paid":
        statusColor = Colors.green;
        break;
      case "Approved":
        statusColor = Colors.blue;
        break;
      default:
        statusColor = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.workspace_premium_rounded,
                color: Colors.teal, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['title'] as String,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(item['type'] as String,
                          style: const TextStyle(
                              fontSize: 9, fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(width: 6),
                    Text(item['date'] as String,
                        style: TextStyle(
                            fontSize: 11, color: Colors.grey[600])),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("+ ${_formatCurrency(item['amount'] as int)}",
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal)),
              const SizedBox(height: 3),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(item['status'] as String,
                    style: TextStyle(
                      fontSize: 10,
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==================== REQUEST TILE ====================
  Widget _buildRequestTile(Map<String, dynamic> item) {
    Color statusColor;
    IconData statusIcon;
    switch (item['status']) {
      case "Approved":
        statusColor = Colors.green;
        statusIcon = Icons.check_circle_rounded;
        break;
      case "Rejected":
        statusColor = Colors.red;
        statusIcon = Icons.cancel_rounded;
        break;
      default:
        statusColor = Colors.orange;
        statusIcon = Icons.access_time_rounded;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(statusIcon, color: statusColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['title'] as String,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 3),
                Text("Requested on ${item['date']}",
                    style: TextStyle(
                        fontSize: 11, color: Colors.grey[600])),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(_formatCurrency(item['amount'] as int),
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.bold)),
              const SizedBox(height: 3),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(item['status'] as String,
                    style: TextStyle(
                      fontSize: 10,
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}