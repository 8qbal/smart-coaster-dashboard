import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sensor_provider.dart';
import '../providers/theme_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/connection_status.dart';
import '../widgets/sensor_card.dart';
import '../widgets/trend_chart.dart';
import '../widgets/last_updated.dart';

/// Main dashboard screen — the sole screen of the app.
/// Equivalent to the web index.html + app.js combined.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Entrance animation
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();

    // Initialize sensor data listener
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SensorProvider>().initialize();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ─── App Bar ────────────────────────────────────
              _buildAppBar(isDark),

              // ─── Body ───────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Sensor Cards Grid
                    _buildSensorCards(),
                    const SizedBox(height: 20),

                    // Trend Chart
                    _buildTrendChart(),
                    const SizedBox(height: 8),

                    // Last Updated
                    _buildLastUpdated(),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── App Bar ─────────────────────────────────────────────────
  Widget _buildAppBar(bool isDark) {
    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      surfaceTintColor: Colors.transparent,
      toolbarHeight: 64,
      title: Row(
        children: [
          // Logo
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: AppColors.gradientCyan,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text('💧', style: TextStyle(fontSize: 22)),
            ),
          ),
          const SizedBox(width: 12),
          // Title
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Smart Coaster',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              Text(
                'Dashboard',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: isDark
                      ? AppColors.darkTextMuted
                      : AppColors.lightTextMuted,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        // Connection Status
        Consumer<SensorProvider>(
          builder: (context, sensor, _) {
            return ConnectionStatus(isOnline: sensor.isOnline);
          },
        ),
        const SizedBox(width: 8),

        // Theme Toggle
        Consumer<ThemeProvider>(
          builder: (context, theme, _) {
            return GestureDetector(
              onTap: () => theme.toggleTheme(),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBg : AppColors.lightBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return RotationTransition(
                        turns: Tween(begin: 0.0, end: 0.5).animate(animation),
                        child: FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                      );
                    },
                    child: Text(
                      theme.isDarkMode ? '☀️' : '🌙',
                      key: ValueKey<bool>(theme.isDarkMode),
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  // ─── Sensor Cards Grid ───────────────────────────────────────
  Widget _buildSensorCards() {
    return Consumer<SensorProvider>(
      builder: (context, sensor, _) {
        final data = sensor.currentData;
        final hasData = sensor.hasData;

        return GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 1.15,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            // Temperature
            SensorCard(
              icon: '🌡️',
              value: hasData ? data!.temperature.toStringAsFixed(1) : '--',
              unit: '°C',
              label: 'Temperature',
              type: 'temperature',
              valueColor: hasData
                  ? AppColors.temperatureColor(data!.temperature)
                  : null,
            ),

            // Humidity
            SensorCard(
              icon: '💧',
              value: hasData ? data!.humidity.toStringAsFixed(1) : '--',
              unit: '%',
              label: 'Humidity',
              type: 'humidity',
              valueColor:
                  hasData ? AppColors.humidityColor(data!.humidity) : null,
            ),

            // Distance
            SensorCard(
              icon: '📏',
              value: hasData ? data!.distance.toStringAsFixed(1) : '--',
              unit: 'cm',
              label: 'Distance',
              type: 'distance',
            ),

            // Bottle Status
            SensorCard(
              icon: hasData
                  ? (data!.bottlePresent ? '🍶' : '❌')
                  : '🍶',
              value: hasData
                  ? (data!.bottlePresent ? 'Present' : 'Absent')
                  : '--',
              unit: '',
              label: 'Bottle Status',
              type: 'bottle',
              valueColor: hasData
                  ? (data!.bottlePresent
                      ? AppColors.accentGreen
                      : AppColors.accentOrange)
                  : null,
            ),
          ],
        );
      },
    );
  }

  // ─── Trend Chart ─────────────────────────────────────────────
  Widget _buildTrendChart() {
    return Consumer<SensorProvider>(
      builder: (context, sensor, _) {
        return TrendChart(history: sensor.history);
      },
    );
  }

  // ─── Last Updated ────────────────────────────────────────────
  Widget _buildLastUpdated() {
    return Consumer<SensorProvider>(
      builder: (context, sensor, _) {
        return LastUpdated(text: sensor.lastUpdatedText);
      },
    );
  }
}
