import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Animated online/offline connection status indicator.
/// Equivalent to the web .status-indicator component.
class ConnectionStatus extends StatefulWidget {
  final bool isOnline;

  const ConnectionStatus({super.key, required this.isOnline});

  @override
  State<ConnectionStatus> createState() => _ConnectionStatusState();
}

class _ConnectionStatusState extends State<ConnectionStatus>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _pulseAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (widget.isOnline) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(ConnectionStatus oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isOnline && !_pulseController.isAnimating) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.isOnline && _pulseController.isAnimating) {
      _pulseController.stop();
      _pulseController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statusColor =
        widget.isOnline ? AppColors.accentGreen : AppColors.accentRed;
    final statusText = widget.isOnline ? 'Online' : 'Offline';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkBg.withValues(alpha: 0.6)
            : AppColors.lightBg.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Animated status dot
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: statusColor.withValues(
                    alpha: widget.isOnline ? _pulseAnimation.value : 1.0,
                  ),
                  boxShadow: [
                    if (widget.isOnline)
                      BoxShadow(
                        color: statusColor.withValues(alpha: 0.4),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(width: 8),
          Text(
            statusText,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
