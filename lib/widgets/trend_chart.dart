import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/sensor_data.dart';
import '../theme/app_colors.dart';

/// Temperature & Humidity trend chart using fl_chart.
/// Equivalent to the web chart-manager.js with Chart.js.
class TrendChart extends StatelessWidget {
  final List<SensorData> history;

  const TrendChart({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
    final gridColor =
        isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chart title
          Row(
            children: [
              const Text('📈', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Temperature & Humidity Trend',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Last ${history.length} readings',
            style: TextStyle(
              fontSize: 12,
              color: textColor,
            ),
          ),
          const SizedBox(height: 20),

          // Chart
          SizedBox(
            height: 220,
            child: history.isEmpty
                ? Center(
                    child: Text(
                      'Waiting for data...',
                      style: TextStyle(color: textColor, fontSize: 14),
                    ),
                  )
                : LineChart(
                    _buildChartData(isDark, textColor, gridColor),
                    duration: const Duration(milliseconds: 150),
                  ),
          ),

          // Legend
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(
                'Temperature (°C)',
                const Color(0xFFF56565),
                textColor,
              ),
              const SizedBox(width: 24),
              _buildLegendItem(
                'Humidity (%)',
                const Color(0xFF4299E1),
                textColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, Color textColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  LineChartData _buildChartData(
    bool isDark,
    Color textColor,
    Color gridColor,
  ) {
    // Downsample if too many points for smooth rendering.
    final data = _downsample(history, 60);

    final tempSpots = <FlSpot>[];
    final humidSpots = <FlSpot>[];

    for (int i = 0; i < data.length; i++) {
      tempSpots.add(FlSpot(i.toDouble(), data[i].temperature));
      humidSpots.add(FlSpot(i.toDouble(), data[i].humidity));
    }

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 10,
        getDrawingHorizontalLine: (value) => FlLine(
          color: gridColor.withValues(alpha: 0.5),
          strokeWidth: 0.8,
        ),
      ),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: (value, meta) => Text(
              value.toInt().toString(),
              style: TextStyle(fontSize: 11, color: textColor),
            ),
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 28,
            interval: (data.length / 5).ceilToDouble().clamp(1, double.infinity),
            getTitlesWidget: (value, meta) {
              final idx = value.toInt();
              if (idx < 0 || idx >= data.length) return const SizedBox.shrink();
              final time = DateTime.fromMillisecondsSinceEpoch(
                data[idx].timestamp,
              );
              return Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(fontSize: 10, color: textColor),
                ),
              );
            },
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(show: false),
      lineTouchData: LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (spot) =>
              isDark ? const Color(0xFF2D3748) : Colors.white,
          tooltipRoundedRadius: 8,
          getTooltipItems: (spots) {
            return spots.map((spot) {
              final isTemp = spot.barIndex == 0;
              return LineTooltipItem(
                '${isTemp ? '🌡️' : '💧'} ${spot.y.toStringAsFixed(1)}${isTemp ? '°C' : '%'}',
                TextStyle(
                  color: spot.bar.color ?? Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              );
            }).toList();
          },
        ),
      ),
      lineBarsData: [
        // Temperature line
        LineChartBarData(
          spots: tempSpots,
          isCurved: true,
          curveSmoothness: 0.35,
          color: const Color(0xFFF56565),
          barWidth: 2.5,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            color: const Color(0xFFF56565).withValues(alpha: 0.08),
          ),
        ),
        // Humidity line
        LineChartBarData(
          spots: humidSpots,
          isCurved: true,
          curveSmoothness: 0.35,
          color: const Color(0xFF4299E1),
          barWidth: 2.5,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            color: const Color(0xFF4299E1).withValues(alpha: 0.08),
          ),
        ),
      ],
    );
  }

  /// Downsample data points for smoother chart rendering.
  List<SensorData> _downsample(List<SensorData> data, int maxPoints) {
    if (data.length <= maxPoints) return data;

    final step = data.length / maxPoints;
    final result = <SensorData>[];
    for (double i = 0; i < data.length; i += step) {
      result.add(data[i.floor()]);
    }
    return result;
  }
}
