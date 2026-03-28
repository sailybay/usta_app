import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Palette
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryDark = Color(0xFF4A42D6);
  static const Color primaryLight = Color(0xFF9D97FF);
  static const Color primarySurface = Color(0xFFEEEDFF);

  // Secondary (Accent)
  static const Color secondary = Color(0xFF00C896);
  static const Color secondaryDark = Color(0xFF009E76);
  static const Color secondaryLight = Color(0xFF52DDB6);
  static const Color secondarySurface = Color(0xFFE0FFF6);

  // Semantic
  static const Color error = Color(0xFFFF4C60);
  static const Color errorSurface = Color(0xFFFFEDEF);
  static const Color warning = Color(0xFFFFB830);
  static const Color warningSurface = Color(0xFFFFF4DC);
  static const Color success = Color(0xFF00C896);
  static const Color successSurface = Color(0xFFE0FFF6);
  static const Color info = Color(0xFF3DB8F8);
  static const Color infoSurface = Color(0xFFE5F6FF);

  // Neutrals (Light)
  static const Color background = Color(0xFFF5F6FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF0F1F5);
  static const Color border = Color(0xFFE2E4ED);
  static const Color divider = Color(0xFFEEEFF4);

  // Text (Light)
  static const Color textPrimary = Color(0xFF1A1D2E);
  static const Color textSecondary = Color(0xFF6B6F85);
  static const Color textHint = Color(0xFFB0B3C4);
  static const Color textInverse = Color(0xFFFFFFFF);

  // Dark Mode
  static const Color backgroundDark = Color(0xFF0F1020);
  static const Color surfaceDark = Color(0xFF1A1D2E);
  static const Color surfaceVariantDark = Color(0xFF252840);
  static const Color borderDark = Color(0xFF363A52);

  // Star / Rating
  static const Color star = Color(0xFFFFB830);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF9D97FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF3CCBD9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF00C896), Color(0xFF3DB8F8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Category Colors
  static const Color categoryCleaning = Color(0xFF3DB8F8);
  static const Color categoryRepair = Color(0xFFFF6B6B);
  static const Color categoryDelivery = Color(0xFFFFB830);
  static const Color categoryTutor = Color(0xFF6C63FF);
  static const Color categoryBeauty = Color(0xFFFF6BB5);
  static const Color categoryPlumbing = Color(0xFF00C896);
}
