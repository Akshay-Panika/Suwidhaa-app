import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../controller/ott_banner_controller.dart';
import '../model/ott_banner_model.dart';

const String kYoutubeOrigin = 'https://www.youtube-nocookie.com';
const double kYtZoom = 1.5;

final ValueNotifier<bool> _bannerMuted = ValueNotifier<bool>(false);
final ValueNotifier<bool> _bannerPaused = ValueNotifier<bool>(false);

class MovieBanner extends StatefulWidget {
  // ✅ Screen se visibility track karne ke liye naya parameter
  final bool isVisible;

  const MovieBanner({super.key, this.isVisible = true});

  @override
  State<MovieBanner> createState() => _MovieBannerState();
}

class _MovieBannerState extends State<MovieBanner> {
  final OttBannerController controller = Get.find<OttBannerController>();
  final CarouselSliderController _carouselController = CarouselSliderController();

  static const _imageDuration = Duration(seconds: 4);
  static const _videoSafetyTimeout = Duration(seconds: 90);

  int _currentIndex = 0;
  Timer? _timer;
  Worker? _bannersWorker;

  @override
  void initState() {
    super.initState();
    _bannersWorker = ever(controller.banners, (_) {
      if (_currentIndex >= controller.banners.length) _currentIndex = 0;
      _scheduleNext();
    });

    // ✅ Pause/Play state change par timer ko handle karne ke liye listener
    _bannerPaused.addListener(_onPauseChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) => _scheduleNext());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _bannersWorker?.dispose();
    _bannerPaused.removeListener(_onPauseChanged);
    super.dispose();
  }

  // ✅ Screen switch hone par carousel timer cancel karo
  @override
  void didUpdateWidget(covariant MovieBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _scheduleNext();
      } else {
        _timer?.cancel();
      }
    }
  }

  void _onPauseChanged() {
    if (!_bannerPaused.value) {
      // User ne resume kiya to safety timeout wapas start karo
      _scheduleNext();
    } else {
      // User ne pause kiya to timer ko reset karke 4 sec par slide karwao
      _scheduleNext();
    }
  }

  bool _isPlayable(OttBannerModel b) =>
      b.isPlay && (b.videoUrl?.isNotEmpty ?? false);

  bool get _currentIsPlayable {
    if (_currentIndex >= controller.banners.length) return false;
    return _isPlayable(controller.banners[_currentIndex]);
  }

  void _scheduleNext() {
    _timer?.cancel();
    // Agar screen visible nahi hai to timer mat chalao
    if (!mounted || controller.banners.length <= 1 || !widget.isVisible) return;

    // ✅ Agar user ne video pause kiya hai, to usko image ki tarah treat karo (4 sec me slide karo)
    final isPaused = _currentIsPlayable && _bannerPaused.value;
    final delay = (_currentIsPlayable && !isPaused) ? _videoSafetyTimeout : _imageDuration;

    _timer = Timer(delay, _goNext);
  }

  void _goNext() {
    if (!mounted || controller.banners.length <= 1 || !widget.isVisible) return;
    _timer?.cancel();
    _carouselController.nextPage(
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.banners.isEmpty) {
        return const _BannerShimmer();
      }
      if (controller.banners.isEmpty) return const SizedBox.shrink();

      if (_currentIndex >= controller.banners.length) _currentIndex = 0;

      final count = controller.banners.length;

      return SizedBox(
        height: 240,
        child: Stack(
          children: [
            CarouselSlider(
              controller: _carouselController,
              items: controller.banners.asMap().entries.map((entry) {
                final index = entry.key;
                return _buildBannerItem(
                  banner: entry.value,
                  isCurrent: index == _currentIndex,
                  singleBanner: count == 1,
                  onVideoEnd: () {
                    if (index == _currentIndex) _goNext();
                  },
                );
              }).toList(),
              options: CarouselOptions(
                autoPlay: false, // Manual timer use kar rahe hain
                enlargeCenterPage: false,
                enableInfiniteScroll: count > 1,
                viewportFraction: 1.0,
                height: 240,
                onPageChanged: (index, reason) {
                  _bannerPaused.value = false; // New slide par pause reset karo
                  setState(() => _currentIndex = index);
                  _scheduleNext();
                },
              ),
            ),
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    count,
                        (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentIndex == index ? 16 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: _currentIndex == index
                            ? Colors.red
                            : Colors.grey.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildBannerItem({
    required OttBannerModel banner,
    required bool isCurrent,
    required bool singleBanner,
    required VoidCallback onVideoEnd,
  }) {
    final poster = _Poster(url: banner.image);

    return SizedBox.expand(
      child: Container(
        color: Colors.black,
        child: _isPlayable(banner)
            ? _BannerVideo(
          key: ValueKey('banner_video_${banner.id}'),
          videoUrl: banner.videoUrl!,
          poster: poster,
          active: isCurrent && widget.isVisible, // ✅ Visibility logic
          loop: singleBanner,
          onFinished: onVideoEnd,
          onFailed: () {
            if (isCurrent) {
              Future.delayed(const Duration(seconds: 1), onVideoEnd);
            }
          },
        )
            : poster,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Baaki widgets (Poster, Loader, Mute button, Pause icon, Seek bar, Videos) same rahenge
// ─────────────────────────────────────────────────────────────────────────────

class _Poster extends StatelessWidget {
  final String url;
  const _Poster({required this.url});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Image.network(
        url,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return const _ImageShimmer();
        },
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.grey[800],
          child: const Center(
            child: Icon(Icons.image_not_supported, color: Colors.grey, size: 50),
          ),
        ),
      ),
    );
  }
}

class _PosterOverlay extends StatelessWidget {
  final Widget poster;
  final bool videoVisible;
  final bool showLoader;

  const _PosterOverlay({
    required this.poster,
    required this.videoVisible,
    required this.showLoader,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 350),
        opacity: videoVisible ? 0 : 1,
        child: Stack(
          fit: StackFit.expand,
          children: [
            poster,
            if (showLoader)
              const Center(
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MuteButton extends StatelessWidget {
  const _MuteButton();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      right: 10,
      child: ValueListenableBuilder<bool>(
        valueListenable: _bannerMuted,
        builder: (context, muted, _) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _bannerMuted.value = !muted,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: Icon(
                muted ? Icons.volume_off : Icons.volume_up,
                color: Colors.white,
                size: 20,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PauseIcon extends StatelessWidget {
  final bool visible;
  const _PauseIcon({required this.visible});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Center(
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: visible ? 1 : 0,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.black54,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.play_arrow_rounded,
                color: Colors.white, size: 44),
          ),
        ),
      ),
    );
  }
}

String _fmt(Duration d) {
  final m = d.inMinutes.remainder(60).toString().padLeft(1, '0');
  final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
  return d.inHours > 0 ? '${d.inHours}:${m.padLeft(2, '0')}:$s' : '$m:$s';
}

class _SeekBar extends StatefulWidget {
  final double progress;
  final Duration duration;
  final ValueChanged<double> onSeek;

  const _SeekBar({
    required this.progress,
    required this.duration,
    required this.onSeek,
  });

  @override
  State<_SeekBar> createState() => _SeekBarState();
}

class _SeekBarState extends State<_SeekBar> {
  double? _drag;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      height: 32,
      child: LayoutBuilder(
        builder: (context, box) {
          final w = box.maxWidth;
          double frac(double dx) => (dx / w).clamp(0.0, 1.0);

          final dragging = _drag != null;
          final value = (_drag ?? widget.progress).clamp(0.0, 1.0);
          final barH = dragging ? 6.0 : 3.0;
          final thumb = dragging ? 16.0 : 10.0;
          final thumbLeft = (value * w - thumb / 2).clamp(0.0, w - thumb);
          final labelLeft = (value * w - 45).clamp(0.0, w - 90);

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapUp: (d) => widget.onSeek(frac(d.localPosition.dx)),
            onHorizontalDragStart: (d) =>
                setState(() => _drag = frac(d.localPosition.dx)),
            onHorizontalDragUpdate: (d) =>
                setState(() => _drag = frac(d.localPosition.dx)),
            onHorizontalDragEnd: (_) {
              final v = _drag;
              setState(() => _drag = null);
              if (v != null) widget.onSeek(v);
            },
            onHorizontalDragCancel: () => setState(() => _drag = null),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 6,
                  height: barH,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(color: Colors.white24),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: FractionallySizedBox(
                          widthFactor: value,
                          child: Container(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: thumbLeft,
                  bottom: 6 + barH / 2 - thumb / 2,
                  child: Container(
                    width: thumb,
                    height: thumb,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                if (dragging && widget.duration > Duration.zero)
                  Positioned(
                    left: labelLeft,
                    bottom: 26,
                    width: 90,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${_fmt(widget.duration * value)} / ${_fmt(widget.duration)}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 11),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

String? _youtubeIdFrom(String url) {
  final uri = Uri.tryParse(url.trim());
  if (uri == null) return null;
  final host = uri.host.toLowerCase();
  if (!host.contains('youtube.com') && !host.contains('youtu.be')) return null;

  if (host.contains('youtu.be') && uri.pathSegments.isNotEmpty) {
    return uri.pathSegments.first;
  }
  final segs = uri.pathSegments;
  if (segs.length >= 2 &&
      (segs[0] == 'shorts' || segs[0] == 'embed' || segs[0] == 'live')) {
    return segs[1];
  }
  final v = uri.queryParameters['v'];
  if (v != null && v.isNotEmpty) return v;
  return null;
}

class _BannerVideo extends StatelessWidget {
  final String videoUrl;
  final Widget poster;
  final bool active;
  final bool loop;
  final VoidCallback onFinished;
  final VoidCallback onFailed;

  const _BannerVideo({
    super.key,
    required this.videoUrl,
    required this.poster,
    required this.active,
    required this.loop,
    required this.onFinished,
    required this.onFailed,
  });

  @override
  Widget build(BuildContext context) {
    final ytId = _youtubeIdFrom(videoUrl);
    if (ytId != null) {
      return _YoutubeVideo(
        videoId: ytId,
        isShort: videoUrl.contains('/shorts/'),
        poster: poster,
        active: active,
        onFinished: onFinished,
        onFailed: onFailed,
      );
    }
    return _DirectVideo(
      url: videoUrl,
      poster: poster,
      active: active,
      loop: loop,
      onFinished: onFinished,
      onFailed: onFailed,
    );
  }
}

class _YoutubeVideo extends StatefulWidget {
  final String videoId;
  final bool isShort;
  final Widget poster;
  final bool active;
  final VoidCallback onFinished;
  final VoidCallback onFailed;

  const _YoutubeVideo({
    required this.videoId,
    required this.isShort,
    required this.poster,
    required this.active,
    required this.onFinished,
    required this.onFailed,
  });

  @override
  State<_YoutubeVideo> createState() => _YoutubeVideoState();
}

class _YoutubeVideoState extends State<_YoutubeVideo> {
  YoutubePlayerController? _c;
  StreamSubscription? _sub;
  StreamSubscription? _posSub;
  Timer? _startTimeout;
  Timer? _soundFallback;
  bool _started = false;
  bool _playing = false;
  bool _paused = false;
  bool _failed = false;
  bool _finished = false;
  double _progress = 0;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    if (widget.active) _start();
  }

  void _start() {
    if (_c != null || _failed) return;
    _finished = false;
    _started = false;
    _playing = false;
    _paused = false;
    _progress = 0;
    _duration = Duration.zero;
    _bannerPaused.value = false;

    final c = YoutubePlayerController.fromVideoId(
      videoId: widget.videoId,
      autoPlay: true,
      params: YoutubePlayerParams(
        mute: _bannerMuted.value,
        showControls: false,
        showFullscreenButton: false,
        playsInline: true,
        origin: kYoutubeOrigin,
      ),
    );
    _c = c;
    _sub = c.listen(_onValue);
    _posSub = c.videoStateStream.listen((s) {
      if (!mounted || !widget.active) return;
      final total = c.value.metaData.duration;
      if (total.inMilliseconds > 0) {
        final p = s.position.inMilliseconds / total.inMilliseconds;
        if ((p - _progress).abs() > 0.002 || total != _duration) {
          setState(() {
            _progress = p;
            _duration = total;
          });
        }
      }
    });
    _bannerMuted.addListener(_onMuteChanged);

    _soundFallback = Timer(const Duration(seconds: 6), () {
      if (mounted && !_started && widget.active && !_bannerMuted.value) {
        _bannerMuted.value = true;
        _c?.playVideo();
      }
    });

    _startTimeout?.cancel();
    _startTimeout = Timer(const Duration(seconds: 20), () {
      if (mounted && !_started && widget.active) _fail();
    });
  }

  void _stop() {
    _startTimeout?.cancel();
    _soundFallback?.cancel();
    _bannerMuted.removeListener(_onMuteChanged);
    _sub?.cancel();
    _posSub?.cancel();
    _sub = null;
    _posSub = null;
    _c?.close();
    _c = null;
    _playing = false;
    _paused = false;
    _started = false;
  }

  void _onMuteChanged() {
    final c = _c;
    if (c == null) return;
    if (_bannerMuted.value) {
      c.mute();
    } else {
      c.unMute();
    }
  }

  void _togglePlayPause() {
    final c = _c;
    if (c == null || !_started) return;
    if (_paused) {
      c.playVideo();
      _bannerPaused.value = false;
      setState(() => _paused = false);
    } else {
      c.pauseVideo();
      _bannerPaused.value = true;
      setState(() => _paused = true);
    }
  }

  void _seekTo(double fraction) {
    final c = _c;
    if (c == null || _duration == Duration.zero) return;
    final seconds = _duration.inMilliseconds * fraction / 1000.0;
    c.seekTo(seconds: seconds, allowSeekAhead: true);
    if (fraction < 0.98) _finished = false;
    setState(() => _progress = fraction);
  }

  void _onValue(YoutubePlayerValue value) {
    if (!mounted || _failed || !widget.active) return;

    final hardError = value.error != YoutubeError.none &&
        value.error != YoutubeError.unknown;
    if (hardError) {
      _fail();
      return;
    }

    final state = value.playerState;
    if (state == PlayerState.playing) {
      _startTimeout?.cancel();
      _soundFallback?.cancel();
      if (!_started || !_playing || _paused) {
        setState(() {
          _started = true;
          _playing = true;
          _paused = false;
        });
      }
    } else if (state == PlayerState.paused && _started) {
      if (!_paused) setState(() => _paused = true);
    }

    if (state == PlayerState.ended && !_finished) {
      _finished = true;
      widget.onFinished();
    }
  }

  void _fail() {
    if (_failed) return;
    _stop();
    if (mounted) setState(() => _failed = true);
    if (widget.active) widget.onFailed();
  }

  @override
  void didUpdateWidget(covariant _YoutubeVideo oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.active && !oldWidget.active) {
      _start();
    } else if (!widget.active && oldWidget.active) {
      _stop();
    }
  }

  @override
  void dispose() {
    _stop();
    super.dispose();
  }

  Widget _coverPlayer(YoutubePlayerController c) {
    return LayoutBuilder(
      builder: (context, box) {
        final cw = box.maxWidth;
        final ch = box.maxHeight;

        double pw;
        double ph;
        if (widget.isShort) {
          ph = cw * 16 / 9;
          pw = ph * 16 / 9;
        } else {
          pw = math.max(cw, ch * 16 / 9) * kYtZoom;
          ph = pw * 9 / 16;
        }

        return ClipRect(
          child: OverflowBox(
            alignment: Alignment.center,
            minWidth: pw,
            maxWidth: pw,
            minHeight: ph,
            maxHeight: ph,
            child: SizedBox(
              width: pw,
              height: ph,
              child: YoutubePlayer(
                controller: c,
                aspectRatio: 16 / 9,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_failed) return widget.poster;

    final c = _c;
    if (c == null) return widget.poster;

    final showVideo = widget.active && _started;

    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          color: Colors.black,
          child: IgnorePointer(child: _coverPlayer(c)),
        ),
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _togglePlayPause,
          ),
        ),
        _PosterOverlay(
          poster: widget.poster,
          videoVisible: showVideo,
          showLoader: widget.active && !showVideo,
        ),
        if (showVideo) _PauseIcon(visible: _paused),
        if (showVideo) const _MuteButton(),
        if (showVideo)
          _SeekBar(
            progress: _progress,
            duration: _duration,
            onSeek: _seekTo,
          ),
      ],
    );
  }
}

class _DirectVideo extends StatefulWidget {
  final String url;
  final Widget poster;
  final bool active;
  final bool loop;
  final VoidCallback onFinished;
  final VoidCallback onFailed;

  const _DirectVideo({
    required this.url,
    required this.poster,
    required this.active,
    required this.loop,
    required this.onFinished,
    required this.onFailed,
  });

  @override
  State<_DirectVideo> createState() => _DirectVideoState();
}

class _DirectVideoState extends State<_DirectVideo> {
  VideoPlayerController? _controller;
  bool _failed = false;
  bool _finishedFired = false;
  bool _userPaused = false;

  @override
  void initState() {
    super.initState();
    _bannerMuted.addListener(_applyVolume);
    _init();
  }

  void _applyVolume() {
    _controller?.setVolume(_bannerMuted.value ? 0 : 1);
  }

  void _togglePlayPause() {
    final c = _controller;
    if (c == null || !c.value.isInitialized) return;
    if (c.value.isPlaying) {
      c.pause();
      _userPaused = true;
      _bannerPaused.value = true;
    } else {
      c.play();
      _userPaused = false;
      _bannerPaused.value = false;
    }
    setState(() {});
  }

  void _seekTo(double fraction) {
    final c = _controller;
    if (c == null || !c.value.isInitialized) return;
    final target = c.value.duration * fraction;
    c.seekTo(target);
    if (fraction < 0.98) _finishedFired = false;
  }

  @override
  void didUpdateWidget(covariant _DirectVideo oldWidget) {
    super.didUpdateWidget(oldWidget);

    final c = _controller;
    if (c == null || !c.value.isInitialized) return;

    if (widget.active && !oldWidget.active) {
      _finishedFired = false;
      _userPaused = false;
      c.seekTo(Duration.zero);
      c.play();
    }
    if (!widget.active && oldWidget.active) {
      c.pause();
      c.seekTo(Duration.zero);
      _userPaused = false;
    }
  }

  Future<void> _init() async {
    try {
      final c = VideoPlayerController.networkUrl(
        Uri.parse(widget.url),
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );
      _controller = c;
      await c.initialize();
      await c.setLooping(widget.loop);
      await c.setVolume(_bannerMuted.value ? 0 : 1);

      if (!mounted) return;

      c.addListener(_onTick);
      if (widget.active) await c.play();
      if (mounted) setState(() {});
    } catch (e) {
      if (mounted) {
        setState(() => _failed = true);
        if (widget.active) widget.onFailed();
      }
    }
  }

  void _onTick() {
    final c = _controller;
    if (c == null || !mounted) return;
    final v = c.value;

    if (widget.active && !_finishedFired && !widget.loop) {
      if (v.isInitialized &&
          v.duration > Duration.zero &&
          v.position >= v.duration - const Duration(milliseconds: 300)) {
        _finishedFired = true;
        widget.onFinished();
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    _bannerMuted.removeListener(_applyVolume);
    _controller?.removeListener(_onTick);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_failed) return widget.poster;

    final c = _controller;
    final ready = c != null && c.value.isInitialized;
    final showVideo =
        ready && widget.active && c.value.position > Duration.zero;

    double progress = 0;
    Duration duration = Duration.zero;
    if (ready && c.value.duration.inMilliseconds > 0) {
      duration = c.value.duration;
      progress =
          c.value.position.inMilliseconds / c.value.duration.inMilliseconds;
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        if (ready)
          ClipRect(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: c.value.size.width,
                height: c.value.size.height,
                child: VideoPlayer(c),
              ),
            ),
          ),
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _togglePlayPause,
          ),
        ),
        _PosterOverlay(
          poster: widget.poster,
          videoVisible: showVideo,
          showLoader: widget.active && !showVideo,
        ),
        if (showVideo) _PauseIcon(visible: _userPaused),
        if (showVideo) const _MuteButton(),
        if (showVideo)
          _SeekBar(
            progress: progress,
            duration: duration,
            onSeek: _seekTo,
          ),
      ],
    );
  }
}

class _BannerShimmer extends StatelessWidget {
  const _BannerShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[900]!,
      highlightColor: Colors.grey[700]!,
      child: Container(
        height: 240,
        width: double.infinity,
        color: Colors.grey[900],
      ),
    );
  }
}

class _ImageShimmer extends StatelessWidget {
  const _ImageShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[900]!,
      highlightColor: Colors.grey[700]!,
      child: Container(color: Colors.grey[900]),
    );
  }
}