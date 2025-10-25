import 'package:castle/Colors/Colors.dart';
import 'package:castle/Controlls/AuthController/AuthController.dart';
import 'package:castle/Screens/ComplaintsPage/ComplaintDetailsPage.dart';
import 'package:castle/Widget/CustomAppBarWidget.dart';
import 'package:castle/Widget/CustomDrawer.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../Controlls/DashboardController/CliientDashboardController.dart';

class ClientHomePage extends StatelessWidget {
  ClientHomePage({super.key});

  final ClientDashboardController dashboardController =
      Get.put(ClientDashboardController());

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
      final totalEquipment = data.equipment?.total?.toString() ?? "0";
      final totalComplaints = data.complaints?.total?.toString() ?? "0";
      final highPriority = data.complaintsByPriority?.high?.toString() ?? "0";
      final mediumPriority =
          data.complaintsByPriority?.medium?.toString() ?? "0";
      final lowPriority = data.complaintsByPriority?.low?.toString() ?? "0";
      print(token);
      print(data.equipment!.total);
      return Scaffold(
        drawer: CustomDrawer(),
        appBar: CustomAppBar(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== Overview =====
              Text(
                "Overview",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  _buildStatCard(
                    icon: Icons.build_circle_outlined,
                    label: "Total Equipment",
                    value: totalEquipment,
                  ),
                  const SizedBox(width: 12),
                  _buildStatCard(
                    icon: Icons.folder_open,
                    label: "Total Complaints",
                    value: totalComplaints,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ===== Complaints by Priority =====
              Text(
                "Complaints by Priority",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _buildPriorityCard("High", highPriority, Colors.red),
                  const SizedBox(width: 8),
                  _buildPriorityCard("Medium", mediumPriority, Colors.orange),
                  const SizedBox(width: 8),
                  _buildPriorityCard("Low", lowPriority, Colors.green),
                ],
              ),
              const SizedBox(height: 25),

              // ===== Recent Complaints =====
              Text(
                "Recent Complaints",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Column(
                children: List.generate(
                  data.recentComplaints?.length ?? 0,
                  (index) {
                    final complaint = data.recentComplaints![index];
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        onTap: () {
                          Get.to(() => ComplaintDetailsPage(
                                complaintId: complaint.id!,
                              ));
                        },
                        leading: Icon(Icons.report_problem,
                            color: Colors.red.shade400),
                        title: Text(complaint.title ?? "N/A"),
                        subtitle: Text(DateFormat('MMM dd, yyyy')
                            .format(complaint.createdAt!)),
                        trailing: Text(
                          complaint.status ?? "Pending",
                          style: TextStyle(
                              color: _statusColor(complaint.status ?? "")),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0), color: buttonColor),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: backgroundColor),
              const SizedBox(height: 10),
              Text(
                value,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: containerColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(fontSize: 14, color: backgroundColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color, width: 1),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(fontSize: 14, color: color),
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case "completed":
        return Colors.green;
      case "in progress":
        return Colors.orange;
      case "pending":
      default:
        return Colors.red;
    }
  }
}
