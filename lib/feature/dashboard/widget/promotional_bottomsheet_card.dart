import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/utils/app_color.dart';

class PromotionalBottomSheet extends StatefulWidget {
  const PromotionalBottomSheet({super.key});

  @override
  State<PromotionalBottomSheet> createState() => _PromotionalBottomSheetState();
}

class _PromotionalBottomSheetState extends State<PromotionalBottomSheet> {
  int _timerSeconds = 30;
  bool _isSheetShown = false;
  Timer? _countdownTimer;      // ✅ Timer instance
  Timer? _openSheetTimer;      // ✅ Open delay timer

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    // Show bottom sheet after 30 seconds
    _openSheetTimer = Timer(const Duration(seconds: 30), () {
      if (mounted) {
        setState(() {
          _isSheetShown = true;
        });
        _showBottomSheet();
      }
    });
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_timerSeconds > 0) {
          _timerSeconds--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  void _showBottomSheet() {
    if (!mounted) return;

    _startCountdown();   // ✅ Countdown start karo jab sheet khule

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (context) => _buildPromotionalContent(context),
    ).whenComplete(() {
      // ✅ Sheet band hone pe countdown rok do
      _countdownTimer?.cancel();
    });
  }

  Widget _buildPromotionalContent(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.8),
          ],
        ),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      child: Stack(
        children: [
          _buildBackgroundPattern(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: _buildCloseButton(context),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.stars,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  '🎉 Special Offer!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Get 50% off on your first subscription\nUse code: WELCOME50',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 8),
                _buildTimer(),   // ✅ No context needed
                const SizedBox(height: 20),
                _buildClaimButton(context),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundPattern() {
    return Stack(
      children: [
        Positioned(
          top: -50,
          right: -50,
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          bottom: -80,
          left: -80,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.04),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          top: 100,
          right: 20,
          child: Icon(
            Icons.star,
            color: Colors.white.withOpacity(0.08),
            size: 80,
          ),
        ),
        Positioned(
          bottom: 120,
          left: 30,
          child: Icon(
            Icons.star_half,
            color: Colors.white.withOpacity(0.06),
            size: 60,
          ),
        ),
      ],
    );
  }

  // ✅ FIXED: Simple stateless timer widget — no StatefulBuilder, no Future.delayed
  Widget _buildTimer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.timer, color: Colors.white, size: 20),
          const SizedBox(width: 10),
          Text(
            'Offer ends in: ${_timerSeconds ~/ 60}:${(_timerSeconds % 60).toString().padLeft(2, '0')}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return IconButton(
      onPressed: () => _closeBottomSheet(context),
      icon: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.close, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildClaimButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ElevatedButton(
        onPressed: () {
          _closeBottomSheet(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('🎉 Offer claimed successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        child: const Text(
          'Claim Offer Now',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _closeBottomSheet(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();   // ✅ Cancel countdown
    _openSheetTimer?.cancel();   // ✅ Cancel open timer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}