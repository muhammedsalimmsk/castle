import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:castle/Colors/Colors.dart';

import '../RoutineScreens/AssignRoutinePage/AssignRoutinePage.dart'; // Your existing color theme

class WorkerDetailsPage extends StatelessWidget {
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final bool? isActive;
  final String workerId;
  final DateTime? createdAt;
  final int? assignedComplaints;
  final int? routines;
  const WorkerDetailsPage(
      {super.key,
      required this.email,
      required this.firstName,
      required this.lastName,
      required this.phone,
      required this.workerId,
      required this.isActive,
      required this.createdAt,
      required this.assignedComplaints,
      required this.routines});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Worker Details"),
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
                color: secondaryColor,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: containerColor,
                          child: Text(
                            (firstName ?? 'W')[0].toUpperCase(),
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      _buildDetail(
                          "Full Name", "${firstName ?? ''} ${lastName ?? ''}"),
                      _buildDetail("Email", email ?? "-"),
                      _buildDetail("Phone", phone ?? "-"),
                      _buildDetail(
                          "Status", isActive == true ? "Active" : "Inactive",
                          valueColor:
                              isActive == true ? Colors.green : Colors.red),
                      _buildDetail(
                          "Assigned Complaints", "$assignedComplaints"),
                      _buildDetail("Assigned Routines", "$routines"),
                      _buildDetail(
                          "Joined At",
                          createdAt != null
                              ? "${createdAt!.day}-${createdAt!.month}-${createdAt!.year}"
                              : "-"),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
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
