import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Displays the "Last updated: ..." timestamp.
class LastUpdated extends StatelessWidget {
  final String text;

  const LastUpdated({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.access_time_rounded,
            size: 14,
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          ),
          const SizedBox(width: 6),
          Text(
            'Last updated: ',
            style: TextStyle(
              fontSize: 13,
              color:
                  isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              text,
              key: ValueKey<String>(text),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
