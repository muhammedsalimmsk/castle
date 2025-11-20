import 'package:castle/Controlls/WorkersController/WorkerController.dart';
import 'package:castle/Model/workers_model/datum.dart';
import 'package:castle/Model/workers_model/worker_department.dart';
import 'package:castle/Screens/WorkersPage/CreateWorker.dart';
import 'package:castle/Screens/LoginDetailsPage/LoginDetailsPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:castle/Colors/Colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:intl/intl.dart';

class WorkerDetailsPage extends StatelessWidget {
  final WorkerData worker;
  WorkerDetailsPage({super.key, required this.worker});
  final WorkerController controller = Get.put(WorkerController());

  String formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('dd MMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final fullName = "${worker.firstName ?? ''} ${worker.lastName ?? ''}".trim();
    final initials = fullName.isNotEmpty
        ? fullName.split(' ').map((n) => n[0]).take(2).join().toUpperCase()
        : 'W';

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        surfaceTintColor: backgroundColor,
        elevation: 0,
        backgroundColor: backgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: containerColor),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Worker Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: containerColor,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              controller.addWorkerData(worker);
              Get.toNamed('/createWorker', arguments: {'workerId': worker.id});
            },
            icon: Icon(
              Icons.edit_rounded,
              color: buttonColor,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Modern Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
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
              child: Column(
                children: [
                  // Icon Container
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          buttonColor,
                          buttonColor.withOpacity(0.7),
                        ],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: buttonColor.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        initials,
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: backgroundColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Worker Name
                  Text(
                    fullName.isEmpty ? 'Unknown Worker' : fullName,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: containerColor,
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: worker.isActive == true
                          ? workingWidgetColor
                          : notWorkingWidgetColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: worker.isActive == true
                                ? workingTextColor
                                : notWorkingTextColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          worker.isActive == true ? "Active" : "Inactive",
                          style: TextStyle(
                            color: worker.isActive == true
                                ? workingTextColor
                                : notWorkingTextColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Worker Information Section
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: _sectionTitle('Worker Information'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
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
                      color: cardShadowColor.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildInfoRow(
                      Icons.person_rounded,
                      "Full Name",
                      fullName.isEmpty ? 'N/A' : fullName,
                    ),
                    if (worker.email != null) ...[
                      const Divider(height: 24, color: dividerColor),
                      _buildInfoRow(
                        Icons.email_rounded,
                        "Email",
                        worker.email!,
                      ),
                    ],
                    if (worker.phone != null) ...[
                      const Divider(height: 24, color: dividerColor),
                      _buildInfoRow(
                        Icons.phone_rounded,
                        "Phone",
                        worker.phone!,
                      ),
                    ],
                    const Divider(height: 24, color: dividerColor),
                    _buildInfoRow(
                      Icons.calendar_today_rounded,
                      "Joined At",
                      formatDate(worker.createdAt),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Work Statistics Section
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
              child: _sectionTitle('Work Statistics'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: _statCard(
                      icon: LucideIcons.listTodo,
                      title: "Assigned Routines",
                      value: worker.count?.routines ?? 0,
                      color: buttonColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _statCard(
                      icon: LucideIcons.toolCase,
                      title: "Assigned Complaints",
                      value: worker.count?.assignedComplaints ?? 0,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Department Details Section
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
              child: _sectionTitle('Department Details'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: worker.workerDepartments != null &&
                      worker.workerDepartments!.isNotEmpty
                  ? Column(
                      children: worker.workerDepartments!.map((dept) {
                        return _buildDepartmentCard(dept);
                      }).toList(),
                    )
                  : Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: searchBackgroundColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: dividerColor,
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "No departments assigned",
                          style: TextStyle(
                            color: subtitleColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 24),
            // Login Details Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Get.toNamed('/loginDetails', arguments: {'userId': worker.id ?? '', 'isClient': false});
                  },
                  icon: const Icon(LucideIcons.logIn, size: 20),
                  label: const Text("View Login Details"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: containerColor,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: buttonColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: buttonColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: subtitleColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  color: containerColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _statCard({
    required IconData icon,
    required String title,
    required int value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: cardShadowColor.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: subtitleColor,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDepartmentCard(WorkerDepartment dept) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
            color: cardShadowColor.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.business_center_rounded,
                  color: Colors.purple,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dept.department?.name ?? 'N/A',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: containerColor,
                      ),
                    ),
                    if (dept.isPrimary == true)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: workingWidgetColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 5,
                              height: 5,
                              decoration: BoxDecoration(
                                color: workingTextColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "Primary",
                              style: TextStyle(
                                color: workingTextColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (dept.department?.description != null &&
              dept.department!.description!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: searchBackgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                dept.department!.description!,
                style: TextStyle(
                  fontSize: 13,
                  color: containerColor,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

}
