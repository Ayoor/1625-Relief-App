import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AnimatedBarGraph extends StatefulWidget {
  final List<double> yValues;
  final List<String> labels;
  final double? maxY;

  const AnimatedBarGraph({
    super.key,
    required this.yValues,
    required this.labels,
    this.maxY,
  });

  @override
  _AnimatedBarGraphState createState() => _AnimatedBarGraphState();
}

class _AnimatedBarGraphState extends State<AnimatedBarGraph> {

  double wholeNumberDouble(double value) {
    return double.parse(value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 1));
  }

  @override
  Widget build(BuildContext context) {
    double? maxYValue = 0;
    double maxAdjust = 0;
    double interval = 0;

    // Determine the maxY value and adjust it based on the input
    if (widget.maxY == null) {
      maxYValue = widget.yValues.reduce((a, b) => a > b ? a : b);
      maxAdjust = 400;
      interval = 500;
    } else {
      maxYValue = widget.maxY;
      interval = 5;
    }

    // Define custom colors for each bar
    List<Color> barColors = [
      Colors.lightBlue,
      Colors.deepOrangeAccent.shade100,
      Colors.purpleAccent.shade100
    ];

    return BarChart(
      BarChartData(backgroundColor: Colors.transparent,
        alignment: BarChartAlignment.center,
        maxY: maxYValue! + maxAdjust,
        minY: 0,
        barTouchData: BarTouchData(enabled: true),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                int index = value.toInt();
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    widget.labels[index],
                    style: const TextStyle(fontSize: 12),
                  ),
                );
              },
              interval: 1, // Adjusted to show each label
              reservedSize: 28,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(maxIncluded: true, minIncluded: false,
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value >= 1000) {
                  // Format Y-axis values as k for thousands
                  return Text(
                    '${(value / 1000).toStringAsFixed(1)}k',
                    style: const TextStyle(fontSize: 12),
                  );
                }
                else {
                  return Text(
                    (value.toStringAsFixed(0)),
                    style: const TextStyle(fontSize: 12),
                  );
                }
              },
              interval: interval,
              reservedSize: 40,
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(
          show: false,
          border: Border.all(color: Colors.grey, width: 1),
        ),
        barGroups: widget.yValues.asMap().entries.map((entry) {
          int index = entry.key;
          double value = entry.value;

          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: value,
                width: 16,
                color: barColors[index % barColors.length],
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          );
        }).toList(),
        gridData: const FlGridData(show: true, drawVerticalLine: false),
      ),
      swapAnimationDuration: const Duration(milliseconds: 2000),
      swapAnimationCurve: Curves.easeInOut,
    );
  }
}
