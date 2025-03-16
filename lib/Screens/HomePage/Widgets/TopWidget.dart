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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Running Task Container
        Expanded(
          flex: 1,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final containerHeight = constraints.maxWidth > 600
                  ? 250.0
                  : 180.0; // Adjust based on screen size
              return Container(
                margin: const EdgeInsets.only(right: 16),
                height: containerHeight, // Dynamically set height
                padding: EdgeInsets.all(constraints.maxWidth > 600 ? 16 : 8),
                decoration: BoxDecoration(
                  color: containerColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Running Task",
                      style: TextStyle(
                        color: backgroundColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: constraints.maxWidth > 600 ? 10 : 8),
                    const Text(
                      "65",
                      style: TextStyle(
                        color: backgroundColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    SizedBox(height: constraints.maxWidth > 600 ? 10 : 8),
                    Row(
                      children: [
                        CircularPercentIndicator(
                          radius: constraints.maxWidth > 600 ? 25 : 20,
                          lineWidth: 4.0,
                          percent: 0.45,
                          center: Text(
                            "45%",
                            style: TextStyle(
                              color: backgroundColor,
                              fontSize: constraints.maxWidth > 600 ? 14 : 12,
                            ),
                          ),
                          progressColor: buttonColor,
                          backgroundColor: shadeColor,
                        ),
                        SizedBox(width: constraints.maxWidth > 600 ? 10 : 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "100",
                              style: TextStyle(
                                  color: backgroundColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      constraints.maxWidth > 600 ? 14 : 12),
                            ),
                            Text(
                              "Tasks",
                              style: TextStyle(
                                  color: shadeColor,
                                  fontSize:
                                      constraints.maxWidth > 600 ? 14 : 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        // Activity Chart
        Expanded(
          flex: 2,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final chartHeight = constraints.maxWidth > 600
                  ? 250.0
                  : 180.0; // Adjust height dynamically
              return SizedBox(
                height: chartHeight, // Ensure same height as Running Task
                child: const ActivityChart(),
              );
            },
          ),
        ),
      ],
    );
  }
}
