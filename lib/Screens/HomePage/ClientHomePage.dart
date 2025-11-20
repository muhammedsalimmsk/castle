import 'package:castle/Colors/Colors.dart';
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
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: CustomAppBar(),
      backgroundColor: backgroundColor,
      body: Obx(() {
        if (dashboardController.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(buttonColor),
                  strokeWidth: 3,
                ),
                const SizedBox(height: 16),
                Text(
                  "Loading dashboard...",
                  style: TextStyle(
                    color: subtitleColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        }

        final data = dashboardController.dashboardData.value;
        final totalEquipment = data.equipment?.total?.toString() ?? "0";
        final totalComplaints = data.complaints?.total?.toString() ?? "0";
        final highPriority = data.complaintsByPriority?.high?.toString() ?? "0";
        final mediumPriority =
            data.complaintsByPriority?.medium?.toString() ?? "0";
        final lowPriority = data.complaintsByPriority?.low?.toString() ?? "0";

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Modern Header Section
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: cardShadowColor.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Dashboard",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: containerColor,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Overview Section
                Text(
                  "Overview",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: containerColor,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildStatCard(
                      icon: Icons.build_circle_outlined,
                      label: "Total Equipment",
                      value: totalEquipment,
                    ),
                    const SizedBox(width: 16),
                    _buildStatCard(
                      icon: Icons.folder_open,
                      label: "Total Complaints",
                      value: totalComplaints,
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Complaints by Priority Section
                Text(
                  "Complaints by Priority",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: containerColor,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildPriorityCard("High", highPriority, Colors.red),
                    const SizedBox(width: 12),
                    _buildPriorityCard("Medium", mediumPriority, Colors.orange),
                    const SizedBox(width: 12),
                    _buildPriorityCard("Low", lowPriority, Colors.green),
                  ],
                ),
                const SizedBox(height: 32),

                // Recent Complaints Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Recent Complaints",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: containerColor,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Column(
                  children: List.generate(
                    data.recentComplaints?.length ?? 0,
                    (index) {
                      final complaint = data.recentComplaints![index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Get.toNamed('/complaintDetails',
                                  arguments: {'complaintId': complaint.id!});
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: backgroundColor,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: dividerColor,
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: cardShadowColor.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.red.shade400,
                                          Colors.red.shade400.withOpacity(0.7),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.red.shade400
                                              .withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.report_problem,
                                      color: backgroundColor,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          complaint.title ?? "N/A",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: containerColor,
                                            letterSpacing: -0.3,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            Icon(Icons.calendar_today,
                                                size: 14, color: subtitleColor),
                                            const SizedBox(width: 4),
                                            Text(
                                              DateFormat('MMM dd, yyyy')
                                                  .format(complaint.createdAt!),
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: subtitleColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _statusColor(complaint.status ?? "")
                                          .withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      complaint.status ?? "Pending",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: _statusColor(
                                            complaint.status ?? ""),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if ((data.recentComplaints?.length ?? 0) == 0)
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: searchBackgroundColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 64,
                          color: subtitleColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "No recent complaints",
                          style: TextStyle(
                            color: containerColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Your recent complaints will appear here",
                          style: TextStyle(
                            color: subtitleColor,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: dividerColor,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: cardShadowColor.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    buttonColor,
                    buttonColor.withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: buttonColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, size: 28, color: backgroundColor),
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: containerColor,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: subtitleColor,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: color,
                fontWeight: FontWeight.w600,
              ),
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
