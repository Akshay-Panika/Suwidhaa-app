import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../../../router/app_routes.dart';
import '../../ads/controller/ngo_ads_controller.dart';
import '../../ads/model/ngo_ads_model.dart';
import '../../services/controller/ngo_service_controller.dart';
import '../controller/ngo_banner_controller.dart';
import '../controller/ngo_category_controller.dart';
import '../widget/ngo_banner_widget.dart';
import '../widget/open_donation_widget.dart';

String? _extractYoutubeId(String raw) {
  final uri = Uri.tryParse(raw.trim());
  if (uri == null || uri.host.isEmpty) return null;
  final host = uri.host.toLowerCase();
  String? id;
  if (host == 'youtu.be' || host == 'www.youtu.be') {
    id = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
  } else if (host.endsWith('youtube.com') ||
      host.endsWith('youtube-nocookie.com')) {
    if (uri.queryParameters['v'] != null) {
      id = uri.queryParameters['v'];
    } else if (uri.pathSegments.length >= 2 &&
        ['embed', 'shorts', 'live', 'v'].contains(uri.pathSegments.first)) {
      id = uri.pathSegments[1];
    }
  }
  if (id != null && RegExp(r'^[a-zA-Z0-9_-]{11}$').hasMatch(id)) return id;
  return null;
}

class NgoHomeScreen extends StatefulWidget {
  final Function(int index, {String? category})? onNavigate;
  const NgoHomeScreen({super.key, this.onNavigate});

  @override
  State<NgoHomeScreen> createState() => _NgoHomeScreenState();
}

class _NgoHomeScreenState extends State<NgoHomeScreen> {
  static const Color primaryColor = Colors.teal;

  final controller = Get.find<NgoCategoryController>();
  final bannerController = Get.find<NgoBannerController>();
  final serviceController = Get.find<NgoServiceController>();
  final adsController = Get.find<NgoAdsController>();

  final ValueNotifier<bool> _isScrolling = ValueNotifier<bool>(false);
  Timer? _scrollDebounce;

  @override
  void initState() {
    super.initState();
    if (adsController.ads.isEmpty) {
      adsController.fetchAds();
    }
  }

  @override
  void dispose() {
    _scrollDebounce?.cancel();
    _isScrolling.dispose();
    super.dispose();
  }

  bool _onScrollNotification(ScrollNotification n) {
    if (n is ScrollStartNotification || n is ScrollUpdateNotification) {
      _scrollDebounce?.cancel();
      if (!_isScrolling.value) _isScrolling.value = true;
    }
    if (n is ScrollUpdateNotification || n is ScrollEndNotification) {
      _scrollDebounce?.cancel();
      _scrollDebounce = Timer(const Duration(milliseconds: 300), () {
        _isScrolling.value = false;
      });
    }
    return false;
  }

  Future<void> _handleRefresh() async {
    try {
      await Future.wait([
        controller.fetchCategories(),
        bannerController.fetchBanners(),
        serviceController.fetchServices(),
        adsController.fetchAds(),
      ]);
    } catch (e) {
      debugPrint("Refresh Error: $e");
    }
  }

