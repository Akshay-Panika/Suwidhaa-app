import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import '../controller/record_video_controller.dart';
import '../model/record_video_model.dart';

// ============================================================
// YouTube helpers
// ============================================================

/// Extracts the 11-char video id from any YouTube url type.
/// Returns null if the url is not a YouTube url.
String? extractYoutubeId(String raw) {
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

// ============================================================
// SHIMMER HELPER
// ============================================================

Widget shimmerBox({double? w, double? h, double r = 8}) {
  return Shimmer.fromColors(
    baseColor: const Color(0xFF1C1C22),
    highlightColor: const Color(0xFF32323C),
    child: Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(r),
      ),
    ),
  );
}

// ============================================================
// SCHOOL VIDEO PLAYER
// ============================================================

class _CachedStream {
  final String url;
  final DateTime time;
  _CachedStream(this.url, this.time);
}

class SchoolVideoPlayer extends StatefulWidget {
  final String url;
  final String title;
  final bool isFullscreen;
  final VoidCallback onToggleFullscreen;

  const SchoolVideoPlayer({
    super.key,
    required this.url,
    required this.title,
    required this.isFullscreen,
    required this.onToggleFullscreen,
  });

  @override
  State<SchoolVideoPlayer> createState() => _SchoolVideoPlayerState();
}

class _SchoolVideoPlayerState extends State<SchoolVideoPlayer> {
  static const Color _accent = Colors.white;
  static const List<double> _speeds = [0.75, 1.0, 1.25, 1.5, 2.0];
  static final Map<String, _CachedStream> _streamCache = {};

  VideoPlayerController? _vc;
  bool _loading = true;
  bool _error = false;
  bool _controlsVisible = true;
  bool _muted = false;
  bool _dragging = false;
  double _dragValue = 0;
  double _doubleTapX = 0;
  int _speedIndex = 1;
  int _token = 0;
  Timer? _hideTimer;

