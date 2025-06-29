import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../Colors/Colors.dart';
import 'ActivityChart.dart';

class TopWidgetOfHomePage extends StatelessWidget {
  const TopWidgetOfHomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Running Task Container
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: double.infinity,
            height: 120, // Dynamically set height
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(color: containerColor, blurRadius: 5, spreadRadius: 1)
              ],
              color: containerColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        const Text(
                          "Running Task",
                          style: TextStyle(
                            color: backgroundColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        const Text(
                          "65",
                          style: TextStyle(
                            color: backgroundColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 30),
                      child: Row(
                        children: [
                          CircularPercentIndicator(
                            radius: 20,
                            lineWidth: 4.0,
                            percent: 0.45,
                            center: Text(
                              "45%",
                              style: TextStyle(
                                color: backgroundColor,
                                fontSize: 12,
                              ),
                            ),
                            progressColor: buttonColor,
                            backgroundColor: shadeColor,
                          ),
                          SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "100",
                                style: TextStyle(
                                    color: backgroundColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              ),
                              Text(
                                "Tasks",
                                style:
                                    TextStyle(color: shadeColor, fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),

        // Activity Chart
        SizedBox(
          height: 180, // Ensure same height as Running Task
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: const ActivityChart(),
          ),
        ),
      ],
    );
  }
}
