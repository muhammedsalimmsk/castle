import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../Colors/Colors.dart';

import '../../../Model/dashboard_model/data.dart';
import 'ActivityChart.dart';

class TopWidgetOfHomePage extends StatelessWidget {
  final DashboardData? data;
  const TopWidgetOfHomePage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final totalTasks = data?.complaints?.total ?? 0;
    final completedTask = data?.complaints?.closed ?? 0;
    final runningTask = data?.complaints?.inProgress ?? 0;

// Prevent division by zero
    final runningTaskPercent =
        totalTasks > 0 ? (runningTask / totalTasks) : 0.0;
    final taskPercent = totalTasks > 100 ? (runningTask / totalTasks) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Running Task",
                      style: TextStyle(
                          color: backgroundColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "$runningTask",
                      style: const TextStyle(
                          color: backgroundColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircularPercentIndicator(
                        radius: 20,
                        lineWidth: 4.0,
                        percent: runningTaskPercent,
                        center: Text(
                          taskPercent.toString(),
                          style: TextStyle(
                            color: backgroundColor,
                            fontSize: 12,
                          ),
                        ),
                        progressColor: buttonColor,
                        backgroundColor: shadeColor,
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            totalTasks.toString(),
                            style: TextStyle(
                                color: backgroundColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                          Text(
                            "Tasks",
                            style: TextStyle(color: shadeColor, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        // const SizedBox(
        //   height: 180,
        //   child: Padding(
        //     padding: EdgeInsets.all(8.0),
        //     child: ActivityChart(),
        //   ),
        // ),
      ],
    );
  }
}
