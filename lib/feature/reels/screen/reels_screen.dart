import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ReelsScreen extends StatefulWidget {
  const ReelsScreen({super.key});

  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  final List<String> shortIds = ["0_If4o_akdg"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: shortIds.length,
        itemBuilder: (context, index) {
          return VideoPlayerItem(videoId: shortIds[index]);
        },
      ),
    );
  }
}

// Naya Widget jo controller ko handle karega
class VideoPlayerItem extends StatefulWidget {
  final String videoId;
  const VideoPlayerItem({super.key, required this.videoId});

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://www.youtube.com/embed/${widget.videoId}?autoplay=1&mute=0'));
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: _controller);
  }
}