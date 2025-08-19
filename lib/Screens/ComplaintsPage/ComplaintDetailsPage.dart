import 'package:castle/Controlls/ComplaintController/ComplaintController.dart';
import 'package:castle/Screens/ComplaintsPage/Widgets/ComplaitTImeLineWidget.dart'
    hide TimelineEntry;
import 'package:castle/Screens/ComplaintsPage/Widgets/PartsRequestDialogue.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:castle/Model/complaint_model/datum.dart';
import 'package:castle/Colors/Colors.dart';
import 'package:get/get.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../../Controlls/AuthController/AuthController.dart';
import '../../Model/TimeLineEntry.dart';
import '../../Model/complaint_detail_model/comment.dart';
import '../../Model/complaint_detail_model/status_update.dart';
import '../PartsRequestPagee/RequestedPartWorkerPage.dart';
import 'AssignWorkPage/AssignWorkPage.dart';
import 'Widgets/AddCommentDialogue.dart';
import 'Widgets/StatusUpdateDialogue.dart';

class ComplaintDetailsPage extends StatelessWidget {
  final String complaintId;
  final ComplaintController complaintController = Get.put(ComplaintController());

  ComplaintDetailsPage({super.key, required this.complaintId});

  /// Formats a raw API string (e.g., "IN_PROGRESS" or "parts_requested")
  /// into a user-friendly format (e.g., "In Progress" or "Parts Requested").
  String formatApiString(String? rawString) {
    if (rawString == null || rawString.isEmpty) {
      return "N/A";
    }
    // Replace underscores with spaces, convert to lowercase, and split into words
    final words = rawString.replaceAll('_', ' ').toLowerCase().split(' ');

    // Capitalize the first letter of each word
    final capitalizedWords = words.map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1);
    });

    // Join the words back together with a space
    return capitalizedWords.join(' ');
  }

  String formatDate(DateTime? date) {
    if (date == null) return "N/A";
    return DateFormat('dd MMM yyyy, hh:mm a').format(date);
  }

  List<TimelineEntry> getCombinedTimeline(
      List<StatusUpdate> statusUpdates, List<Comment> comments) {
    final entries = <TimelineEntry>[];

    for (var s in statusUpdates) {
      entries.add(TimelineEntry(
        type: "STATUS",
        title: formatApiString(s.status), // Use the formatter
        subtitle: s.notes ?? "",
        time: s.updatedAt ?? DateTime.now(),
      ));
    }

    for (var c in comments) {
      entries.add(TimelineEntry(
        type: "COMMENT",
        title: c.author?.firstName ?? "Comment",
        subtitle: c.content ?? "",
        time: c.updatedAt ?? DateTime.now(),
      ));
    }

    // Sort by time descending
    entries.sort((a, b) => b.time.compareTo(a.time));
    return entries;
  }

  Color getPriorityColor(String? priority) {
    switch (priority?.toUpperCase()) {
      case "URGENT":
        return Colors.redAccent;
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

  Color getStatusColor(String? status) {
    switch (status?.toUpperCase()) {
      case "OPEN":
        return containerColor;
      case "IN_PROGRESS":
        return Colors.green;
      case "RESOLVED":
        return Colors.green;
      case "CLOSED":
        return containerColor;
      default:
        return containerColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Complaint Details'),
        backgroundColor: backgroundColor,
        elevation: 0,
        foregroundColor: containerColor,
      ),
      body: GetBuilder<ComplaintController>(
        initState: (_) => complaintController.fetchComplaintDetails(
            complaintId, userDetailModel!.data!.role!.toLowerCase()),
        builder: (_) {
          if (complaintController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final complaint = complaintController.complaintDetailModel.data!;
          final combinedTimeline = getCombinedTimeline(
            complaint.statusUpdates ?? [],
            complaint.comments ?? [],
          );
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sectionTitle("Complaint Info"),
                buildStyledCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        complaint.title ?? 'No Title',
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Chip(
                            label: Text(formatApiString(complaint.status)),
                            backgroundColor: getStatusColor(complaint.status),
                            labelStyle: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(width: 8),
                          Chip(
                            label: Text(formatApiString(complaint.priority)),
                            backgroundColor:
                                getPriorityColor(complaint.priority),
                            labelStyle: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (complaint.teamLead != null)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Assigned To:",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(
                                "${complaint.teamLead!.firstName!} ${complaint.teamLead!.lastName!}"),
                          ],
                        ),
                      if (complaint.description?.isNotEmpty == true)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Description",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Text(complaint.description!),
                          ],
                        ),
                    ],
                  ),
                ),
                sectionTitle("Equipment Details"),
                buildStyledCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (complaint.equipment != null)
                        Row(
                          children: [
                            const Icon(
                              Icons.build_circle_outlined,
                              size: 30,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              complaint.equipment?.name ?? "N/A",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 18),
                            ),
                          ],
                        ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 18,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Text("Reported: ${formatDate(complaint.reportedAt)}"),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 18,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Text("Created: ${formatDate(complaint.createdAt)}"),
                        ],
                      ),
                    ],
                  ),
                ),
                if (userDetailModel!.data!.role == "WORKER") ...[
                  sectionTitle("Parts Request"),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () async {
                          await complaintController.getPartsList();
                          Get.dialog(PartRequestDialog(
                            complaintId: complaint.id!,
                            type: 'CLIENT_PROVIDED',
                          ));
                        },
                        icon: Icon(Icons.build),
                        label: Text("Parts-Client"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: () async {
                          await complaintController.getPartsList();
                          Get.dialog(PartRequestDialog(
                            complaintId: complaint.id!,
                            type: 'ADMIN_INVENTORY',
                          ));
                        },
                        icon: Icon(Icons.build),
                        label: Text("Parts-Admin"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await complaintController.getRequestedPartsList();
                      Get.to(() => RequestedPartsWorkerPage());
                    },
                    icon: Icon(Icons.list),
                    label: Text("View Requested Parts"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: containerColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
                if (userDetailModel!.data!.role != "WORKER")
                  ElevatedButton.icon(
                    onPressed: () {
                      Get.dialog(AddCommentDialog(complaintId: complaint.id!));
                    },
                    icon: const Icon(Icons.add_comment_outlined),
                    label: const Text("Add Comments"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                if (combinedTimeline.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sectionTitle("Timeline"),
                      buildStyledCard(
                        child: ComplaintTimelineWidget(
                          entries: combinedTimeline,
                        ),
                      ),
                    ],
                  ),
                userDetailModel!.data!.role == "ADMIN" &&
                        complaint.assignedWorkers!.isEmpty
                    ? GestureDetector(
                        onTap: () {
                          Get.to(AssignWorkPage(complaintId: complaintId));
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: buttonColor),
                          child: Center(
                              child: Text(
                            "Assign Complaint",
                            style: TextStyle(color: backgroundColor),
                          )),
                        ),
                      )
                    : SizedBox.shrink()
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildStyledCard({required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: buttonColor, width: 1.2),
        boxShadow: const [
          BoxShadow(color: borderColor, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: child,
    );
  }

  Widget sectionTitle(String title) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          title,
          style: TextStyle(
            color: containerColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
}
