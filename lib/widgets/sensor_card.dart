import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// A premium sensor data card with gradient accent, glassmorphism effect,
/// and smooth animations. Equivalent to the web .card component.
class SensorCard extends StatelessWidget {
  final String icon;
  final String value;
  final String unit;
  final String label;
  final String type; // 'temperature', 'humidity', 'distance', 'bottle'
  final Color? valueColor;

  const SensorCard({
    super.key,
    required this.icon,
    required this.value,
    required this.unit,
    required this.label,
    required this.type,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradient = AppColors.cardGradient(type);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
          if (!isDark)
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.8),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Gradient accent bar at top
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 4,
                decoration: BoxDecoration(gradient: gradient),
              ),
            ),

            // Subtle gradient overlay for depth
            if (isDark)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withValues(alpha: 0.03),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

            // Content
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon
                  Text(
                    icon,
                    style: const TextStyle(fontSize: 28),
                  ),
                  const SizedBox(height: 10),

                  // Value + Unit
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: valueColor ??
                              (isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.lightTextPrimary),
                        ),
                        child: Text(value),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        unit,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? AppColors.darkTextMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Label
                  Text(
                    label.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.darkTextMuted
                          : AppColors.lightTextMuted,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