  void _handleAdTap(NgoAdsModel ad) {
    final key = ad.navigateScreen?.toLowerCase().trim();
    switch (key) {
      case 'donate':
      case 'donations':
        widget.onNavigate?.call(2);
        break;
      case 'services':
        widget.onNavigate?.call(1);
        break;
      case 'history':
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        return NotificationListener<ScrollNotification>(
          onNotification: _onScrollNotification,
          child: RefreshIndicator(
            color: primaryColor,
            onRefresh: _handleRefresh,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: _buildSlivers(),
            ),
          ),
        );
      }),
    );
  }

  List<Widget> _buildSlivers() {
    final homeAds = adsController.homeAds.take(4).toList();
    final isAdsLoading =
        adsController.isLoading.value && homeAds.isEmpty;

    final slivers = <Widget>[];
    int adIdx = 0;

    SliverToBoxAdapter? nextAdSlot() {
      if (isAdsLoading && adIdx == 0) {
        adIdx++;
        return const SliverToBoxAdapter(child: _AdShimmer());
      }
      if (adIdx >= homeAds.length) return null;
      final ad = homeAds[adIdx];
      adIdx++;
      return SliverToBoxAdapter(
        child: _NgoAdBanner(
          key: ValueKey('ngo_home_ad_${ad.id}'),
          ad: ad,
          isScrolling: _isScrolling,
          onTap: () => _handleAdTap(ad),
        ),
      );
    }

    slivers.add(SliverToBoxAdapter(child: NgoBannerWidget()));
    final a1 = nextAdSlot();
    if (a1 != null) slivers.add(a1);

    slivers.add(
      SliverPersistentHeader(
        pinned: true,
        delegate: _StickySearchBoxDelegate(
          onSearchTap: () => Get.toNamed(AppRoutes.ngoSearch),
        ),
      ),
    );

    slivers.add(SliverToBoxAdapter(child: _buildCategoriesSection()));
    final a2 = nextAdSlot();
    if (a2 != null) slivers.add(a2);

    slivers.add(
      SliverToBoxAdapter(
        child: OpenDonationWidget(
          headline: "Open Donations",
          color: Colors.teal.shade100,
        ),
      ),
    );
    final a3 = nextAdSlot();
    if (a3 != null) slivers.add(a3);

    slivers.add(
      SliverToBoxAdapter(
        child: OpenDonationWidget(
          headline: "All Donations",
          color: Colors.teal.shade50,
        ),
      ),
    );
    final a4 = nextAdSlot();
    if (a4 != null) slivers.add(a4);

    slivers.add(const SliverToBoxAdapter(child: SizedBox(height: 20)));
    return slivers;
  }

  Widget _buildCategoriesSection() {
    if (controller.isLoading.value && controller.categories.isEmpty) {
      return const _CategoryShimmerGrid();
    }
    if (controller.categories.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text('No categories found'),
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 0.3, color: Colors.teal),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Categories",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () => widget.onNavigate?.call(1, category: null),
                child: const Text(
                  "View All",
                  style: TextStyle(color: Colors.teal),
                ),
              ),
            ],
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1,
            ),
            itemCount: controller.categories.length,
            itemBuilder: (context, index) {
              final category = controller.categories[index];
              return _buildCategoryCard(category);
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(dynamic category) {
    return InkWell(
      onTap: () => widget.onNavigate?.call(1, category: category.name),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(category.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            category.name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// AD BANNER — play/pause + audio toggle + auto play/pause
// ═══════════════════════════════════════════════════════════════
class _NgoAdBanner extends StatefulWidget {
  final NgoAdsModel ad;
  final VoidCallback? onTap;
  final ValueNotifier<bool> isScrolling;

  const _NgoAdBanner({
    super.key,
    required this.ad,
    this.onTap,
    required this.isScrolling,
  });

  @override
  State<_NgoAdBanner> createState() => _NgoAdBannerState();
}

class _NgoAdBannerState extends State<_NgoAdBanner>
    with WidgetsBindingObserver {
  VideoPlayerController? _video;
  bool _videoReady = false;
  bool _videoFailed = false;

  YoutubePlayerController? _ytCtrl;
  String? _ytId;

  bool _isVisible = false;
  bool _isMuted = true;
  bool _appPaused = false;
  bool _userPaused = false;   // ✅ NEW: manual pause by user

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    widget.isScrolling.addListener(_syncPlayback);

    final url = widget.ad.videoUrl;
    if (url == null || url.isEmpty) return;

    _ytId = _extractYoutubeId(url);

    if (_ytId != null && kIsWeb) {
      _ytCtrl = YoutubePlayerController.fromVideoId(
        videoId: _ytId!,
        autoPlay: false,
        params: const YoutubePlayerParams(
          mute: true,
          showControls: false,
          showFullscreenButton: false,
          loop: true,
          playsInline: true,
        ),
      );
    } else {
      _initVideoPlayer(url);
    }
  }

  Future<void> _initVideoPlayer(String rawUrl) async {
    var resolved = rawUrl;

    if (_ytId != null) {
      try {
        final yt = YoutubeExplode();
        try {
          final manifest = await yt.videos.streamsClient
              .getManifest(_ytId!)
              .timeout(const Duration(seconds: 20));

          final streams = manifest.muxed.toList();
          if (streams.isEmpty) throw Exception('No playable stream');

          streams.sort((a, b) => a.videoResolution.height
              .compareTo(b.videoResolution.height));
          final upTo720 = streams
              .where((s) => s.videoResolution.height <= 720)
              .toList();
          final chosen = upTo720.isNotEmpty ? upTo720.last : streams.first;
          resolved = chosen.url.toString();
        } finally {
          yt.close();
        }
      } catch (_) {
        if (mounted) setState(() => _videoFailed = true);
        return;
      }
    }

    final ctrl = VideoPlayerController.networkUrl(
      Uri.parse(resolved),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
    _video = ctrl;
    try {
      await ctrl.initialize();
      if (!mounted) return;
      await ctrl.setLooping(true);
      await ctrl.setVolume(_isMuted ? 0 : 1);
      if (mounted) setState(() => _videoReady = true);
      _syncPlayback();
    } catch (_) {
      if (mounted) setState(() => _videoFailed = true);
    }
  }

  void _syncPlayback() {
    if (!mounted) return;
    final shouldPlay = _isVisible &&
        !widget.isScrolling.value &&
        !_appPaused &&
        !_userPaused;

    final v = _video;
    if (v != null && v.value.isInitialized) {
      if (shouldPlay) {
        if (!v.value.isPlaying) v.play();
      } else {
        if (v.value.isPlaying) v.pause();
      }
    }

    final yt = _ytCtrl;
    if (yt != null) {
      if (shouldPlay) {
        yt.playVideo();
      } else {
        yt.pauseVideo();
      }
    }
  }

  // ✅ NEW: manual play/pause
  void _togglePlayPause() {
    setState(() => _userPaused = !_userPaused);
    _syncPlayback();
  }

  void _toggleAudio() {
    setState(() => _isMuted = !_isMuted);
    final v = _video;
    if (v != null && v.value.isInitialized) {
      v.setVolume(_isMuted ? 0 : 1);
    }
    _ytCtrl?.setVolume(_isMuted ? 0 : 100);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden) {
      _appPaused = true;
    } else if (state == AppLifecycleState.resumed) {
      _appPaused = false;
    }
    _syncPlayback();
  }

  @override
  void dispose() {
    widget.isScrolling.removeListener(_syncPlayback);
    WidgetsBinding.instance.removeObserver(this);
    _video?.dispose();
    _ytCtrl?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showIframe = kIsWeb && _ytCtrl != null;
    final showVideo =
        !showIframe && widget.ad.hasVideo && _videoReady && _video != null;
    final showImageFallback =
        !showIframe && !showVideo && widget.ad.hasImage;
    final showControls =
        (widget.ad.hasVideo && !_videoFailed) || showIframe;

    return VisibilityDetector(
      key: Key('ngo_ad_visibility_${widget.ad.id}'),
      onVisibilityChanged: (info) {
        final newVisible = info.visibleFraction > 0.5;
        if (newVisible != _isVisible) {
          _isVisible = newVisible;
          _syncPlayback();
        }
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          height: 160,
          margin: const EdgeInsets.fromLTRB(12, 10, 12, 6),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.teal, width: 0.3),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (showIframe)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: 320,
                      height: 180,
                      child: YoutubePlayer(
                        controller: _ytCtrl!,
                        aspectRatio: 16 / 9,
                      ),
                    ),
                  ),
                )
              else if (showVideo)
                FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _video!.value.size.width,
                    height: _video!.value.size.height,
                    child: VideoPlayer(_video!),
                  ),
                )
              else if (showImageFallback)
                  Image.network(
                    widget.ad.image!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Container(color: Colors.grey.shade300),
                  )
                else
                  Container(color: Colors.grey.shade300),

              Container(color :Colors.grey.shade100,),

              // SPONSORED chip
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'SPONSORED',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ),

              // ✅ Play/Pause + Audio buttons (top-right row)
              if (showControls)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: _togglePlayPause,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.55),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _userPaused
                                ? Icons.play_arrow_rounded
                                : Icons.pause_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: _toggleAudio,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.55),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _isMuted
                                ? Icons.volume_off_rounded
                                : Icons.volume_up_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Title
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Text(
                  widget.ad.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Shimmer ──
class _AdShimmer extends StatelessWidget {
  const _AdShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      margin: const EdgeInsets.fromLTRB(12, 10, 12, 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// STICKY SEARCH
// ═══════════════════════════════════════════════════════════════
class _StickySearchBoxDelegate extends SliverPersistentHeaderDelegate {
  final VoidCallback onSearchTap;
  _StickySearchBoxDelegate({required this.onSearchTap});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: Container(
        width: double.infinity,
        height: maxExtent,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          border: Border.all(color: Colors.teal, width: 0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: onSearchTap,
          child: Row(
            children: [
              Icon(Icons.search, color: Colors.grey[600], size: 22),
              const SizedBox(width: 12),
              Text(
                "Search here...",
                style: TextStyle(color: Colors.grey[500], fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 70;

  @override
  double get minExtent => 70;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}

// ═══════════════════════════════════════════════════════════════
// CATEGORY SHIMMER GRID
// ═══════════════════════════════════════════════════════════════
class _CategoryShimmerGrid extends StatelessWidget {
  const _CategoryShimmerGrid();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildShimmerBox(width: 100, height: 16),
              _buildShimmerBox(width: 60, height: 14),
            ],
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1,
            ),
            itemCount: 8,
            itemBuilder: (context, index) => _buildShimmerTile(),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildShimmerBox({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildShimmerTile() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 40,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 2),
      ],
    );
  }
}