import 'package:castle/Controlls/AuthController/AuthController.dart';
import 'package:castle/Controlls/EquipmentController/EquipmentController.dart';
import 'package:castle/Widget/CustomAppBarWidget.dart';
import 'package:castle/Widget/CustomDrawer.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Controlls/DashboardController/DashboardController.dart';
import 'Widgets/ActivityChart.dart';
import 'Widgets/ComplaintWidget.dart';
import 'Widgets/TopWidget.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final DashboardController dashboardController =
      Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (dashboardController.isLoading.value) {
        return Scaffold(
          appBar: CustomAppBar(),
          body: const Center(child: CircularProgressIndicator()),
        );
      }

      final data = dashboardController.dashboardData.value;

      return Scaffold(
        drawer: CustomDrawer(),
        appBar: CustomAppBar(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TopWidgetOfHomePage(data: data), // Pass data here
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Recent Complaints",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => {}, // implement if needed
                        icon: const Icon(Icons.arrow_back_ios, size: 18),
                      ),
                      IconButton(
                        onPressed: () => {}, // implement if needed
                        icon: const Icon(Icons.arrow_forward_ios, size: 18),
                      ),
                    ],
                  ),
                ],
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    data.recentComplaints?.length ?? 0,
                    (index) {
                      final complaint = data.recentComplaints![index];
                      return ComplaintWidget(
                        location: complaint.client!.clientName ?? "N/A",
                        date: DateFormat('MMM dd, yyyy')
                            .format(complaint.createdAt!),
                        imagePath: 'assets/images/complaint.jpeg',
                        title: complaint.title ??
                            "N/A", // Use complaint.title if available
                        paragraph: complaint.description ?? "N/A",
                        subtitle: complaint.teamLead ?? "N/A",
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
