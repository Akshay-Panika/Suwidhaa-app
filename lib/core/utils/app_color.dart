// lib/core/utils/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // --- Main Brand Colors ---
  static const Color primary = Color(0xFF2563EB);    // Royal Blue
  static const Color accent = Color(0xFF06B6D4);     // Cyan/Teal
  static const Color background = Color(0xFFF8FAFC); // Clean Light Gray

  // --- Module-Specific Colors (Primary shades) ---
  static const Color school = Color(0xFFF59E0B);     // Amber
  static const Color itServices = Color(0xFF8B5CF6); // Violet
  static const Color ecommerce = Color(0xFFEF4444);  // Red
  static const Color ngo = Color(0xFF10B981);        // Emerald
  static const Color ott = Color(0xFFDB2777);        // Magenta

  // --- Module-Specific Background Tints (Light shades) ---
  static const Color schoolTint = Color(0xFFFEF3C7);
  static const Color itServicesTint = Color(0xFFEDE9FE);
  static const Color ecommerceTint = Color(0xFFFEE2E2);
  static const Color ngoTint = Color(0xFFD1FAE5);
  static const Color ottTint = Color(0xFFFCE7F3);

  // --- Common UI Colors ---
  static const Color textMain = Color(0xFF1E293B);   // Dark Slate
  static const Color textSecondary = Color(0xFF64748B);
  static const Color white = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE2E8F0);
  static const Color shadow = Color(0x1A000000);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  // --- Gradients ---
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient itGradient = LinearGradient(
    colors: [itServices, Color(0xFF7C3AED)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class CollegeColors {
  static const Color primary = Color(0xFF715DE9);        // Purple
  static const Color primaryLight = Color(0xFFEDE9FE);   // Purple light bg
  static const Color secondary = Color(0xFFFF7C9E);      // Pink
  static const Color secondaryLight = Color(0xFFFFE4EC); // Pink light bg
  static const Color textSecondary = Color(0xFF8E8E93);
  static const Color background = Color(0xFFF7F7FA);
  static const Color border = Color(0xFFE5E5EA);
}