import 'package:flutter/material.dart';

/// Curated color palette for the Smart Coaster Dashboard.
/// Ported from the web CSS variables with enhanced mobile palette.
class AppColors {
  AppColors._();

  // ─── Brand Colors ─────────────────────────────────────────
  static const Color primaryBlue = Color(0xFF3182CE);
  static const Color accentGreen = Color(0xFF38A169);
  static const Color accentRed = Color(0xFFE53E3E);
  static const Color accentOrange = Color(0xFFDD6B20);
  static const Color accentPurple = Color(0xFF805AD5);
  static const Color accentCyan = Color(0xFF4FACFE);
  static const Color accentTeal = Color(0xFF11998E);

  // ─── Light Theme ──────────────────────────────────────────
  static const Color lightBg = Color(0xFFF0F4F8);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF1A202C);
  static const Color lightTextSecondary = Color(0xFF4A5568);
  static const Color lightTextMuted = Color(0xFF718096);
  static const Color lightBorder = Color(0xFFE2E8F0);

  // ─── Dark Theme ───────────────────────────────────────────
  static const Color darkBg = Color(0xFF0F1419);
  static const Color darkSurface = Color(0xFF1A2332);
  static const Color darkCard = Color(0xFF1E293B);
  static const Color darkTextPrimary = Color(0xFFF7FAFC);
  static const Color darkTextSecondary = Color(0xFFE2E8F0);
  static const Color darkTextMuted = Color(0xFFA0AEC0);
  static const Color darkBorder = Color(0xFF2D3748);

  // ─── Gradients ────────────────────────────────────────────
  static const LinearGradient gradientBlue = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
  );

  static const LinearGradient gradientGreen = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
  );

  static const LinearGradient gradientOrange = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF093FB), Color(0xFFF5576C)],
  );

  static const LinearGradient gradientCyan = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
  );

  static const LinearGradient gradientDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1A2332), Color(0xFF2D3748)],
  );

  // ─── Temperature Color Coding ─────────────────────────────
  static Color temperatureColor(double temp) {
    if (temp >= 35) return accentRed;
    if (temp >= 30) return accentOrange;
    if (temp >= 20) return accentGreen;
    return primaryBlue;
  }

  // ─── Humidity Color Coding ────────────────────────────────
  static Color humidityColor(double humidity) {
    if (humidity >= 70) return primaryBlue;
    if (humidity >= 40) return accentGreen;
    return accentOrange;
  }

  // ─── Card Gradient by Type ────────────────────────────────
  static LinearGradient cardGradient(String type) {
    switch (type) {
      case 'temperature':
        return gradientOrange;
      case 'humidity':
        return gradientCyan;
      case 'distance':
        return gradientBlue;
      case 'bottle':
        return gradientGreen;
      default:
        return gradientBlue;
    }
  }
}
