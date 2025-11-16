import 'package:castle/Colors/Colors.dart';
import 'package:castle/Controlls/ComplaintController/ComplaintController.dart';
import 'package:castle/Controlls/EquipmentController/EquipmentController.dart';
import 'package:castle/Controlls/WorkersController/WorkerController.dart';
import 'package:castle/Screens/ComplaintsPage/ComplaintDetailsPage.dart';
import 'package:castle/Widget/CustomAppBarWidget.dart';
import 'package:castle/Widget/CustomDrawer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../Controlls/AuthController/AuthController.dart';
import 'Widgets/FilterPage.dart';

class ComplaintPage extends StatelessWidget {
  ComplaintPage({super.key});
  final ComplaintController complaintController =
      Get.put(ComplaintController());
  final WorkerController workerController = Get.put(WorkerController());

  Color _getPriorityColor(String? priority) {
    switch (priority?.toUpperCase()) {
      case 'URGENT':
        return Colors.red.shade600;
      case 'HIGH':
        return Colors.orange.shade600;
      case 'MEDIUM':
        return Colors.amber.shade600;
      case 'LOW':
        return Colors.green.shade600;
      default:
        return buttonColor;
    }
  }

  Color _getStatusColor(String? status) {
    switch (status?.toUpperCase()) {
      case 'OPEN':
        return Colors.red.shade50;
      case 'ASSIGNED':
        return Colors.blue.shade50;
      case 'IN_PROGRESS':
        return Colors.orange.shade50;
      case 'RESOLVED':
        return Colors.green.shade50;
      case 'CLOSED':
        return Colors.grey.shade100;
      default:
        return Colors.grey.shade50;
    }
  }

  Color _getStatusTextColor(String? status) {
    switch (status?.toUpperCase()) {
      case 'OPEN':
        return Colors.red.shade700;
      case 'ASSIGNED':
        return Colors.blue.shade700;
      case 'IN_PROGRESS':
        return Colors.orange.shade700;
      case 'RESOLVED':
        return Colors.green.shade700;
      case 'CLOSED':
        return Colors.grey.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    EquipmentController controller = Get.put(EquipmentController());
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: CustomAppBar(),
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            // Modern Search and Filter Section
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              decoration: BoxDecoration(
                color: backgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Search Bar
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Search complaints...",
                              hintStyle: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 15,
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.grey.shade400,
                                size: 22,
                              ),
                              suffixIcon: Icon(
                                Icons.tune,
                                color: Colors.grey.shade400,
                                size: 20,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Modern Filter Button
                      Material(
                        color: buttonColor,
                        borderRadius: BorderRadius.circular(16),
                        elevation: 2,
                        child: InkWell(
                          onTap: () {
                            Get.dialog(FilterDialog());
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              FontAwesomeIcons.sliders,
                              color: backgroundColor,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Header with Sort
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Complaints",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: containerColor,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.shade200,
                            width: 1,
                          ),
                        ),
                        child: Obx(
                          () => DropdownButton<String>(
                            isDense: true,
                            padding: EdgeInsets.zero,
                            value: controller.selectedValue.value,
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: containerColor,
                            ),
                            underline: const SizedBox(),
                            borderRadius: BorderRadius.circular(12),
                            style: TextStyle(
                              color: containerColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            items: controller.sortOptions
                                .map<DropdownMenuItem<String>>(
                              (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              },
                            ).toList(),
                            onChanged: (String? newValue) {
                              controller.selectedValue.value = newValue!;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Complaints List
            Expanded(
              child: GetBuilder<ComplaintController>(
                builder: (complaintController) {
                  if (complaintController.isLoading.value &&
                      complaintController.details.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              buttonColor,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Loading complaints...",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (complaintController.details.isEmpty &&
                      !complaintController.isRefresh) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            size: 80,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "No complaints found",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "There are no complaints to display",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      complaintController.hasMore = true;
                      complaintController.isRefresh = true;
                      await complaintController.getComplaint(
                        role: userDetailModel!.data!.role!.toLowerCase(),
                      );
                      complaintController.isRefresh = false;
                      complaintController.update();
                    },
                    color: buttonColor,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(20),
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: complaintController.scrollController,
                      itemCount: complaintController.details.length + 1,
                      itemBuilder: (context, index) {
                        if (index < complaintController.details.length) {
                          var datas = complaintController.details[index];
                          return _buildComplaintCard(context, datas);
                        } else {
                          return complaintController.hasMore
                              ? Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        buttonColor,
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink();
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComplaintCard(BuildContext context, dynamic datas) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            Get.to(
              ComplaintDetailsPage(
                complaintId: datas.id!,
              ),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Equipment Icon
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: buttonColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.build_circle_outlined,
                        color: buttonColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Equipment Name and Title
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            datas.equipment!.name!,
                            style: TextStyle(
                              color: containerColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              letterSpacing: -0.3,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (datas.title != null && datas.title!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                datas.title!,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                  height: 1.4,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Status and Priority Row
                Row(
                  children: [
                    // Priority Badge
                    if (datas.priority != null && datas.priority!.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _getPriorityColor(datas.priority)
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.flag,
                              size: 14,
                              color: _getPriorityColor(datas.priority),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              datas.priority!,
                              style: TextStyle(
                                color: _getPriorityColor(datas.priority),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const Spacer(),
                    // Status Badge
                    if (datas.status != null && datas.status!.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(datas.status),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          datas.status!.replaceAll('_', ' '),
                          style: TextStyle(
                            color: _getStatusTextColor(datas.status),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    // Admin Assign Badge
                    if (userDetailModel!.data!.role == "ADMIN")
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: datas.status == "OPEN"
                                ? Colors.red.shade50
                                : Colors.green.shade50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: datas.status == "OPEN"
                                  ? Colors.red.shade200
                                  : Colors.green.shade200,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                datas.status == "OPEN"
                                    ? Icons.pending_outlined
                                    : Icons.check_circle_outline,
                                size: 14,
                                color: datas.status == "OPEN"
                                    ? Colors.red.shade700
                                    : Colors.green.shade700,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                datas.status == "OPEN" ? "Assign" : "Assigned",
                                style: TextStyle(
                                  color: datas.status == "OPEN"
                                      ? Colors.red.shade700
                                      : Colors.green.shade700,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
