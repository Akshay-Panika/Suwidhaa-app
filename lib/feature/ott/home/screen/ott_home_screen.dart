import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/feature/ott/home/screen/play_dashboard_screen.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../../ads/controller/ott_ads_controller.dart';
import '../../ads/model/ott_ads_model.dart';
import '../../category/controller/ott_category_controller.dart';
import '../../category/widget/ott_category_widget.dart';
import '../../content/controller/ott_content_controller.dart';
import '../../content/model/ott_content_model.dart';
import '../../search/screen/search_movie_screen.dart';
import '../../banner/widget/movie_banner.dart';
import 'ott_view_all_screen.dart';

// ── YouTube helper ──
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

class OttHomeScreen extends StatefulWidget {
  const OttHomeScreen({super.key});

  @override
  State<OttHomeScreen> createState() => _OttHomeScreenState();
}

class _OttHomeScreenState extends State<OttHomeScreen>
    with WidgetsBindingObserver {
  bool isAdsVisible = true;

  bool _isBannerVisible = true;
  bool _scrollHidden = false;
  bool _routeHidden = false;
  bool _appHidden = false;

  final ScrollController _scrollController = ScrollController();

  final ValueNotifier<bool> _isScrolling = ValueNotifier<bool>(false);
  Timer? _scrollDebounce;

  final categoryCtrl = Get.find<OttCategoryController>();
  final contentCtrl = Get.find<OttContentController>();
  final adsCtrl = Get.find<OttAdsController>();

  // 🔒 Cached ad placement — computed ONCE per ads list, not on every rebuild
  String _adSignature = '';
  OttAdsModel? _topAd;
  final Map<int, OttAdsModel> _inlineAdBySection = {};

  void _updateBannerVisibility() {
    final newValue = !_scrollHidden && !_routeHidden && !_appHidden;
    if (newValue != _isBannerVisible) {
      setState(() => _isBannerVisible = newValue);
    }
  }

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

  // 🔒 Compute ad placements ONCE per ads list — stable across rebuilds
  void _computeAdPlacements() {
    final homeAds = adsCtrl.homeAds;
    final sig = homeAds.map((a) => a.id).join(',');
    if (sig == _adSignature) return; // no change — keep existing placement
    _adSignature = sig;

    _topAd = null;
    _inlineAdBySection.clear();

    if (homeAds.isEmpty) return;

    _topAd = homeAds.first;
    final remaining = homeAds.skip(1).toList();
    if (remaining.isEmpty) return;

    // Deterministic seed = same ads → same placement (no reshuffle)
    final seed = homeAds.fold<int>(
        0, (s, a) => s * 31 + a.id + a.title.length);
    final rng = Random(seed);

    final slots = List<int>.generate(6, (i) => i)..shuffle(rng);

    for (int i = 0; i < remaining.length && i < slots.length; i++) {
      _inlineAdBySection[slots[i]] = remaining[i];
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _scrollController.addListener(() {
      final hidden = _scrollController.offset >= 200;
      if (hidden != _scrollHidden) {
        _scrollHidden = hidden;
        _updateBannerVisibility();
      }
    });

    ever(categoryCtrl.selectedCategoryId, (id) {
      contentCtrl.getContents(categoryId: id);
    });

    // Recompute ad placements only when ads actually change
    ever(adsCtrl.ads, (_) => _computeAdPlacements());

    Future.microtask(() {
      contentCtrl.getContents(
          categoryId: categoryCtrl.selectedCategoryId.value);
      if (adsCtrl.ads.isEmpty) {
        adsCtrl.fetchAds();
      } else {
        _computeAdPlacements();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollDebounce?.cancel();
    _isScrolling.dispose();
    _scrollController.dispose();
    super.dispose();
  }

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
          NotificationListener<ScrollNotification>(
            onNotification: _onScrollNotification,
            child: RefreshIndicator(
              color: Colors.red,
              backgroundColor: Colors.grey[900],
              onRefresh: _refreshData,
              child: CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
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

                  SliverToBoxAdapter(
                    child: MovieBanner(isVisible: _isBannerVisible),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 16)),

                  // ── Top Ad (cached) ──
                  SliverToBoxAdapter(
                    child: Obx(() {
                      _computeAdPlacements();
                      if (_topAd == null || !isAdsVisible) {
                        return const SizedBox.shrink();
                      }
                      return _OttAdPlayer(
                        key: ValueKey('ott_top_ad_${_topAd!.id}'),
                        ad: _topAd!,
                        compact: false,
                        isScrolling: _isScrolling,
                        onTap: () => _handleAdTap(_topAd!),
                        onClose: () =>
                            setState(() => isAdsVisible = false),
                      );
                    }),
                  ),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: _buildAllSections(),
                    ),
                  ),
                ],
              ),
            ),
          ),

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

  Widget _buildAllSections() {
    return Obx(() {
      // Ads list hi cached hai, isliye rebuild pe reshuffle nahi hoga
      _computeAdPlacements();

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

      // Build sections with STABLE keys (based on title, not index)
      final List<(String, Widget)> contentSections = [];

      contentSections.add((
      'all',
      _buildContentSection(
        title: 'Watch Now',
        items: all,
        filterType: 'all',
      ),
      ));
      if (trending.isNotEmpty) {
        contentSections.add((
        'trending',
        _buildContentSection(
          title: 'Trending Now',
          items: trending,
          filterType: 'trending',
        ),
        ));
      }
      if (recommended.isNotEmpty) {
        contentSections.add((
        'recommended',
        _buildContentSection(
          title: 'Recommended',
          items: recommended,
          filterType: 'recommended',
        ),
        ));
      }
      if (newItems.isNotEmpty) {
        contentSections.add((
        'new',
        _buildContentSection(
          title: 'New Arrivals',
          items: newItems,
          filterType: 'new',
        ),
        ));
      }
      if (family.isNotEmpty) {
        contentSections.add((
        'family',
        _buildContentSection(
          title: 'Family Friendly',
          items: family,
          filterType: 'family',
        ),
        ));
      }
      if (premium.isNotEmpty) {
        contentSections.add((
        'premium',
        _buildContentSection(
          title: 'Premium',
          items: premium,
          filterType: 'premium',
        ),
        ));
      }

      final List<Widget> finalList = [];

      for (int i = 0; i < contentSections.length; i++) {
        final (sectionKey, widget) = contentSections[i];
        finalList.add(KeyedSubtree(
          key: ValueKey('section_$sectionKey'),
          child: widget,
        ));

        // Ad from cached placement (index-based)
        final ad = _inlineAdBySection[i];
        if (ad != null) {
          finalList.add(_OttAdPlayer(
            // ✅ Stable key — ad.id based, NOT section index
            key: ValueKey('ott_inline_ad_${ad.id}'),
            ad: ad,
            compact: true,
            isScrolling: _isScrolling,
            onTap: () => _handleAdTap(ad),
          ));
        }
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: finalList,
      );
    });
  }

  Widget _buildContentSection({
    required String title,
    required List<OttContentModel> items,
    String filterType = 'all',
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
                  onTap: () => _pauseNavigate(
                        () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OttViewAllScreen(
                          title: title,
                          filterType: filterType,
                          items: items,
                        ),
                      ),
                    ),
                  ),
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
              // ✅ Keep alive + stable keys = no scroll jump
              addAutomaticKeepAlives: true,
              itemBuilder: (context, index) {
                return _buildContentCard(items[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentCard(OttContentModel content) {
    return GestureDetector(
      // ✅ Stable key based on content ID, NOT index
      key: ValueKey('content_${content.id}'),
      onTap: () => _pauseNavigate(
            () async => Get.to(() => PlayDashboardScreen(content: content)),
      ),
      child: Container(
        width: 130,
        margin: const EdgeInsets.only(right: 4),
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
}

// ═══════════════════════════════════════════════════════════════
// AD PLAYER — visibility-gated autoplay, muted by default
// ═══════════════════════════════════════════════════════════════
class _OttAdPlayer extends StatefulWidget {
  final OttAdsModel ad;
  final bool compact;
  final ValueNotifier<bool> isScrolling;
  final VoidCallback onTap;
  final VoidCallback? onClose;

  const _OttAdPlayer({
    super.key,
    required this.ad,
    required this.compact,
    required this.isScrolling,
    required this.onTap,
    this.onClose,
  });

  @override
  State<_OttAdPlayer> createState() => _OttAdPlayerState();
}

class _OttAdPlayerState extends State<_OttAdPlayer>
    with WidgetsBindingObserver {
  VideoPlayerController? _video;
  bool _videoReady = false;
  bool _videoFailed = false;

  YoutubePlayerController? _ytCtrl;
  String? _ytId;

  bool _isVisible = false;
  bool _isMuted = true;
  bool _appPaused = false;
  bool _userPaused = false;

  bool get _isWebYouTube => kIsWeb && _ytId != null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    widget.isScrolling.addListener(_syncPlayback);

    if (!widget.ad.hasVideo) return;

    _ytId = _extractYoutubeId(widget.ad.videoUrl!);

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
      _initVideo(widget.ad.videoUrl!);
    }
  }

  Future<void> _initVideo(String rawUrl) async {
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
          streams.sort((a, b) =>
              a.videoResolution.height.compareTo(b.videoResolution.height));
          final upTo720 =
          streams.where((s) => s.videoResolution.height <= 720).toList();
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
      if (mounted) {
        setState(() => _videoReady = true);
        _syncPlayback();
      }
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
        if (!v.value.isPlaying) _tryPlayMobile(v);
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

  void _tryPlayMobile(VideoPlayerController v) {
    try {
      v.play();
    } catch (_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted && v.value.isInitialized && !v.value.isPlaying) {
          try {
            v.play();
          } catch (_) {}
        }
      });
    }
  }

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

  Widget _buildMedia() {
    final showIframe = _isWebYouTube;
    final showVideo = !showIframe &&
        widget.ad.hasVideo &&
        _videoReady &&
        _video != null &&
        !_videoFailed;
    final showImage = !showIframe && !showVideo && widget.ad.hasImage;

    if (showIframe) {
      return FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: 320,
          height: 180,
          child: YoutubePlayer(
            controller: _ytCtrl!,
            aspectRatio: 16 / 9,
          ),
        ),
      );
    }
    if (showVideo) {
      return FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: _video!.value.size.width,
          height: _video!.value.size.height,
          child: VideoPlayer(_video!),
        ),
      );
    }
    if (showImage) {
      return Image.network(
        widget.ad.image!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(color: Colors.grey[900]),
      );
    }
    return Container(color: Colors.grey[900]);
  }

  bool get _showControls =>
      (widget.ad.hasVideo && !_videoFailed) || _isWebYouTube;

  @override
  Widget build(BuildContext context) {
    final height = widget.compact ? 120.0 : 160.0;
    final margin = widget.compact
        ? const EdgeInsets.only(bottom: 24, left: 16, right: 16)
        : const EdgeInsets.symmetric(horizontal: 16);

    return VisibilityDetector(
      key: Key(
          'ott_ad_${widget.ad.id}_${widget.compact ? 'inline' : 'top'}'),
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
          height: height,
          margin: margin,
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white12),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              _buildMedia(),
              Container(color: Colors.black.withOpacity(0.28)),

              if (_showControls)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _circleBtn(
                        icon: _userPaused
                            ? Icons.play_arrow_rounded
                            : Icons.pause_rounded,
                        onTap: _togglePlayPause,
                      ),
                      const SizedBox(width: 6),
                      _circleBtn(
                        icon: _isMuted
                            ? Icons.volume_off_rounded
                            : Icons.volume_up_rounded,
                        onTap: _toggleAudio,
                      ),
                    ],
                  ),
                ),

              Positioned(
                top: 8,
                right: 8,
                child: widget.compact
                    ? _buildSponsoredChip(compact: true)
                    : _buildCloseButton(),
              ),

              Positioned(
                bottom: 12,
                left: 16,
                right: 16,
                child: widget.compact
                    ? _buildInlineContent()
                    : _buildTopContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _circleBtn({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }

  Widget _buildCloseButton() {
    return GestureDetector(
      onTap: widget.onClose,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.close, color: Colors.white, size: 18),
      ),
    );
  }

  Widget _buildSponsoredChip({bool compact = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: compact ? Colors.black54 : Colors.red,
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text(
        'SPONSORED',
        style: TextStyle(
            color: Colors.white,
            fontSize: 9,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTopContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSponsoredChip(),
        const SizedBox(height: 6),
        Text(
          widget.ad.title,
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
    );
  }

  Widget _buildInlineContent() {
    return Row(
      children: [
        Expanded(
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
        const SizedBox(width: 8),
        const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14),
      ],
    );
  }
}

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