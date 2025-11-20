import 'package:castle/Colors/Colors.dart';
import 'package:castle/Widget/CustomAppBarWidget.dart';
import 'package:castle/Widget/CustomDrawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../Controlls/DashboardController/WorkerDashboardController.dart';

class WorkerHomePage extends StatelessWidget {
  WorkerHomePage({super.key});

  final WorkerDashboardController dashboardController =
      Get.put(WorkerDashboardController());

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
        final complaints = data.complaints;
        final complaintsByPriority = data.complaintsByPriority;
        final partRequests = data.partRequests;
        final routineTasks = data.routineTasks;

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

                // Complaints Overview Section
                _sectionTitle("Complaints Overview"),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildStatCard(Icons.warning, "Total Task",
                        complaints?.total?.toString() ?? "0", Colors.blue),
                    const SizedBox(width: 12),
                    _buildStatCard(Icons.assignment_ind, "Assigned Task",
                        complaints?.assigned?.toString() ?? "0", Colors.purple),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildStatCard(Icons.pending_actions, "Pending Task",
                        complaints?.pending?.toString() ?? "0", Colors.orange),
                    const SizedBox(width: 12),
                    _buildStatCard(Icons.check_circle, "Completed Task",
                        complaints?.completed?.toString() ?? "0", Colors.green),
                  ],
                ),
                const SizedBox(height: 32),

                // Complaints by Priority Section
                _sectionTitle("Complaints by Priority"),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildPriorityChip("Urgent",
                        complaintsByPriority?.urgent?.toString() ?? "0",
                        Colors.red),
                    const SizedBox(width: 12),
                    _buildPriorityChip("High",
                        complaintsByPriority?.high?.toString() ?? "0",
                        Colors.orange),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildPriorityChip("Medium",
                        complaintsByPriority?.medium?.toString() ?? "0",
                        Colors.blue),
                    const SizedBox(width: 12),
                    _buildPriorityChip("Low",
                        complaintsByPriority?.low?.toString() ?? "0",
                        Colors.green),
                  ],
                ),
                const SizedBox(height: 32),

                // Part Requests Section
                _sectionTitle("Part Requests"),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildPriorityChip("Pending",
                        partRequests?.pending?.toString() ?? "0",
                        Colors.orange),
                    const SizedBox(width: 12),
                    _buildPriorityChip("Approved",
                        partRequests?.approved?.toString() ?? "0",
                        Colors.green),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildPriorityChip("Collected",
                        partRequests?.collected?.toString() ?? "0",
                        Colors.blue),
                    const SizedBox(width: 12),
                    _buildPriorityChip("Rejected",
                        partRequests?.rejected?.toString() ?? "0", Colors.red),
                  ],
                ),
                const SizedBox(height: 32),

                // Routine Tasks Section
                _sectionTitle("Routine Tasks"),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildPriorityChip("Pending",
                        routineTasks?.pending?.toString() ?? "0",
                        Colors.orange),
                    const SizedBox(width: 12),
                    _buildPriorityChip("In Progress",
                        routineTasks?.inProgress?.toString() ?? "0",
                        Colors.blue),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildPriorityChip("Completed",
                        routineTasks?.completed?.toString() ?? "0",
                        Colors.green),
                    const SizedBox(width: 12),
                    _buildPriorityChip("Skipped",
                        routineTasks?.skipped?.toString() ?? "0", Colors.grey),
                  ],
                ),
                const SizedBox(height: 32),

                // Recent Complaints Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _sectionTitle("Recent Complaints"),
                  ],
                ),
                const SizedBox(height: 16),
                Column(
                  children: List.generate(
                    data.recentComplaints?.length ?? 0,
                    (index) {
                      final c = data.recentComplaints![index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Get.toNamed('/complaintDetails',
                                  arguments: {'complaintId': c.id!});
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
                                    width: 4,
                                    decoration: BoxDecoration(
                                      color: _priorityColor(c.priority ?? ""),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        bottomLeft: Radius.circular(16),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          c.title ?? "N/A",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: containerColor,
                                            letterSpacing: -0.3,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Icon(Icons.business,
                                                size: 14, color: subtitleColor),
                                            const SizedBox(width: 4),
                                            Flexible(
                                              child: Text(
                                                "Client: ${c.client?.clientName ?? "N/A"}",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: subtitleColor,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(Icons.precision_manufacturing,
                                                size: 14, color: subtitleColor),
                                            const SizedBox(width: 4),
                                            Flexible(
                                              child: Text(
                                                "Equipment: ${c.equipment?.name ?? "N/A"}",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: subtitleColor,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(Icons.calendar_today,
                                                size: 14, color: subtitleColor),
                                            const SizedBox(width: 4),
                                            Text(
                                              "Reported: ${DateFormat('MMM dd, yyyy').format(c.reportedAt!)}",
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
                                      color: _statusColor(c.status ?? "")
                                          .withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      c.status ?? "Pending",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: _statusColor(c.status ?? ""),
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

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: containerColor,
        letterSpacing: -0.3,
      ),
    );
  }

  Widget _buildStatCard(
      IconData icon, String label, String value, Color color) {
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
                    color,
                    color.withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
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
                fontSize: 13,
                color: subtitleColor,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityChip(String label, String value, Color color) {
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

  Color _priorityColor(String priority) {
    switch (priority.toUpperCase()) {
      case "URGENT":
        return Colors.red;
      case "HIGH":
        return Colors.orange;
      case "MEDIUM":
        return Colors.blue;
      case "LOW":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case "COMPLETED":
        return Colors.green;
      case "IN PROGRESS":
        return Colors.orange;
      case "ASSIGNED":
        return Colors.blue;
      case "PENDING":
      default:
        return Colors.red;
    }
  }
}
