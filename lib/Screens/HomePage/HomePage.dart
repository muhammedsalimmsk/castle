import 'package:castle/Controlls/AuthController/AuthController.dart';
import 'package:castle/Controlls/EquipmentController/EquipmentController.dart';
import 'package:castle/Widget/CustomAppBarWidget.dart';
import 'package:castle/Widget/CustomDrawer.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../Colors/Colors.dart';
import '../../Controlls/ComplaintController/ComplaintController.dart';
import 'Widgets/ActivityChart.dart';
import 'Widgets/ComplaintWidget.dart';
import 'Widgets/TopWidget.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  EquipmentController equipmentController =
      Get.put(EquipmentController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ComplaintController());
    print(token);
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 10,
          children: [
            TopWidgetOfHomePage(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Resend Complaints",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: controller.scrollToLeft,
                      icon: const Icon(Icons.arrow_back_ios, size: 18),
                    ),
                    IconButton(
                      onPressed: controller.scrollToRight,
                      icon: const Icon(Icons.arrow_forward_ios, size: 18),
                    ),
                  ],
                ),
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: controller.scrollController,
              child: Row(
                children: List.generate(5, (index) {
                  return ComplaintWidget(
                    imagePath: 'assets/images/complaint.jpeg',
                    title: "Air Conditioner (AC)",
                    paragraph: 'Cooling is insufficient or not consistent.',
                    subtitle: 'Performance Issue',
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
