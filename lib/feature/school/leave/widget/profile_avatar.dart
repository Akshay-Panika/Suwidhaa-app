// lib/feature/school/student_leave/widget/profile_avatar.dart

import 'package:flutter/material.dart';

class LeaveProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final double size;
  final Color fallbackColor;
  final bool showBorder;

  const LeaveProfileAvatar({
    super.key,
    this.imageUrl,
    required this.name,
    this.size = 48,
    this.fallbackColor = Colors.indigo,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.trim().isNotEmpty;
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: showBorder
            ? Border.all(color: fallbackColor.withOpacity(0.25), width: 1.5)
            : null,
      ),
      child: ClipOval(
        child: hasImage
            ? Image.network(
          imageUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return Container(
              color: fallbackColor.withOpacity(0.08),
              child: Center(
                child: SizedBox(
                  width: size * 0.35,
                  height: size * 0.35,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: fallbackColor,
                  ),
                ),
              ),
            );
          },
          errorBuilder: (_, __, ___) => _initials(initial),
        )
            : _initials(initial),
      ),
    );
  }

  Widget _initials(String initial) {
    return Container(
      color: fallbackColor.withOpacity(0.1),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: TextStyle(
          fontSize: size * 0.4,
          fontWeight: FontWeight.bold,
          color: fallbackColor,
        ),
      ),
    );
  }
}