  // ------------------------------------------------------------
  // Lifecycle
  // ------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didUpdateWidget(covariant SchoolVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _init();
    }
  }

  @override
  void dispose() {
    _token++;
    _hideTimer?.cancel();
    _vc?.removeListener(_onTick);
    _vc?.dispose();
    super.dispose();
  }

  // ------------------------------------------------------------
  // Load video
  // ------------------------------------------------------------
  Future<String> _resolveUrl(String url, {bool fresh = false}) async {
    final id = extractYoutubeId(url);
    if (id == null) return url; // normal mp4 / network url

    final cached = _streamCache[id];
    if (!fresh &&
        cached != null &&
        DateTime.now().difference(cached.time) < const Duration(hours: 2)) {
      return cached.url;
    }

    final yt = YoutubeExplode();
    try {
      final manifest = await yt.videos.streamsClient
          .getManifest(id)
          .timeout(const Duration(seconds: 25));

      final streams = manifest.muxed.toList();
      if (streams.isEmpty) throw Exception('No playable stream');

      streams.sort((a, b) =>
          a.videoResolution.height.compareTo(b.videoResolution.height));
      final upTo720 =
      streams.where((s) => s.videoResolution.height <= 720).toList();
      final chosen = upTo720.isNotEmpty ? upTo720.last : streams.first;

      final resolved = chosen.url.toString();
      _streamCache[id] = _CachedStream(resolved, DateTime.now());
      return resolved;
    } finally {
      yt.close();
    }
  }

  Future<void> _init({bool fresh = false}) async {
    final token = ++_token;

    final old = _vc;
    old?.removeListener(_onTick);

    _hideTimer?.cancel();
    setState(() {
      _vc = null;
      _loading = true;
      _error = false;
      _controlsVisible = true;
      _dragging = false;
      _speedIndex = 1;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => old?.dispose());

    try {
      final resolved = await _resolveUrl(widget.url, fresh: fresh);

      final c = VideoPlayerController.networkUrl(
        Uri.parse(resolved),
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );
      await c.initialize();

      if (!mounted || token != _token) {
        await c.dispose();
        return;
      }

      c.setLooping(false);
      c.setVolume(_muted ? 0 : 1);
      c.addListener(_onTick);
      await c.play();

      setState(() {
        _vc = c;
        _loading = false;
      });
      _scheduleHide();
    } catch (e) {
      if (!mounted || token != _token) return;
      setState(() {
        _loading = false;
        _error = true;
      });
    }
  }

  void _onTick() {
    if (!mounted) return;
    final c = _vc;
    if (c != null && c.value.hasError && !_error) {
      setState(() => _error = true);
      return;
    }
    setState(() {});
  }

  // ------------------------------------------------------------
  // Controls logic
  // ------------------------------------------------------------
  bool _isEnded(VideoPlayerValue v) =>
      v.isInitialized &&
          v.duration > Duration.zero &&
          v.position >= v.duration - const Duration(milliseconds: 300) &&
          !v.isPlaying;

  void _scheduleHide() {
    _hideTimer?.cancel();
    final c = _vc;
    if (c == null || !c.value.isPlaying || _dragging) return;
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => _controlsVisible = false);
    });
  }

  void _toggleControls() {
    setState(() => _controlsVisible = !_controlsVisible);
    if (_controlsVisible) _scheduleHide();
  }

  void _togglePlay() {
    final c = _vc;
    if (c == null) return;
    final v = c.value;
    if (_isEnded(v)) {
      c.seekTo(Duration.zero);
      c.play();
    } else if (v.isPlaying) {
      c.pause();
      _hideTimer?.cancel();
    } else {
      c.play();
    }
    setState(() => _controlsVisible = true);
    _scheduleHide();
  }

  void _seekBy(Duration offset) {
    final c = _vc;
    if (c == null) return;
    final total = c.value.duration;
    var target = c.value.position + offset;
    if (target < Duration.zero) target = Duration.zero;
    if (target > total) target = total;
    c.seekTo(target);
    setState(() => _controlsVisible = true);
    _scheduleHide();
  }

  void _toggleMute() {
    final c = _vc;
    if (c == null) return;
    setState(() => _muted = !_muted);
    c.setVolume(_muted ? 0 : 1);
    _scheduleHide();
  }

  void _cycleSpeed() {
    final c = _vc;
    if (c == null) return;
    _speedIndex = (_speedIndex + 1) % _speeds.length;
    c.setPlaybackSpeed(_speeds[_speedIndex]);
    setState(() {});
    _scheduleHide();
  }

  String _fmt(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    if (d.inHours > 0) {
      return '${d.inHours}:${two(d.inMinutes.remainder(60))}:${two(d.inSeconds.remainder(60))}';
    }
    return '${two(d.inMinutes)}:${two(d.inSeconds.remainder(60))}';
  }

  // ------------------------------------------------------------
  // UI
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return ColoredBox(color: Colors.black, child: _buildBody());
  }

  Widget _buildBody() {
    if (_error) return _buildError();

    final c = _vc;
    if (_loading || c == null || !c.value.isInitialized) {
      return _buildShimmerCover();
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Center(
          child: AspectRatio(
            aspectRatio: c.value.aspectRatio,
            child: VideoPlayer(c),
          ),
        ),
        _buildOverlay(c),
      ],
    );
  }

  Widget _fullscreenBackButton() {
    return SafeArea(
      child: Align(
        alignment: Alignment.topLeft,
        child: IconButton(
          onPressed: widget.onToggleFullscreen,
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 20),
        ),
      ),
    );
  }

  Widget _buildShimmerCover() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Shimmer.fromColors(
          baseColor: const Color(0xFF1A1A1F),
          highlightColor: const Color(0xFF2E2E36),
          child: Container(color: Colors.white),
        ),
        const Center(
          child: Icon(Icons.play_circle_outline_rounded,
              color: Colors.white24, size: 56),
        ),
        if (widget.isFullscreen) _fullscreenBackButton(),
      ],
    );
  }

  Widget _buildError() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline,
                    color: Colors.redAccent, size: 34),
                const SizedBox(height: 6),
                const Text(
                  'Could not play this video.\nCheck the link or your internet.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: () => _init(fresh: true),
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Retry'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _accent,
                    side: const BorderSide(color: _accent),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (widget.isFullscreen) _fullscreenBackButton(),
      ],
    );
  }

  Widget _buildOverlay(VideoPlayerController c) {
    final v = c.value;
    final show = _controlsVisible || !v.isPlaying || _isEnded(v);

    return LayoutBuilder(
      builder: (context, cons) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _toggleControls,
          onDoubleTapDown: (d) => _doubleTapX = d.localPosition.dx,
          onDoubleTap: () => _seekBy(
            Duration(seconds: _doubleTapX < cons.maxWidth / 2 ? -10 : 10),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              IgnorePointer(
                child: AnimatedOpacity(
                  opacity: show ? 1 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.55),
                          Colors.black.withOpacity(0.1),
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (v.isBuffering)
                const Center(
                  child: SizedBox(
                    width: 36,
                    height: 36,
                    child: CircularProgressIndicator(
                        color: _accent, strokeWidth: 3),
                  ),
                ),
              IgnorePointer(
                ignoring: !show,
                child: AnimatedOpacity(
                  opacity: show ? 1 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: _buildControls(c),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildControls(VideoPlayerController c) {
    final v = c.value;
    final fs = widget.isFullscreen;
    final ended = _isEnded(v);

    final totalMs = v.duration.inMilliseconds > 0
        ? v.duration.inMilliseconds.toDouble()
        : 1.0;
    final posMs =
    (_dragging ? _dragValue : v.position.inMilliseconds.toDouble())
        .clamp(0.0, totalMs)
        .toDouble();
    final bufMs = v.buffered.isNotEmpty
        ? v.buffered.last.end.inMilliseconds.toDouble().clamp(0.0, totalMs)
        : 0.0;

    final shownPos = Duration(milliseconds: posMs.round());

    final content = Column(
      children: [
        // ---------- top bar ----------
        Padding(
          padding: EdgeInsets.fromLTRB(fs ? 4 : 12, 4, 4, 0),
          child: Row(
            children: [
              if (fs)
                IconButton(
                  onPressed: widget.onToggleFullscreen,
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white, size: 20),
                ),
              Expanded(
                child: fs
                    ? Text(
                  widget.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                )
                    : const SizedBox.shrink(),
              ),
              IconButton(
                onPressed: _toggleMute,
                icon: Icon(
                  _muted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),

        // ---------- center buttons ----------
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _circleButton(Icons.replay_10_rounded, 30,
                    () => _seekBy(const Duration(seconds: -10))),
            const SizedBox(width: 24),
            if (!v.isBuffering)
              _circleButton(
                ended
                    ? Icons.replay_rounded
                    : (v.isPlaying
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded),
                40,
                _togglePlay,
                filled: true,
              )
            else
              const SizedBox(width: 64, height: 64),
            const SizedBox(width: 24),
            _circleButton(Icons.forward_10_rounded, 30,
                    () => _seekBy(const Duration(seconds: 10))),
          ],
        ),
        const Spacer(),

        // ---------- bottom bar ----------
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 4, 4),
          child: Row(
            children: [
              Text(
                '${_fmt(shownPos)} / ${_fmt(v.duration)}',
                style: const TextStyle(color: Colors.white, fontSize: 11),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 3,
                    thumbShape:
                    const RoundSliderThumbShape(enabledThumbRadius: 6),
                    overlayShape:
                    const RoundSliderOverlayShape(overlayRadius: 14),
                    activeTrackColor: _accent,
                    inactiveTrackColor: Colors.white24,
                    secondaryActiveTrackColor: Colors.white54,
                    thumbColor: _accent,
                  ),
                  child: Slider(
                    min: 0,
                    max: totalMs,
                    value: posMs,
                    secondaryTrackValue: bufMs,
                    onChangeStart: (val) {
                      _hideTimer?.cancel();
                      setState(() {
                        _dragging = true;
                        _dragValue = val;
                      });
                    },
                    onChanged: (val) => setState(() => _dragValue = val),
                    onChangeEnd: (val) {
                      c.seekTo(Duration(milliseconds: val.round()));
                      setState(() => _dragging = false);
                      _scheduleHide();
                    },
                  ),
                ),
              ),
              InkWell(
                onTap: _cycleSpeed,
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                  child: Text(
                    '${_speeds[_speedIndex]}x',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: widget.onToggleFullscreen,
                icon: Icon(
                  fs ? Icons.fullscreen_exit_rounded : Icons.fullscreen_rounded,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    return fs ? SafeArea(child: content) : content;
  }

  Widget _circleButton(
      IconData icon,
      double size,
      VoidCallback onTap, {
        bool filled = false,
      }) {
    return Material(
      color: filled ? Colors.black45 : Colors.black45,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(filled ? 12 : 8),
          child: Icon(icon, color: Colors.white, size: size),
        ),
      ),
    );
  }
}

// ============================================================
// SCREEN 1: CLASS SELECTION
// ============================================================

class OttSchoolScreen extends StatefulWidget {
  const OttSchoolScreen({super.key});

  @override
  State<OttSchoolScreen> createState() => _OttSchoolScreenState();
}

class _OttSchoolScreenState extends State<OttSchoolScreen> {
  final RecordVideoController controller = Get.put(RecordVideoController());

  static const Color _bg = Color(0xFF0B0B0F);

  void _openClass(dynamic classItem) {
    controller.selectClass(classItem);
    // Naya screen (naya Scaffold). Back aane par selection clear.
    Get.to(() => const SchoolVideosScreen())
        ?.then((_) => controller.clearSelection());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        automaticallyImplyLeading: false,
      toolbarHeight: 0,),
      // appBar: AppBar(
      //   backgroundColor: _bg,
      //   elevation: 0,
      //   automaticallyImplyLeading: false,
      //   titleSpacing: 16,
      //   title: const Text(
      //     '🎓 School',
      //     style: TextStyle(
      //       color: Colors.white,
      //       fontSize: 22,
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),
      // ),
      body: Obx(_buildClassSelection),
    );
  }

  Widget _buildClassSkeleton() {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        shimmerBox(w: 170, h: 22),
        const SizedBox(height: 8),
        shimmerBox(w: 240, h: 14),
        const SizedBox(height: 24),
        shimmerBox(w: 110, h: 16),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.05,
          ),
          itemCount: 9,
          itemBuilder: (_, __) => shimmerBox(r: 16),
        ),
      ],
    );
  }

  Widget _buildClassSelection() {
    if (controller.isLoadingClasses.value) {
      return _buildClassSkeleton();
    }

    final classes = controller.classes;
    if (classes.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.school_outlined, size: 64, color: Colors.grey[700]),
            const SizedBox(height: 12),
            Text('No classes found',
                style: TextStyle(color: Colors.grey[500], fontSize: 16)),
          ],
        ),
      );
    }

    final sections = <_ClassSection>[
      _ClassSection('Pre-Primary', Colors.pink, Icons.child_care, 0, 3),
      _ClassSection('Primary', Colors.orange, Icons.school, 3, 8),
      _ClassSection('Middle', Colors.blue, Icons.menu_book, 8, 11),
      _ClassSection('Secondary & Senior', Colors.purple,
          Icons.workspace_premium, 11, classes.length),
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        const Text(
          'Select your class',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          'Choose a class to see subject-wise videos',
          style: TextStyle(color: Colors.grey[500], fontSize: 13),
        ),
        const SizedBox(height: 20),
        for (final s in sections)
          if (s.start < classes.length) ...[
            _buildSectionHeader(s),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.05,
              ),
              itemCount:
              (s.end > classes.length ? classes.length : s.end) - s.start,
              itemBuilder: (context, i) =>
                  _buildClassCard(classes[s.start + i], s),
            ),
            const SizedBox(height: 22),
          ],
      ],
    );
  }

  Widget _buildSectionHeader(_ClassSection s) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: s.color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          s.title,
          style: const TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildClassCard(dynamic classItem, _ClassSection s) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [s.color.withOpacity(0.3), s.color.withOpacity(0.08)],
        ),
        border: Border.all(color: s.color.withOpacity(0.5), width: 1.2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _openClass(classItem),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(s.icon, color: s.color, size: 30),
                const SizedBox(height: 8),
                Text(
                  classItem.name,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${classItem.videoCount} videos',
                  style: TextStyle(color: Colors.grey[400], fontSize: 10),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// SCREEN 2: VIDEOS (new Scaffold)
// ============================================================

class SchoolVideosScreen extends StatefulWidget {
  const SchoolVideosScreen({super.key});

  @override
  State<SchoolVideosScreen> createState() => _SchoolVideosScreenState();
}

class _SchoolVideosScreenState extends State<SchoolVideosScreen> {
  final RecordVideoController controller = Get.find<RecordVideoController>();

  static const Color _accent = Colors.white;
  static const Color _bg = Color(0xFF0B0B0F);
  static const Color _card = Color(0xFF16161A);

  late final String _className;
  RecordVideoModel? _current;
  bool _isFullscreen = false;

  // GlobalKey keeps the same player (and its position) when switching
  // between normal and fullscreen layout.
  final GlobalKey _playerKey = GlobalKey();

  // ------------------------------------------------------------
  // Lifecycle
  // ------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    _className = controller.selectedClass.value?.name ?? '';
  }

  @override
  void dispose() {
    if (_isFullscreen) {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
    super.dispose();
  }

  // ------------------------------------------------------------
  // Fullscreen / playback
  // ------------------------------------------------------------
  Future<void> _setFullscreen(bool value) async {
    if (value == _isFullscreen) return;
    setState(() => _isFullscreen = value);

    if (value) {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }

  void _playVideo(RecordVideoModel video) {
    if (_current?.id == video.id) return;
    setState(() => _current = video);
  }

  void _stopPlayback() {
    if (_isFullscreen) _setFullscreen(false);
    setState(() => _current = null);
  }

  // ------------------------------------------------------------
  // BUILD
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isFullscreen,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _setFullscreen(false); // fullscreen me back = sirf fullscreen band
      },
      child: Scaffold(
        backgroundColor: _bg,
        appBar: _isFullscreen
            ? null
            : AppBar(
          backgroundColor: _bg,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white, size: 20),
          ),
          titleSpacing: 0,
          title: Text(
            "$_className Class",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Obx(_buildVideoScreen),
      ),
    );
  }

  Widget _buildPlayer(RecordVideoModel video) {
    return SchoolVideoPlayer(
      key: _playerKey,
      url: video.videoUrl.trim(),
      title: video.title,
      isFullscreen: _isFullscreen,
      onToggleFullscreen: () => _setFullscreen(!_isFullscreen),
    );
  }

  Widget _buildVideoScreen() {
    final loadingVideos = controller.isLoadingVideos.value;
    final videos = controller.videos.toList();
    final width = MediaQuery.of(context).size.width;
    final columns = width >= 900 ? 4 : (width >= 600 ? 3 : 2);

    // Fullscreen: only the player, filling the whole screen
    if (_isFullscreen && _current != null) {
      return SizedBox.expand(child: _buildPlayer(_current!));
    }

    final gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: columns,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 0.82,
    );

    return Column(
      children: [
        // Player stays pinned at the top while the list scrolls below it
        if (_current != null) _buildPlayerSection(_current!),
        Expanded(
          key: const ValueKey('video-list'),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildSubjectChips()),
              if (loadingVideos)
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                  sliver: SliverGrid(
                    gridDelegate: gridDelegate,
                    delegate: SliverChildBuilderDelegate(
                          (context, index) => _buildVideoSkeleton(),
                      childCount: 6,
                    ),
                  ),
                )
              else if (videos.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.video_library_outlined,
                            color: Colors.grey[700], size: 64),
                        const SizedBox(height: 12),
                        Text('No videos found',
                            style: TextStyle(
                                color: Colors.grey[500], fontSize: 16)),
                      ],
                    ),
                  ),
                )
              else ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
                      child: Text(
                        '${videos.length} videos',
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    sliver: SliverGrid(
                      gridDelegate: gridDelegate,
                      delegate: SliverChildBuilderDelegate(
                            (context, index) => _buildVideoCard(videos[index]),
                        childCount: videos.length,
                      ),
                    ),
                  ),
                ],
            ],
          ),
        ),
      ],
    );
  }

  // ==================== PLAYER SECTION (normal mode) ====================
  Widget _buildPlayerSection(RecordVideoModel video) {
    return Container(
      key: const ValueKey('player-section'),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.black,
        border: Border(bottom: BorderSide(color: Colors.white10)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: _buildPlayer(video),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 4, 4),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        video.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${video.subjectName} • ${video.className}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Close player',
                  onPressed: _stopPlayback,
                  icon: const Icon(Icons.close_rounded, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== SUBJECT CHIPS ====================
  Widget _buildSubjectChips() {
    if (controller.isLoadingSubjects.value) {
      return SizedBox(
        height: 56,
        child: ListView(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          children: List.generate(
            4,
                (i) => Padding(
              padding: const EdgeInsets.only(right: 10),
              child: shimmerBox(w: 64.0 + i * 10, r: 20),
            ),
          ),
        ),
      );
    }

    final subjects = controller.subjects.toList();
    final selectedId = controller.selectedSubjectId.value;

    return SizedBox(
      height: 56,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemCount: subjects.length + 1,
        itemBuilder: (context, index) {
          final isAll = index == 0;
          final subject = isAll ? null : subjects[index - 1];
          final isSelected =
          isAll ? selectedId == null : selectedId == subject?.id;

          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => controller.selectSubject(isAll ? null : subject?.id),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? _accent : const Color(0xFF1C1C22),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? _accent : Colors.white12,
                  ),
                ),
                child: Text(
                  isAll ? 'All' : subject!.name,
                  style: TextStyle(
                    color: isSelected ? Colors.black : Colors.grey[400],
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ==================== VIDEO CARD ====================
  String _thumbFor(RecordVideoModel v) {
    if (v.thumbnail.isNotEmpty) return v.thumbnail;
    final id = extractYoutubeId(v.videoUrl);
    if (id != null) return 'https://img.youtube.com/vi/$id/hqdefault.jpg';
    return '';
  }

  Widget _thumbPlaceholder() => Container(
    color: Colors.grey[900],
    child: const Icon(Icons.play_circle_outline, color: _accent, size: 44),
  );

  Widget _buildVideoSkeleton() {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(aspectRatio: 16 / 9, child: shimmerBox(r: 0)),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                shimmerBox(h: 12),
                const SizedBox(height: 6),
                shimmerBox(w: 90, h: 12),
                const SizedBox(height: 10),
                shimmerBox(w: 60, h: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoCard(RecordVideoModel video) {
    final isPlaying = _current?.id == video.id;
    final thumb = _thumbFor(video);

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPlaying ? _accent : Colors.white10,
          width: isPlaying ? 1 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _playVideo(video),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      thumb.isEmpty
                          ? _thumbPlaceholder()
                          : Image.network(
                        thumb,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return shimmerBox(r: 0);
                        },
                        errorBuilder: (_, __, ___) => _thumbPlaceholder(),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.45),
                            ],
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.55),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isPlaying
                                ? Icons.graphic_eq_rounded
                                : Icons.play_arrow_rounded,
                            color: Colors.black,
                            size: 26,
                          ),
                        ),
                      ),
                      if (isPlaying)
                        Positioned(
                          top: 6,
                          left: 6,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(
                              color: _accent,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'NOW PLAYING',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
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
                            video.duration,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      video.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isPlaying ? _accent : Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        height: 1.25,
                      ),
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: _accent.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              video.subjectName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.orangeAccent,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.star_rounded,
                            color: Colors.amber, size: 14),
                        const SizedBox(width: 2),
                        Text(
                          video.rating.toString(),
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 11),
                        ),
                      ],
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
}

class _ClassSection {
  final String title;
  final Color color;
  final IconData icon;
  final int start;
  final int end;
  const _ClassSection(this.title, this.color, this.icon, this.start, this.end);
}