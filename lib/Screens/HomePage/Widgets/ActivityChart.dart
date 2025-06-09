import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../Colors/Colors.dart';

class ActivityChart extends StatelessWidget {
  const ActivityChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: containerColor,
              blurRadius: 8,
              spreadRadius: 1,
            )
          ],
          color: secondaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Activity",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  DropdownButton<String>(
                    value: "This Week",
                    items: const [
                      DropdownMenuItem(
                        value: "This Week",
                        child: Text(
                          "This Week",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      DropdownMenuItem(
                        value: "Last Week",
                        child: Text(
                          "Last Week",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                    onChanged: (value) {},
                    underline: Container(),
                  ),
                ],
              ),
            ),
            // const SizedBox(height: 16),
            Expanded(
              child: LineChart(
                LineChartData(
                  backgroundColor: backgroundColor,
                  minX: 0,
                  maxX: 6,
                  minY: 0,
                  maxY: 5,
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 0:
                              return Text(
                                'S',
                                style: TextStyle(fontSize: 12),
                              );
                            case 1:
                              return Text(
                                'M',
                                style: TextStyle(fontSize: 12),
                              );
                            case 2:
                              return Text(
                                'T',
                                style: TextStyle(fontSize: 12),
                              );
                            case 3:
                              return Text(
                                'W',
                                style: TextStyle(fontSize: 12),
                              );
                            case 4:
                              return Text(
                                'T',
                                style: TextStyle(fontSize: 12),
                              );
                            case 5:
                              return Text(
                                'F',
                                style: TextStyle(fontSize: 12),
                              );
                            case 6:
                              return Text(
                                'S',
                                style: TextStyle(fontSize: 12),
                              );
                            default:
                              return Text(
                                '',
                                style: TextStyle(fontSize: 12),
                              );
                          }
                        },
                        reservedSize: 22,
                        interval: 1,
                      ),
                    ),
                  ),
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        const FlSpot(0, 1),
                        FlSpot(1, 2),
                        FlSpot(2, 1.5),
                        FlSpot(3, 2.8),
                        FlSpot(4, 1.7),
                        FlSpot(5, 2.3),
                        FlSpot(6, 2),
                      ],
                      isCurved: true,
                      color: containerColor,
                      barWidth: 2,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.black.withOpacity(0.1),
                      ),
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 3,
                            color: Colors.white,
                            strokeWidth: 1,
                            strokeColor: Colors.blue,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
