import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/feature/ott/home/screen/play_dashboard_screen.dart';
import '../../ads/controller/ott_ads_controller.dart';
import '../../ads/model/ott_ads_model.dart';
import '../../category/controller/ott_category_controller.dart';
import '../../category/widget/ott_category_widget.dart';
import '../../content/controller/ott_content_controller.dart';
import '../../content/model/ott_content_model.dart';
import '../../search/screen/search_movie_screen.dart';
import '../../banner/widget/movie_banner.dart';

class OttHomeScreen extends StatefulWidget {
  const OttHomeScreen({super.key});

  @override
  State<OttHomeScreen> createState() => _OttHomeScreenState();
}

class _OttHomeScreenState extends State<OttHomeScreen>
    with WidgetsBindingObserver {
  // Ads dismiss state
  bool isAdsVisible = true;

  // ✅ Banner visibility (combined from 3 sources)
  bool _isBannerVisible = true;
  bool _scrollHidden = false;
  bool _routeHidden = false;
  bool _appHidden = false;

  final ScrollController _scrollController = ScrollController();

  final categoryCtrl = Get.find<OttCategoryController>();
  final contentCtrl = Get.find<OttContentController>();
  final adsCtrl = Get.find<OttAdsController>();

  // ── Recompute banner visibility ──
  void _updateBannerVisibility() {
    final newValue = !_scrollHidden && !_routeHidden && !_appHidden;
    if (newValue != _isBannerVisible) {
      setState(() => _isBannerVisible = newValue);
    }
  }

  // ✅ Navigation wrapper — route switch par banner pause/resume
  Future<T?> _pauseNavigate<T>(Future<T?> Function() nav) async {
    _routeHidden = true;
    _updateBannerVisibility();
    try {
      return await nav();
    } finally {
      _routeHidden = false;
      _updateBannerVisibility();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // ── Scroll listener ──
    _scrollController.addListener(() {
      final hidden = _scrollController.offset >= 200;
      if (hidden != _scrollHidden) {
        _scrollHidden = hidden;
        _updateBannerVisibility();
      }
    });

    // ── Category change ──
    ever(categoryCtrl.selectedCategoryId, (id) {
      contentCtrl.getContents(categoryId: id);
    });

    // ── Initial fetch ──
    Future.microtask(() {
      contentCtrl.getContents(
          categoryId: categoryCtrl.selectedCategoryId.value);
      if (adsCtrl.ads.isEmpty) {
        adsCtrl.fetchAds();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    super.dispose();
  }

  // ── App lifecycle: background → pause ──
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final hidden = state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden;
    if (hidden != _appHidden) {
      debugPrint('📱 App lifecycle: $state (hidden: $hidden)');
      _appHidden = hidden;
      _updateBannerVisibility();
    }
  }

  Future<void> _refreshData() async {
    await categoryCtrl.fetchCategories();
    await contentCtrl.refreshContents();
    await adsCtrl.fetchAds();
  }

  void _handleAdTap(OttAdsModel ad) {
    if (ad.navigateScreen == null || ad.navigateScreen!.isEmpty) return;
    switch (ad.navigateScreen!.toLowerCase()) {
      case 'movies':
        Get.snackbar('Navigate', 'Go to Movies Screen');
        break;
      case 'trending':
        Get.snackbar('Navigate', 'Go to Trending Screen');
        break;
      case 'premium':
        Get.snackbar('Navigate', 'Go to Premium Screen');
        break;
      default:
        Get.snackbar('Navigate', 'Unknown Screen: ${ad.navigateScreen}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          RefreshIndicator(
            color: Colors.red,
            backgroundColor: Colors.grey[900],
            onRefresh: _refreshData,
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // 1. Sticky category bar
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverCategoryDelegate(
                    child: Container(
                      color: Colors.black,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: OttCategoryWidget(),
                      ),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 10)),

                // 2. Banner
                SliverToBoxAdapter(
                  child: MovieBanner(isVisible: _isBannerVisible),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                // 3. Top Ad
                SliverToBoxAdapter(
                  child: Obx(() {
                    if (adsCtrl.isLoading.value && adsCtrl.ads.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    final activeAds =
                    adsCtrl.ads.where((a) => a.isActive).toList();
                    if (activeAds.isNotEmpty && isAdsVisible) {
                      return _buildAdBanner(activeAds.first);
                    }
                    return const SizedBox.shrink();
                  }),
                ),

                // 4. Sections + inline ads
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: _buildAllSections(),
                  ),
                ),
              ],
            ),
          ),

          // Global loading overlay
          Obx(() {
            if (contentCtrl.isLoading.value &&
                contentCtrl.contents.isNotEmpty) {
              return Container(
                color: Colors.black.withOpacity(0.6),
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.red),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  // ==================== APP BAR ====================
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              spacing: 10,
              children: [
                Icon(Icons.live_tv, color: Colors.white),
                Text(
                  'OTT',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(8),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                // ✅ Wrap Search navigation with pause
                onTap: () => _pauseNavigate(
                      () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const SearchMovieScreen()),
                  ),
                ),
                child: const Row(
                  children: [
                    SizedBox(width: 12),
                    Icon(Icons.search, color: Colors.white70, size: 20),
                    SizedBox(width: 8),
                    Text('Search...',
                        style: TextStyle(
                            color: Colors.white70, fontSize: 14)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== TOP AD BANNER ====================
  Widget _buildAdBanner(OttAdsModel ad) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () => _handleAdTap(ad),
        child: Container(
          height: 160,
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white12),
            image: ad.image != null && ad.image!.isNotEmpty
                ? DecorationImage(
              image: NetworkImage(ad.image!),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.3),
                BlendMode.darken,
              ),
            )
                : null,
          ),
          child: Stack(
            children: [
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () => setState(() => isAdsVisible = false),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                    child:
                    const Icon(Icons.close, color: Colors.white, size: 18),
                  ),
                ),
              ),
              Positioned(
                bottom: 12,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'SPONSORED',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      ad.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(color: Colors.black, blurRadius: 4)],
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

  // ==================== ALL SECTIONS ====================
  Widget _buildAllSections() {
    return Obx(() {
      if (contentCtrl.isLoading.value && contentCtrl.contents.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(40.0),
            child: CircularProgressIndicator(color: Colors.red),
          ),
        );
      }

      if (contentCtrl.contents.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(40.0),
            child: Text(
              'No content found for this category',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
        );
      }

      final all = contentCtrl.contents;
      final trending = all.where((c) => c.isTrending).toList();
      final recommended = all.where((c) => c.isRecommended).toList();
      final newItems = all.where((c) => c.isSomethingNew).toList();
      final family = all.where((c) => c.isFamily).toList();
      final premium = all.where((c) => c.isLock).toList();

      final List<Widget> contentSections = [];
      contentSections
          .add(_buildContentSection(title: 'Watch Now', items: all));
      if (trending.isNotEmpty) {
        contentSections
            .add(_buildContentSection(title: 'Trending Now', items: trending));
      }
      if (recommended.isNotEmpty) {
        contentSections.add(
            _buildContentSection(title: 'Recommended', items: recommended));
      }
      if (newItems.isNotEmpty) {
        contentSections
            .add(_buildContentSection(title: 'New Arrivals', items: newItems));
      }
      if (family.isNotEmpty) {
        contentSections.add(
            _buildContentSection(title: 'Family Friendly', items: family));
      }
      if (premium.isNotEmpty) {
        contentSections
            .add(_buildContentSection(title: 'Premium', items: premium));
      }

      final allActiveAds = adsCtrl.ads.where((a) => a.isActive).toList();
      final List<OttAdsModel> inlineAds = allActiveAds.length > 1
          ? (allActiveAds.skip(1).toList()..shuffle(Random()))
          : <OttAdsModel>[];

      final List<Widget> finalList = [];
      int adIdx = 0;

      for (int i = 0; i < contentSections.length; i++) {
        finalList.add(contentSections[i]);
        if (adIdx < inlineAds.length) {
          final isLast = i == contentSections.length - 1;
          if (Random().nextBool() || isLast) {
            finalList.add(_buildInterspersedAdCard(inlineAds[adIdx]));
            adIdx++;
          }
        }
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: finalList,
      );
    });
  }

  // ==================== SINGLE SECTION ====================
  Widget _buildContentSection({
    required String title,
    required List<OttContentModel> items,
  }) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    'View All',
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 190,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return _buildContentCard(items[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  // ==================== INLINE AD CARD ====================
  Widget _buildInterspersedAdCard(OttAdsModel ad) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
      child: GestureDetector(
        onTap: () => _handleAdTap(ad),
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white12),
            image: ad.image != null && ad.image!.isNotEmpty
                ? DecorationImage(
              image: NetworkImage(ad.image!),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.3),
                BlendMode.darken,
              ),
            )
                : null,
          ),
          child: Stack(
            children: [
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'SPONSORED',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Positioned(
                bottom: 12,
                left: 16,
                right: 16,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        ad.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(color: Colors.black, blurRadius: 4)
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_ios,
                        color: Colors.white, size: 14),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== CONTENT CARD ====================
  Widget _buildContentCard(OttContentModel content) {
    return GestureDetector(
      // ✅ Wrap navigation with pause
      onTap: () => _pauseNavigate(
            () async => Get.to(() => PlayDashboardScreen(content: content)),
      ),
      child: Container(
        width: 130,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      content.thumbnailVertical.isNotEmpty
                          ? content.thumbnailVertical
                          : content.thumbnailHorizontal,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey[900],
                        child: const Center(
                          child: Icon(Icons.movie,
                              color: Colors.white24, size: 40),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 6,
                      left: 6,
                      right: 6,
                      child: Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: [
                          if (content.isTrending)
                            _buildBadge('🔥 Trending', Colors.redAccent),
                          if (content.isRecommended)
                            _buildBadge('⭐ Rec', Colors.blueAccent),
                          if (content.isFamily)
                            _buildBadge('👨‍👩‍👧 Family', Colors.green),
                          if (content.isLock)
                            _buildBadge('🔒 Premium', Colors.amber),
                          if (content.isSomethingNew)
                            _buildBadge('✨ New', Colors.purpleAccent),
                        ],
                      ),
                    ),
                    if (content.videoDuration.isNotEmpty)
                      Positioned(
                        bottom: 6,
                        right: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            content.videoDuration,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${content.releaseDate.split('-').first} • ${content.categoryName}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.grey, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(
            color: Colors.white,
            fontSize: 9,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}

// ==================== SLIVER DELEGATE ====================
class _SliverCategoryDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  _SliverCategoryDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlaps) {
    return SizedBox(height: maxExtent, child: child);
  }

  @override
  double get maxExtent => 50.0;

  @override
  double get minExtent => 50.0;

  @override
  bool shouldRebuild(covariant _SliverCategoryDelegate oldDelegate) {
    return true;
  }
}