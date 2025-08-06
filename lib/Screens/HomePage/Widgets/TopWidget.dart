import 'package:castle/Model/dashboard_model/data.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../Colors/Colors.dart';
import 'ActivityChart.dart';

class TopWidgetOfHomePage extends StatelessWidget {
  final DashboardData? data;
  const TopWidgetOfHomePage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final totalTasks = data?.overview?.complaints?.total ?? 0;
    final runningTaskPercent = totalTasks > 0 ? 0.45 : 0.0;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: double.infinity,
            height: 120,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: containerColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(color: containerColor, blurRadius: 5, spreadRadius: 1)
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Running Task",
                      style: TextStyle(
                          color: backgroundColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "$totalTasks",
                      style: const TextStyle(
                          color: backgroundColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    ),
                  ],
                ),
                Row(
                  children: [
                    CircularPercentIndicator(
                      radius: 20,
                      lineWidth: 4.0,
                      percent: runningTaskPercent,
                      center: const Text(
                        "45%",
                        style: TextStyle(color: backgroundColor, fontSize: 12),
                      ),
                      progressColor: buttonColor,
                      backgroundColor: shadeColor,
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$totalTasks",
                          style: const TextStyle(
                              color: backgroundColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                        const Text(
                          "Tasks",
                          style: TextStyle(color: shadeColor, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        const SizedBox(
          height: 180,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: ActivityChart(),
          ),
        ),
      ],
    );
  }
}
