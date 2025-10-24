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
    return Obx(() {
      if (dashboardController.isLoading.value) {
        return Scaffold(
          appBar: CustomAppBar(),
          body: const Center(child: CircularProgressIndicator()),
        );
      }

      final data = dashboardController.dashboardData.value;
      final complaints = data.complaints;
      final complaintsByPriority = data.complaintsByPriority;
      final partRequests = data.partRequests;
      final routineTasks = data.routineTasks;

      return Scaffold(
        drawer: CustomDrawer(),
        appBar: CustomAppBar(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle("Complaints Overview"),
              const SizedBox(height: 15),
              Row(
                children: [
                  _buildGradientCard(Icons.warning, "Total Task",
                      complaints?.total?.toString() ?? "0", Colors.blue),
                  const SizedBox(width: 14),
                  _buildGradientCard(Icons.assignment_ind, "Assigned Task",
                      complaints?.assigned?.toString() ?? "0", Colors.purple),
                  const SizedBox(width: 14),
                  _buildGradientCard(Icons.pending_actions, "Pending Task",
                      complaints?.pending?.toString() ?? "0", Colors.orange),
                  const SizedBox(width: 14),
                  _buildGradientCard(Icons.check_circle, "Completed Task",
                      complaints?.completed?.toString() ?? "0", Colors.green),
                ],
              ),
              const SizedBox(height: 25),
              _sectionTitle("Complaints by Priority"),
              const SizedBox(height: 10),
              Row(
                children: [
                  _buildPriorityChip(
                      "Urgent",
                      complaintsByPriority?.urgent?.toString() ?? "0",
                      Colors.red),
                  const SizedBox(width: 8),
                  _buildPriorityChip(
                      "High",
                      complaintsByPriority?.high?.toString() ?? "0",
                      Colors.orange),
                  const SizedBox(width: 8),
                  _buildPriorityChip(
                      "Medium",
                      complaintsByPriority?.medium?.toString() ?? "0",
                      Colors.blue),
                  const SizedBox(width: 8),
                  _buildPriorityChip(
                      "Low",
                      complaintsByPriority?.low?.toString() ?? "0",
                      Colors.green),
                ],
              ),
              const SizedBox(height: 25),
              _sectionTitle("Part Requests"),
              const SizedBox(height: 10),
              Row(
                children: [
                  _buildPriorityChip("Pending",
                      partRequests?.pending?.toString() ?? "0", Colors.orange),
                  const SizedBox(width: 8),
                  _buildPriorityChip("Approved",
                      partRequests?.approved?.toString() ?? "0", Colors.green),
                  const SizedBox(width: 8),
                  _buildPriorityChip("Collected",
                      partRequests?.collected?.toString() ?? "0", Colors.blue),
                  const SizedBox(width: 8),
                  _buildPriorityChip("Rejected",
                      partRequests?.rejected?.toString() ?? "0", Colors.red),
                ],
              ),
              const SizedBox(height: 25),
              _sectionTitle("Routine Tasks"),
              const SizedBox(height: 10),
              Row(
                children: [
                  _buildPriorityChip("Pending",
                      routineTasks?.pending?.toString() ?? "0", Colors.orange),
                  const SizedBox(width: 8),
                  _buildPriorityChip("In Progress",
                      routineTasks?.inProgress?.toString() ?? "0", Colors.blue),
                  const SizedBox(width: 8),
                  _buildPriorityChip("Completed",
                      routineTasks?.completed?.toString() ?? "0", Colors.green),
                  const SizedBox(width: 8),
                  _buildPriorityChip("Skipped",
                      routineTasks?.skipped?.toString() ?? "0", Colors.grey),
                ],
              ),
              const SizedBox(height: 25),
              _sectionTitle("Recent Complaints"),
              const SizedBox(height: 10),
              Column(
                children: List.generate(
                  data.recentComplaints?.length ?? 0,
                  (index) {
                    final c = data.recentComplaints![index];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border(
                          left: BorderSide(
                            color: _priorityColor(c.priority ?? ""),
                            width: 4,
                          ),
                        ),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        title: Text(
                          c.title ?? "N/A",
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Client: ${c.client?.clientName ?? "N/A"}",
                                  style: TextStyle(color: Colors.grey[700])),
                              Text("Equipment: ${c.equipment?.name ?? "N/A"}",
                                  style: TextStyle(color: Colors.grey[700])),
                              Text(
                                  "Reported: ${DateFormat('MMM dd').format(c.reportedAt!)}",
                                  style: TextStyle(color: Colors.grey[700])),
                            ],
                          ),
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color:
                                _statusColor(c.status ?? "").withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            c.status ?? "Pending",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _statusColor(c.status ?? ""),
                            ),
                          ),
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

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
          fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
    );
  }

  Widget _buildGradientCard(
      IconData icon, String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16), color: buttonColor),
        child: Column(
          children: [
            Icon(icon, size: 28, color: Colors.white),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 2),
            Center(
                child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityChip(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color, width: 1),
        ),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 13, color: color)),
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
