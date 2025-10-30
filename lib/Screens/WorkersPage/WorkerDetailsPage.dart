import 'package:castle/Controlls/WorkersController/WorkerController.dart';
import 'package:castle/Model/workers_model/datum.dart';
import 'package:castle/Screens/WorkersPage/CreateWorker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:castle/Colors/Colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class WorkerDetailsPage extends StatelessWidget {
  final WorkerData worker;
  WorkerDetailsPage({super.key, required this.worker});
  WorkerController controller = Get.put(WorkerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: backgroundColor,
        centerTitle: true,
        iconTheme: IconThemeData(color: buttonColor),
        title: Text(
          "Worker Details",
          style: TextStyle(color: buttonColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 4,
                color: backgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: CircleAvatar(
                              radius: 40,
                              backgroundColor: buttonColor,
                              child: Text(
                                (worker.firstName ?? 'W')[0].toUpperCase(),
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                controller.addWorkerData(worker);
                                Get.to(() => CreateWorker(
                                      workerId: worker.id,
                                    ));
                              },
                              icon: Icon(
                                Icons.edit,
                                color: buttonColor,
                              ))
                        ],
                      ),
                      SizedBox(height: 20),
                      _buildDetail("Full Name",
                          "${worker.firstName ?? ''} ${worker.lastName ?? ''}"),
                      _buildDetail("Email", worker.email ?? "-"),
                      _buildDetail("Phone", worker.phone ?? "-"),
                      _buildDetail("Status",
                          worker.isActive == true ? "Active" : "Inactive",
                          valueColor: worker.isActive == true
                              ? Colors.green
                              : Colors.red),
                      // _buildDetail("Assigned Complaints",
                      //     "${worker.count!.assignedComplaints}"),
                      // _buildDetail(
                      //     "Assigned Routines", "${worker.count!.routines}"),
                      _buildDetail(
                          "Joined At",
                          worker.createdAt != null
                              ? "${worker.createdAt!.day}-${worker.createdAt!.month}-${worker.createdAt!.year}"
                              : "-"),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              const Text(
                "Work Statistics",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _statCard(
                      icon: LucideIcons.listTodo,
                      title: "Assigned Routines",
                      value: worker.count?.routines ?? 0,
                      color: buttonColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _statCard(
                      icon: LucideIcons.toolCase,
                      title: "Assigned Complaints",
                      value: worker.count?.assignedComplaints ?? 0,
                      color: buttonColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                "Department Details",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),

              // Check if workerDepartments exist
              if (worker.workerDepartments != null &&
                  worker.workerDepartments!.isNotEmpty)
                Column(
                  children: worker.workerDepartments!.map((dept) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: buttonColor.withOpacity(0.3),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetail(
                            "Department Name",
                            dept.department?.name ?? "-",
                          ),
                          _buildDetail(
                            "Description",
                            dept.department?.description ?? "-",
                          ),
                          _buildDetail(
                            "Primary Department",
                            dept.isPrimary == true ? "Yes" : "No",
                            valueColor: dept.isPrimary == true
                                ? Colors.green
                                : Colors.red,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                )
              else
                const Text(
                  "No departments assigned",
                  style: TextStyle(color: Colors.grey),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard({
    required IconData icon,
    required String title,
    required int value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 8),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetail(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),
          Expanded(
            child: Text(
              ": $value",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: valueColor ?? Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
