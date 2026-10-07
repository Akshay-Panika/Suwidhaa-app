import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../core/widget/flutter_toast.dart';
import '../../../auth/controller/auth_controller.dart';
import '../controller/ngo_history_controller.dart';
import '../controller/ngo_service_controller.dart';
import '../controller/ngo_staff_controller.dart';
import '../model/ngo_service_model.dart';
import '../model/ngo_staff_model.dart';

class DonationDetailsScreen extends StatefulWidget {
  final int serviceId;

  const DonationDetailsScreen({super.key, required this.serviceId});

  @override
  State<DonationDetailsScreen> createState() => _DonationDetailsScreenState();
}

class _DonationDetailsScreenState extends State<DonationDetailsScreen>
    with TickerProviderStateMixin {
  final AuthController authController = Get.find<AuthController>();
  late final donorId = authController.getUserId;
  late final donorName = authController.getUserName;
  late final donorPhone = authController.getUserPhone;

  final CarouselSliderController _carouselController =
  CarouselSliderController();
  int _currentImageIndex = 0;

  static const Color primaryColor = Colors.teal;
  static const String currencySymbol = "₹";

  String? _selectedAmount;
  final TextEditingController _customAmountController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late TabController _tabController;

  final NgoServiceController _serviceController =
  Get.find<NgoServiceController>();
  final NgoStaffController _staffController = Get.find<NgoStaffController>();
  final NgoHistoryController _historyController =
  Get.find<NgoHistoryController>();

  // Reactive state
  NgoServiceData? _service;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();

    _loadService();
    _loadStaff();
  }

  Future<void> _loadService() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    final result = await _serviceController.fetchServiceById(widget.serviceId);
    if (!mounted) return;
    setState(() {
      _service = result;
      _isLoading = false;
      if (result == null) {
        _error = _serviceController.detailErrorMessage.value;
      }
    });
  }

  Future<void> _loadStaff() async {
    try {
      if (_staffController.staffList.isEmpty) {
        await _staffController.getNgoStaffList();
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _tabController.dispose();
    _customAmountController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // ═══════════════════════════════════════════════════════════════
  // HELPERS
  // ═══════════════════════════════════════════════════════════════
  double get _raised => _service?.progress.totalAmount ?? 0;
  int get _target => _service?.progress.targetAmount ?? 0;
  int get _donor => _service?.progress.donor ?? 0;
  double get _progressRatio =>
      _target == 0 ? 0.0 : (_raised / _target).clamp(0.0, 1.0);

  List<String> get _bannerImages =>
      _service?.images.isNotEmpty == true ? _service!.images : [];

  List<String> get _galleryImages =>
      _service?.images.isNotEmpty == true ? _service!.images : [];

  List<int> get _chooseAmounts => _service?.chooseAmount ?? [];

  List<NgoKeyItem> get _keyItems => _service?.keys ?? [];

  // ═══════════════════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios, size: 20),
          ),
          title: const Text(
            'Service',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
        body: Center(child: CircularProgressIndicator(color: primaryColor)),
      );
    }

    if (_service == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios, size: 20),
          ),
          title: const Text(
            'Service',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 12),
                Text(
                  _error ?? "Service not found",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadService,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Retry"),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final s = _service!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, size: 20),
        ),
        title: Text(
          s.name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverToBoxAdapter(
            child: SizedBox(height: 220, child: _buildHeaderImage()),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _TabBarDelegate(
              TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                labelColor: primaryColor,
                unselectedLabelColor: Colors.grey.shade600,
                indicatorColor: primaryColor,
                indicatorWeight: 2.5,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: const [
                  Tab(text: "About"),
                  Tab(text: "Gallery"),
                  Tab(text: "Staff"),
                ],
              ),
              color: Colors.white,
            ),
          ),
        ],
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildAboutTab(),
              _buildGalleryTab(),
              _buildStaffTab(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildStickyDonateBar(),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // HEADER IMAGE
  // ═══════════════════════════════════════════════════════════════
  Widget _buildHeaderImage() {
    final images = _bannerImages;

    if (images.isEmpty) {
      return Container(
        color: primaryColor.withOpacity(0.1),
        child: const Center(
          child: Icon(Icons.image, size: 64, color: primaryColor),
        ),
      );
    }

    return Stack(
      children: [
        CarouselSlider.builder(
          controller: _carouselController,
          itemCount: images.length,
          options: CarouselOptions(
            height: 280,
            viewportFraction: 1.0,
            autoPlay: images.length > 1,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayAnimationDuration: const Duration(milliseconds: 700),
            autoPlayCurve: Curves.easeInOut,
            enableInfiniteScroll: images.length > 1,
            onPageChanged: (index, reason) {
              setState(() => _currentImageIndex = index);
            },
          ),
          itemBuilder: (context, index, realIndex) {
            return GestureDetector(
              onTap: () => _openFullScreenGallery(images, index),
              child: SizedBox.expand(
                child: Image.network(
                  images[index],
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: primaryColor.withOpacity(0.15),
                    child: const Icon(
                      Icons.image_not_supported,
                      size: 64,
                      color: primaryColor,
                    ),
                  ),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: primaryColor.withOpacity(0.08),
                      child: const Center(
                        child: CircularProgressIndicator(color: primaryColor),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),

        if (_service?.categoryName != null)
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.category_outlined,
                      size: 12, color: primaryColor),
                  const SizedBox(width: 4),
                  Text(
                    _service!.categoryName!,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),

        Positioned(
          top: 12,
          right: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.55),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "${_currentImageIndex + 1} / ${images.length}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),

        if (images.length > 1)
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(images.length, (index) {
                final selected = index == _currentImageIndex;
                return GestureDetector(
                  onTap: () => _carouselController.animateToPage(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: selected ? 22 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      color: selected
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // TAB 1: ABOUT
  // ═══════════════════════════════════════════════════════════════
  Widget _buildAboutTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 100),
      children: [
        _buildProgressCard(),
        const SizedBox(height: 12),
        if (_keyItems.isNotEmpty) ...[
          _buildKeysSection(),
          const SizedBox(height: 12),
        ],
        _buildAmountSection(),
        const SizedBox(height: 12),
        if ((_service?.description ?? '').isNotEmpty) _buildAboutSection(),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // TAB 2: GALLERY
  // ═══════════════════════════════════════════════════════════════
  Widget _buildGalleryTab() {
    final gallery = _galleryImages;
    if (gallery.isEmpty) {
      return const Center(child: Text("No photos"));
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 100),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemCount: gallery.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _openFullScreenGallery(gallery, index),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: primaryColor.withOpacity(0.15),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    gallery[index],
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: primaryColor.withOpacity(0.08),
                      child: const Icon(Icons.image_outlined,
                          color: primaryColor, size: 32),
                    ),
                  ),
                  Positioned(
                    bottom: 6,
                    right: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        "${index + 1}/${gallery.length}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // TAB 3: STAFF
  // ═══════════════════════════════════════════════════════════════
  Widget _buildStaffTab() {
    return Obx(() {
      if (_staffController.isLoading.value &&
          _staffController.staffList.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(color: primaryColor),
        );
      }

      final staff = _staffController.staffList;

      if (staff.isEmpty) {
        return RefreshIndicator(
          color: primaryColor,
          onRefresh: _staffController.refreshStaffList,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(12, 60, 12, 100),
            children: [
              Icon(Icons.groups_outlined,
                  size: 72, color: primaryColor.withOpacity(0.5)),
              const SizedBox(height: 12),
              const Center(
                child: Text(
                  "No staff members found",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Center(
                child: Text(
                  "Pull down to refresh",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        color: primaryColor,
        onRefresh: _staffController.refreshStaffList,
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 100),
          itemCount: staff.length + 1,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            if (index == 0) {
              return _card(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.groups,
                          color: primaryColor, size: 18),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Our Team",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "${staff.length} members",
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            final member = staff[index - 1];
            return _buildStaffCard(member);
          },
        ),
      );
    });
  }

  Widget _buildStaffCard(NgoStaffModel member) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: primaryColor.withOpacity(0.2),
          width: 0.8,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: primaryColor.withOpacity(0.4),
                width: 2,
              ),
            ),
            child: ClipOval(
              child: member.image.isNotEmpty
                  ? Image.network(
                member.image,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    _avatarFallback(member.name),
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Container(
                    color: primaryColor.withOpacity(0.08),
                    child: const Center(
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  );
                },
              )
                  : _avatarFallback(member.name),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    member.roleDisplay,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatarFallback(String name) {
    final initials = name.trim().isEmpty
        ? '?'
        : name.trim().split(RegExp(r'\s+')).take(2).map((e) => e[0]).join();
    return Container(
      color: primaryColor.withOpacity(0.15),
      alignment: Alignment.center,
      child: Text(
        initials.toUpperCase(),
        style: const TextStyle(
          color: primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // PROGRESS CARD
  // ═══════════════════════════════════════════════════════════════
  Widget _buildProgressCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            icon: Icons.trending_up,
            title: "Donation Progress",
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "${(_progressRatio * 100).toStringAsFixed(0)}%",
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: primaryColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Raised",
                      style:
                      TextStyle(color: Colors.grey[600], fontSize: 11)),
                  const SizedBox(height: 2),
                  Text(
                    "$currencySymbol${_raised.toStringAsFixed(0)}",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("Target",
                      style:
                      TextStyle(color: Colors.grey[600], fontSize: 11)),
                  const SizedBox(height: 2),
                  Text(
                    "$currencySymbol$_target",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: _progressRatio,
              backgroundColor: Colors.grey.shade200,
              color: primaryColor,
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.people_outline, size: 14, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                "$_donor donors",
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
              const Spacer(),
              ..._buildMilestoneDots(_progressRatio),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildMilestoneDots(double progress) {
    final List<int> milestones = _getMilestones();

    return milestones.map((pct) {
      final reached = progress >= (pct / 100);
      final isFull = pct == 100;

      return Padding(
        padding: const EdgeInsets.only(left: 6),
        child: Column(
          children: [
            Container(
              width: reached ? (isFull ? 10 : 9) : 8,
              height: reached ? (isFull ? 10 : 9) : 8,
              decoration: BoxDecoration(
                color: reached ? primaryColor : Colors.grey.shade300,
                shape: BoxShape.circle,
                border: reached
                    ? Border.all(
                  color: primaryColor.withOpacity(0.3),
                  width: 2,
                )
                    : null,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              "$pct%",
              style: TextStyle(
                fontSize: 8,
                color: reached ? primaryColor : Colors.grey[500],
                fontWeight: reached ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  List<int> _getMilestones() {
    if (_target <= 0) return const [25, 50, 75, 100];

    if (_target <= 1000) {
      return const [10, 30, 50, 75, 100];
    } else if (_target <= 10000) {
      return const [25, 50, 75, 100];
    } else if (_target <= 100000) {
      return const [25, 50, 75, 100];
    } else {
      return const [25, 50, 75, 100];
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // KEYS SECTION
  // ═══════════════════════════════════════════════════════════════
  Widget _buildKeysSection() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            icon: Icons.insights,
            title: "Our Impact So Far",
          ),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: _keyItems.length,
            itemBuilder: (context, index) {
              final item = _keyItems[index];
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: primaryColor.withOpacity(0.15),
                    width: 0.8,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: primaryColor, size: 35),
                    const SizedBox(width: 6),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item.value,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          item.key,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[700],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // ABOUT SECTION
  // ═══════════════════════════════════════════════════════════════
  Widget _buildAboutSection() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            icon: Icons.info_outline,
            title: "About this Service",
          ),
          const SizedBox(height: 12),
          Text(
            _service!.description ?? '',
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // AMOUNT
  // ═══════════════════════════════════════════════════════════════
  Widget _buildAmountSection() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            icon: Icons.currency_rupee,
            title: "Choose Amount",
          ),
          const SizedBox(height: 14),
          if (_chooseAmounts.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _chooseAmounts
                  .map((amt) => _buildAmountChip(
                "$currencySymbol $amt",
                amt.toString(),
              ))
                  .toList(),
            )
          else
            Text(
              "No preset amounts",
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          const SizedBox(height: 14),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey.shade50,
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: TextField(
              controller: _customAmountController,
              decoration: InputDecoration(
                hintText: "Enter custom amount",
                border: InputBorder.none,
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 14, right: 6),
                  child: Text(
                    currencySymbol,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: primaryColor,
                    ),
                  ),
                ),
                prefixIconConstraints:
                const BoxConstraints(minWidth: 0),
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                suffixIcon: _customAmountController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear, size: 20),
                  onPressed: () {
                    setState(() {
                      _customAmountController.clear();
                      _selectedAmount = null;
                    });
                  },
                )
                    : null,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (_) {
                setState(() => _selectedAmount = null);
              },
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // STICKY DONATE BAR (with loading state on the button)
  // ═══════════════════════════════════════════════════════════════
  Widget _buildStickyDonateBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "You're donating",
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 2),
                Text(
                  _selectedAmount != null
                      ? "$currencySymbol${_selectedAmount!}"
                      : _customAmountController.text.isNotEmpty
                      ? "$currencySymbol${_customAmountController.text}"
                      : "$currencySymbol 0",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 30),
            Expanded(
              child: Obx(() {
                final isBusy = _historyController.isDonating.value;
                return ElevatedButton(
                  onPressed: isBusy
                      ? null
                      : () {
                    String amount = "";
                    if (_selectedAmount != null) {
                      amount = _selectedAmount!;
                    } else if (_customAmountController.text.isNotEmpty) {
                      amount = _customAmountController.text;
                    } else {
                      FlutterToast.error(
                          "Please select or enter an amount");
                      _tabController.animateTo(0);
                      return;
                    }
                    _showDonationDialog(context, amount);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                    primaryColor.withOpacity(0.6),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 4,
                    shadowColor: primaryColor.withOpacity(0.4),
                  ),
                  child: isBusy
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.volunteer_activism, size: 18),
                      SizedBox(width: 6),
                      Text(
                        "Donate Now",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // AMOUNT CHIP
  // ═══════════════════════════════════════════════════════════════
  Widget _buildAmountChip(String label, String value) {
    final isSelected = _selectedAmount == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedAmount = isSelected ? null : value;
          if (!isSelected) _customAmountController.clear();
        });
        HapticFeedback.lightImpact();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : primaryColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : primaryColor,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // SHARED WIDGETS
  // ═══════════════════════════════════════════════════════════════
  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryColor, width: 0.3),
      ),
      child: child,
    );
  }

  Widget _sectionHeader({
    required IconData icon,
    required String title,
    Widget? trailing,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: primaryColor, size: 18),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        if (trailing != null) ...[
          const Spacer(),
          trailing,
        ],
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // GALLERY VIEWER
  // ═══════════════════════════════════════════════════════════════
  void _openFullScreenGallery(List<String> images, int initialIndex) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black,
        pageBuilder: (_, __, ___) => _FullScreenGallery(
          images: images,
          initialIndex: initialIndex,
          accentColor: primaryColor,
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // DIALOGS — with real API call
  // ═══════════════════════════════════════════════════════════════
  void _showDonationDialog(BuildContext context, String amount) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.volunteer_activism, color: primaryColor),
            SizedBox(width: 8),
            Text("Confirm Donation"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "You are about to donate $currencySymbol$amount to",
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 6),
            Text(
              _service!.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogCtx);

              // 🔥 Call the real API
              final success = await _historyController.donate(
                serviceId: widget.serviceId,
                amount: double.tryParse(amount) ?? 0,
                donorName: donorName,
                donorContact: donorPhone,
              );

              if (!mounted) return;

              if (success) {
                // Refresh service so progress updates
                await _loadService();

                if (!mounted) return;

                // Reset selection
                setState(() {
                  _selectedAmount = null;
                  _customAmountController.clear();
                });

                // Show success
                _showSuccessDialog(context, amount);
              }
              // On error, the controller already showed a toast
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, String amount) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("🎉 Thank You!"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.volunteer_activism,
                size: 60,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Your donation of $currencySymbol$amount will make a difference!",
              textAlign: TextAlign.center,
              style:
              const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogCtx),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Done"),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// FULL-SCREEN GALLERY VIEWER
// ═══════════════════════════════════════════════════════════════════
class _FullScreenGallery extends StatefulWidget {
  final List<String> images;
  final int initialIndex;
  final Color accentColor;

  const _FullScreenGallery({
    required this.images,
    required this.initialIndex,
    required this.accentColor,
  });

  @override
  State<_FullScreenGallery> createState() => _FullScreenGalleryState();
}

class _FullScreenGalleryState extends State<_FullScreenGallery> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: widget.images.length,
              onPageChanged: (i) => setState(() => _currentIndex = i),
              itemBuilder: (context, index) {
                return InteractiveViewer(
                  minScale: 1,
                  maxScale: 4,
                  child: Center(
                    child: Image.network(
                      widget.images[index],
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.broken_image,
                        color: Colors.white38,
                        size: 80,
                      ),
                    ),
                  ),
                );
              },
            ),
            Positioned(
              top: 8,
              left: 8,
              right: 8,
              child: Row(
                children: [
                  _circleButton(
                    icon: Icons.close,
                    onTap: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "${_currentIndex + 1} / ${widget.images.length}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
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

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  _TabBarDelegate(this.tabBar, {required this.color});
  final TabBar tabBar;
  final Color color;

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color: color, child: tabBar);
  }

  @override
  bool shouldRebuild(_TabBarDelegate oldDelegate) =>
      tabBar != oldDelegate.tabBar || color != oldDelegate.color;
}