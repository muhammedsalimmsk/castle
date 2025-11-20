import 'package:castle/Colors/Colors.dart';
import 'package:castle/Controlls/ComplaintController/ComplaintController.dart';
import 'package:castle/Controlls/WorkersController/WorkerController.dart';
import 'package:castle/Screens/ComplaintsPage/ComplaintDetailsPage.dart';
import 'package:castle/Widget/CustomAppBarWidget.dart';
import 'package:castle/Widget/CustomDrawer.dart';
import 'package:castle/Utils/ResponsiveHelper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: CustomAppBar(),
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: ResponsiveHelper.getMaxContentWidth(context),
            ),
            child: Column(
              children: [
                // Modern Header Section
                Container(
                  padding: ResponsiveHelper.getResponsivePadding(context),
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
                    "Complaints",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: containerColor,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Obx(
                    () => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: buttonColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: buttonColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        "${complaintController.details.length} Complaints",
                        style: TextStyle(
                          color: buttonColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
                // Search Bar
                Padding(
                  padding: ResponsiveHelper.getResponsivePadding(context).copyWith(
                    top: 12,
                    bottom: 16,
                  ),
                  child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: searchBackgroundColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: cardShadowColor.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: complaintController.searchController,
                        decoration: InputDecoration(
                          hintText: "Search complaints...",
                          hintStyle: TextStyle(
                            color: subtitleColor,
                            fontSize: 14,
                          ),
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: buttonColor,
                            size: 22,
                          ),
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Obx(() => complaintController.searchText.value.isNotEmpty
                                ? IconButton(
                                    onPressed: () {
                                      complaintController.searchController.clear();
                                      complaintController.search = '';
                                      complaintController.applyFilters(
                                        role: userDetailModel!.data!.role!.toLowerCase(),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.clear,
                                      color: subtitleColor,
                                      size: 20,
                                    ),
                                  )
                                : SizedBox.shrink(),
                              ),
                              IconButton(
                                onPressed: () {
                                  Get.dialog(FilterDialog());
                                },
                                icon: Icon(
                                  FontAwesomeIcons.sliders,
                                  color: buttonColor,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: buttonColor,
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          filled: true,
                          fillColor: searchBackgroundColor,
                        ),
                        onChanged: (value) {
                          // Search text is updated via listener in controller
                        },
                        onSubmitted: (value) {
                          complaintController.applyFilters(
                            role: userDetailModel!.data!.role!.toLowerCase(),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: searchBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: dividerColor,
                        width: 1,
                      ),
                    ),
                    child: Obx(
                      () => DropdownButton<String>(
                        isDense: true,
                        padding: EdgeInsets.zero,
                        value: complaintController.selectedSort.value.isEmpty
                            ? null
                            : complaintController.selectedSort.value,
                        hint: Text(
                          'Sort',
                          style: TextStyle(
                            color: containerColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: buttonColor,
                        ),
                        underline: const SizedBox(),
                        borderRadius: BorderRadius.circular(12),
                        style: TextStyle(
                          color: containerColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        items: [
                          DropdownMenuItem<String>(
                            value: '',
                            child: Text(
                              'None',
                              style: TextStyle(
                                color: containerColor,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          ...complaintController.sortOptions
                              .map<DropdownMenuItem<String>>(
                            (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            },
                          ).toList(),
                        ],
                        onChanged: (String? newValue) {
                          complaintController.setSort(newValue ?? '');
                          complaintController.applyFilters(
                            role: userDetailModel!.data!.role!.toLowerCase(),
                          );
                        },
                      ),
                    ),
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
                                valueColor: AlwaysStoppedAnimation<Color>(buttonColor),
                                strokeWidth: 3,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Loading complaints...",
                                style: TextStyle(
                                  color: subtitleColor,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      if (complaintController.details.isEmpty &&
                          !complaintController.isRefresh) {
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
                          child: ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              const SizedBox(height: 100),
                              Center(
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(24),
                                      decoration: BoxDecoration(
                                        color: searchBackgroundColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.report_problem_outlined,
                                        size: 64,
                                        color: subtitleColor,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    Text(
                                      "No complaints found",
                                      style: TextStyle(
                                        color: containerColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "There are no complaints to display",
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
                        );
                      }

                      // Use GridView for large screens, ListView for mobile
                      if (ResponsiveHelper.isLargeScreen(context)) {
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
                          child: GridView.builder(
                            padding: ResponsiveHelper.getResponsivePadding(context).copyWith(
                              top: 0,
                            ),
                            physics: const AlwaysScrollableScrollPhysics(),
                            controller: complaintController.scrollController,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: ResponsiveHelper.getGridCrossAxisCount(context),
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 12,
                              childAspectRatio: ResponsiveHelper.isDesktop(context) ? 1.3 : 1.2,
                            ),
                            itemCount: complaintController.details.length + 1,
                            itemBuilder: (context, index) {
                              if (index < complaintController.details.length) {
                                var datas = complaintController.details[index];
                                return _buildComplaintCard(context, datas);
                              } else {
                                return complaintController.hasMore
                                    ? Center(
                                        child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            buttonColor,
                                          ),
                                        ),
                                      )
                                    : const SizedBox.shrink();
                              }
                            },
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
                          padding: ResponsiveHelper.getResponsivePadding(context).copyWith(
                            top: 0,
                          ),
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
        ),
      ),
    );
  }

  Widget _buildComplaintCard(BuildContext context, dynamic datas) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            Get.toNamed(
              '/complaintDetails',
              arguments: {'complaintId': datas.id!},
            );
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
                // Icon Container
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
                  child: Icon(
                    Icons.report_problem_rounded,
                    color: backgroundColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        datas.equipment!.name!,
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
                      if (datas.title != null && datas.title!.isNotEmpty)
                        Text(
                          datas.title!,
                          style: TextStyle(
                            fontSize: 13,
                            color: subtitleColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      if (datas.reportedAt != null) ...[
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 14,
                              color: subtitleColor,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                "Reported: ${DateFormat('dd MMM yyyy').format(datas.reportedAt!)}",
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
                      ],
                      if (datas.dueDate != null) ...[
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.event_outlined,
                              size: 14,
                              color: subtitleColor,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                "Due: ${DateFormat('dd MMM yyyy').format(datas.dueDate!)}",
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
                      ],
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          // Priority Badge
                          if (datas.priority != null && datas.priority!.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
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
                                    size: 12,
                                    color: _getPriorityColor(datas.priority),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    datas.priority!,
                                    style: TextStyle(
                                      color: _getPriorityColor(datas.priority),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          // Status Badge
                          if (datas.status != null && datas.status!.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(datas.status),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                datas.status!.replaceAll('_', ' '),
                                style: TextStyle(
                                  color: _getStatusTextColor(datas.status),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Status Badge and Actions
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (userDetailModel!.data!.role == "ADMIN")
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: datas.status == "OPEN"
                              ? Colors.red.shade50
                              : Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
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
                              size: 12,
                              color: datas.status == "OPEN"
                                  ? Colors.red.shade700
                                  : Colors.green.shade700,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              datas.status == "OPEN" ? "Assign" : "Assigned",
                              style: TextStyle(
                                color: datas.status == "OPEN"
                                    ? Colors.red.shade700
                                    : Colors.green.shade700,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 8),
                    Icon(
                      Icons.chevron_right,
                      color: subtitleColor,
                      size: 18,
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

