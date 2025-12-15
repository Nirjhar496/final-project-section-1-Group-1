import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:inventory/models/product.dart';

class CategoryPieChart extends StatefulWidget {
  final List<Product> products;

  const CategoryPieChart({super.key, required this.products});

  @override
  State<CategoryPieChart> createState() => _CategoryPieChartState();
}

class _CategoryPieChartState extends State<CategoryPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.products.isEmpty) {
      return const Center(
        child: Text(
          'No product data available.\nAdd products to see the chart.',
          textAlign: TextAlign.center,
        ),
      );
    }

    final categoryCounts = <String, int>{};
    for (var product in widget.products) {
      categoryCounts.update(product.category, (value) => value + 1,
          ifAbsent: () => 1);
    }

    final List<PieChartSectionData> sections = [];
    final colors = Colors.accents;
    int colorIndex = 0;

    categoryCounts.forEach((category, count) {
      final isTouched = sections.length == touchedIndex;
      final fontSize = isTouched ? 18.0 : 14.0;
      final radius = isTouched ? 100.0 : 80.0;

      sections.add(
        PieChartSectionData(
          color: colors[colorIndex % colors.length],
          value: count.toDouble(),
          title: '$count',
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xffffffff),
          ),
          badgeWidget: _Badge(
            category,
            size: 40,
            borderColor: Colors.black,
          ),
          badgePositionPercentageOffset: .98,
        ),
      );
      colorIndex++;
    });

    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(
          touchCallback: (FlTouchEvent event, pieTouchResponse) {
            setState(() {
              if (!event.isInterestedForInteractions ||
                  pieTouchResponse == null ||
                  pieTouchResponse.touchedSection == null) {
                touchedIndex = -1;
                return;
              }
              touchedIndex =
                  pieTouchResponse.touchedSection!.touchedSectionIndex;
            });
          },
        ),
        borderData: FlBorderData(show: false),
        sectionsSpace: 2,
        centerSpaceRadius: 60,
        sections: sections,
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final double size;
  final Color borderColor;

  const _Badge(
    this.text,
    {
    required this.size,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 2),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withAlpha(128),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 10),
        ),
      ),
    );
  }
}
