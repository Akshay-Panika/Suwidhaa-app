import 'package:carousel_slider_plus/carousel_controller.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DonationDetailsScreen extends StatefulWidget {
  final Map<String, dynamic>? donationData;

  const DonationDetailsScreen({super.key, this.donationData});

  @override
  State<DonationDetailsScreen> createState() => _DonationDetailsScreenState();
}

class _DonationDetailsScreenState extends State<DonationDetailsScreen>
    with TickerProviderStateMixin {

  final CarouselSliderController _carouselController = CarouselSliderController();
  int _currentImageIndex = 0;

  static const Color primaryColor = Colors.teal;
  static const String currencySymbol = "₹";

  String? _selectedAmount;
  final TextEditingController _customAmountController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late TabController _tabController;

  Map<String, dynamic> get _donationData {
    final data = widget.donationData ?? {};
    return {
      "name": data["name"] ?? "Education For All",
      "raised": data["raised"] ?? 7500,
      "target": data["target"] ?? 10000,
      "imageUrl": data["imageUrl"] ??
          "https://images.unsplash.com/photo-1503676260728-1c00da094a0b?w=400",
      "description": data["description"] ??
          "We work to provide quality education to underprivileged children. Our mission is to ensure every child has access to education and the opportunity to build a better future.",
      "category": data["category"] ?? "Education",
      "rating": data["rating"] ?? 4.5,
      "location": data["location"] ?? "India",
      "beneficiaries": data["beneficiaries"] ?? 500,
      "founded": data["founded"] ?? "2015",
      "gallery": data["gallery"] ??
          [
            "https://images.unsplash.com/photo-1497486751825-1233686d5d80?w=400",
            "https://images.unsplash.com/photo-1509062522246-3755977927d7?w=400",
            "https://images.unsplash.com/photo-1588072432836-e10032774350?w=400",
          ],
      "team": data["team"] ?? [],
      "impact": data["impact"] ?? [],
      "timeline": data["timeline"] ?? [],

      "bannerImages": data["bannerImages"] ??
          [
            data["imageUrl"] ??
                "https://images.unsplash.com/photo-1503676260728-1c00da094a0b?w=400",
            "https://images.unsplash.com/photo-1497486751825-1233686d5d80?w=800",
            "https://images.unsplash.com/photo-1509062522246-3755977927d7?w=800",
            "https://images.unsplash.com/photo-1588072432836-e10032774350?w=800",
            "https://images.unsplash.com/photo-1576091160550-2173dba999ef?w=800",
          ],
    };
  }

  @override
  void initState() {
    super.initState();
    // ✅ Now 3 tabs instead of 4
    _tabController = TabController(length: 3, vsync: this);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _customAmountController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress =
    (_donationData["raised"] / _donationData["target"]).clamp(0.0, 1.0);

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
        // ✅ AppBar title uses donation name
        title: Text(
          _donationData["name"] ?? "Donation",
          style: const TextStyle(
            fontSize: 16,
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
            child: SizedBox(height: 220, child: _buildHeaderImage(progress)),
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
                  Tab(text: "Team"),
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
              _buildTeamTab(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildStickyDonateBar(),
    );
  }

// ═══════════════════════════════════════════════════════════════
// HEADER IMAGE — Carousel with swipe + indicator
// ═══════════════════════════════════════════════════════════════
  Widget _buildHeaderImage(double progress) {
    final List<String> images =
    ((_donationData["bannerImages"] as List?) ?? [])
        .map((e) => e.toString())
        .toList();

    if (images.isEmpty) {
      images.add(_donationData["imageUrl"] as String);
    }

    return Stack(
      children: [
        // ── Carousel ────────────────────────────────────────────
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
            enlargeCenterPage: false,
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

        // ── Category badge (top-left, above carousel) ───────────
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
                  _donationData["category"] ?? "General",
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

        // ── Selection logic: page counter chip (top-right) ──────
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

        // ── Selection logic: dot indicators (bottom) ────────────
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
  // TAB 1: ABOUT  (Progress data merged here)
  // ═══════════════════════════════════════════════════════════════
  Widget _buildAboutTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 100),
      children: [
        // ✅ Progress card moved here (first in About tab)
        _buildProgressCard(),
        const SizedBox(height: 12),
        _buildImpactSection(),
        const SizedBox(height: 12),
        _buildAmountSection(),
        const SizedBox(height: 12),
        _buildLocationSection(),
        const SizedBox(height: 12),
        _buildTimelineSection(),
        const SizedBox(height: 12),
        const SizedBox(height: 12),
        _buildAboutSection(),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // TAB 2: GALLERY
  // ═══════════════════════════════════════════════════════════════
  Widget _buildGalleryTab() {
    final gallery = (_donationData["gallery"] as List?) ?? [];
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image_outlined,
                              color: primaryColor.withOpacity(0.5),
                              size: 32),
                          const SizedBox(height: 4),
                          Text(
                            "Image ${index + 1}",
                            style: TextStyle(
                              fontSize: 10,
                              color: primaryColor.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: primaryColor.withOpacity(0.06),
                        child: const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      );
                    },
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
  // TAB 3: TEAM
  // ═══════════════════════════════════════════════════════════════
  Widget _buildTeamTab() {
    final team = (_donationData["team"] as List?) ?? [];
    if (team.isEmpty) {
      return const Center(child: Text("No team members"));
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 100),
      children: [
        _card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionHeader(
                icon: Icons.groups_outlined,
                title: "Meet the Team",
                trailing: Text(
                  "${team.length} members",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ...team.map((member) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: primaryColor.withOpacity(0.3),
                          width: 2,
                        ),
                        image: DecorationImage(
                          image: NetworkImage(member["image"] ?? ""),
                          fit: BoxFit.cover,
                          onError: (_, __) {},
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            member["name"] ?? "",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            member["role"] ?? "",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.verified,
                        color: primaryColor.withOpacity(0.6), size: 18),
                  ],
                ),
              )),
            ],
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // PROGRESS CARD (now used in About tab)
  // ═══════════════════════════════════════════════════════════════
  Widget _buildProgressCard() {
    final progress =
    (_donationData["raised"] / _donationData["target"]).clamp(0.0, 1.0);
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            icon: Icons.trending_up,
            title: "Donation Progress",
            trailing: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "${(progress * 100).toStringAsFixed(0)}%",
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
                      style: TextStyle(
                          color: Colors.grey[600], fontSize: 11)),
                  const SizedBox(height: 2),
                  Text(
                    "$currencySymbol${_donationData["raised"]}",
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
                      style: TextStyle(
                          color: Colors.grey[600], fontSize: 11)),
                  const SizedBox(height: 2),
                  Text(
                    "$currencySymbol${_donationData["target"]}",
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
              value: progress,
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
                "${(_donationData["raised"] ~/ 25)} donors",
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
              const Spacer(),
              ..._buildMilestoneDots(progress),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildMilestoneDots(double progress) {
    return [25, 50, 75, 100].map((pct) {
      final reached = progress >= (pct / 100);
      return Padding(
        padding: const EdgeInsets.only(left: 6),
        child: Column(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: reached ? primaryColor : Colors.grey.shade300,
                shape: BoxShape.circle,
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
            title: "About this NGO",
          ),
          const SizedBox(height: 12),
          Text(
            _donationData["description"],
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
  // IMPACT
  // ═══════════════════════════════════════════════════════════════
  Widget _buildImpactSection() {
    final impact = (_donationData["impact"] as List?) ?? [];
    if (impact.isEmpty) return const SizedBox.shrink();

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
              childAspectRatio: 1.6,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: impact.length,
            itemBuilder: (context, index) {
              final item = impact[index];
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _iconFromName(item["icon"] ?? "star"),
                      color: primaryColor,
                      size: 22,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item["value"] ?? "0",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    Text(
                      item["label"] ?? "",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[700],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
  // LOCATION
  // ═══════════════════════════════════════════════════════════════
  Widget _buildLocationSection() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            icon: Icons.location_on_outlined,
            title: "Where Your Donation Goes",
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.place,
                    color: primaryColor, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Operating Location",
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _donationData["location"] ?? "India",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
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
                child: _infoChip(
                  icon: Icons.people_alt_outlined,
                  label:
                  "${_donationData["beneficiaries"] ?? 0}+ Beneficiaries",
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _infoChip(
                  icon: Icons.calendar_today_outlined,
                  label: "Founded ${_donationData["founded"] ?? "—"}",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.06),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: primaryColor),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // TIMELINE
  // ═══════════════════════════════════════════════════════════════
  Widget _buildTimelineSection() {
    final timeline = (_donationData["timeline"] as List?) ?? [];
    if (timeline.isEmpty) return const SizedBox.shrink();

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            icon: Icons.timeline,
            title: "Campaign Timeline",
          ),
          const SizedBox(height: 14),
          ...List.generate(timeline.length, (index) {
            final item = timeline[index];
            final isLast = index == timeline.length - 1;
            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: primaryColor.withOpacity(0.25),
                            width: 3,
                          ),
                        ),
                      ),
                      if (!isLast)
                        Expanded(
                          child: Container(
                            width: 2,
                            color: primaryColor.withOpacity(0.2),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                item["date"] ?? "",
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: primaryColor,
                                ),
                              ),
                              const Spacer(),
                              if (isLast)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    "UPCOMING",
                                    style: TextStyle(
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item["title"] ?? "",
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item["desc"] ?? "",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[700],
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
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
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildAmountChip("$currencySymbol 10", "10"),
              _buildAmountChip("$currencySymbol 25", "25"),
              _buildAmountChip("$currencySymbol 50", "50"),
              _buildAmountChip("$currencySymbol 100", "100"),
              _buildAmountChip("$currencySymbol 250", "250"),
              _buildAmountChip("$currencySymbol 500", "500"),
            ],
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
                prefixIconConstraints: const BoxConstraints(minWidth: 0),
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
  // STICKY DONATE BAR
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
              child: ElevatedButton(
                onPressed: () {
                  String amount = "";
                  if (_selectedAmount != null) {
                    amount = _selectedAmount!;
                  } else if (_customAmountController.text.isNotEmpty) {
                    amount = _customAmountController.text;
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select or enter an amount'),
                        duration: Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.all(12),
                      ),
                    );
                    // ✅ Switch to About tab (index 0) where amounts live
                    _tabController.animateTo(0);
                    return;
                  }
                  _showDonationDialog(context, amount);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 4,
                  shadowColor: primaryColor.withOpacity(0.4),
                ),
                child: const Row(
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
              ),
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

  IconData _iconFromName(String name) {
    switch (name) {
      case "school":
        return Icons.school;
      case "book":
        return Icons.menu_book;
      case "family":
        return Icons.family_restroom;
      case "star":
        return Icons.star;
      case "people":
        return Icons.people;
      case "favorite":
        return Icons.favorite;
      case "nature":
        return Icons.nature;
      default:
        return Icons.star;
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // GALLERY VIEWER
  // ═══════════════════════════════════════════════════════════════
  void _openFullScreenGallery(List<dynamic> images, int initialIndex) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black,
        pageBuilder: (_, __, ___) => _FullScreenGallery(
          images: images.cast<String>(),
          initialIndex: initialIndex,
          accentColor: primaryColor,
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // DIALOGS
  // ═══════════════════════════════════════════════════════════════
  void _showDonationDialog(BuildContext context, String amount) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
              _donationData["name"],
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
            onPressed: () => Navigator.pop(context),
            child:
            const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessDialog(context, amount);
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
      builder: (context) => AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
              style: const TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(
              "Together, we can ${_donationData["description"].split('.').first.toLowerCase()}.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
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
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        );
                      },
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
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 64,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: widget.images.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final isSelected = index == _currentIndex;
                    return GestureDetector(
                      onTap: () {
                        _pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOut,
                        );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? widget.accentColor
                                : Colors.white24,
                            width: isSelected ? 2.5 : 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(
                            widget.images[index],
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: Colors.white10,
                              child: const Icon(
                                Icons.broken_image,
                                color: Colors.white38,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
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
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color: color, child: tabBar);
  }

  @override
  bool shouldRebuild(_TabBarDelegate oldDelegate) =>
      tabBar != oldDelegate.tabBar || color != oldDelegate.color;
}