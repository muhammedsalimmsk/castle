import 'package:castle/Controlls/ComplaintController/ComplaintController.dart';
import 'package:castle/Screens/ComplaintsPage/Widgets/ComplaitTImeLineWidget.dart'
    hide TimelineEntry;
import 'package:castle/Screens/ComplaintsPage/Widgets/PartsRequestDialogue.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:castle/Colors/Colors.dart';
import 'package:get/get.dart';
import '../../Controlls/AuthController/AuthController.dart';
import '../../Model/TimeLineEntry.dart';
import '../../Model/complaint_detail_model/comment.dart';
import '../../Model/complaint_detail_model/status_update.dart';
import '../PartsRequestPagee/RequestedPartWorkerPage.dart';
import 'AssignWorkPage/AssignWorkPage.dart';
import 'Widgets/StatusUpdateDialogue.dart';

class ComplaintDetailsPage extends StatefulWidget {
  final String complaintId;

  ComplaintDetailsPage({super.key, required this.complaintId});

  @override
  State<ComplaintDetailsPage> createState() => _ComplaintDetailsPageState();
}

class _ComplaintDetailsPageState extends State<ComplaintDetailsPage> {
  final ComplaintController complaintController =
      Get.put(ComplaintController());
  final TextEditingController commentController = TextEditingController();

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
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("complaint Id is ${widget.complaintId}");
    print(token);
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
          'Complaint Details',
          style: TextStyle(
            color: containerColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          if (userDetailModel!.data!.role == "ADMIN")
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: workingWidgetColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: backgroundColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            title: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: workingWidgetColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.check_circle,
                                    color: workingTextColor,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    "Close Complaint",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: containerColor,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            content: Text(
                              "Are you sure you want to close this complaint?",
                              style:
                                  TextStyle(color: subtitleColor, fontSize: 14),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(
                                    color: subtitleColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Obx(
                                () => complaintController.closeLoading.value
                                    ? Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: CircularProgressIndicator(
                                          color: buttonColor,
                                        ),
                                      )
                                    : ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: workingTextColor,
                                          foregroundColor: backgroundColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 12,
                                          ),
                                        ),
                                        onPressed: () {
                                          complaintController.closeComplaint(
                                              widget.complaintId);
                                        },
                                        icon: const Icon(Icons.check_circle,
                                            size: 20),
                                        label: const Text("Close"),
                                      ),
                              )
                            ],
                          );
                        },
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.assignment_turned_in_outlined,
                            color: workingTextColor,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "Close",
                            style: TextStyle(
                              color: workingTextColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: GetBuilder<ComplaintController>(
        initState: (_) => WidgetsBinding.instance.addPostFrameCallback((_) {
          complaintController.fetchComplaintDetails(
            widget.complaintId,
            userDetailModel!.data!.role!.toLowerCase(),
          );
        }),
        builder: (_) {
          if (complaintController.isLoading.value) {
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
                    "Loading complaint details...",
                    style: TextStyle(
                      color: subtitleColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }

          final complaint = complaintController.complaintDetailModel.data!;
          final combinedTimeline = getCombinedTimeline(
            complaint.statusUpdates ?? [],
            complaint.comments ?? [],
          );
          return SingleChildScrollView(
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        complaint.title ?? 'No Title',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: containerColor,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Status and Priority Badges
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: getStatusColor(complaint.status)
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: getStatusColor(complaint.status),
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: getStatusColor(complaint.status),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  formatApiString(complaint.status),
                                  style: TextStyle(
                                    color: getStatusColor(complaint.status),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: getPriorityColor(complaint.priority)
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: getPriorityColor(complaint.priority),
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.flag,
                                  size: 14,
                                  color: getPriorityColor(complaint.priority),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  formatApiString(complaint.priority),
                                  style: TextStyle(
                                    color: getPriorityColor(complaint.priority),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Assigned To
                      if (complaint.teamLead != null)
                        _buildInfoRow(
                          Icons.person_outline,
                          "Assigned To",
                          "${complaint.teamLead!.firstName!} ${complaint.teamLead!.lastName!}",
                        ),
                      // Description
                      if (complaint.description?.isNotEmpty == true) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: searchBackgroundColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: dividerColor,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.description,
                                    size: 18,
                                    color: buttonColor,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Description",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: containerColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                complaint.description!,
                                style: TextStyle(
                                  color: containerColor,
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                // Client Details Section
                if (userDetailModel!.data!.role != "CLIENT") ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                    child: sectionTitle("Client Information"),
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
                            offset: const Offset(0, 2),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Column(
                        children: _buildDetailItemsWithDividers([
                          if (complaint.clientData!.clientName != null)
                            _buildDetailRow(
                              Icons.business,
                              "Client Name",
                              complaint.clientData!.clientName ?? "N/A",
                            ),
                          if (complaint.clientData!.clientAddress != null)
                            _buildDetailRow(
                              Icons.location_city,
                              "Address",
                              complaint.clientData!.clientAddress ?? "N/A",
                            ),
                          if (complaint.clientData!.clientEmail != null)
                            _buildDetailRow(
                              Icons.email,
                              "Email",
                              complaint.clientData!.clientEmail ?? "N/A",
                            ),
                          if (complaint.clientData!.phone != null)
                            _buildDetailRow(
                              Icons.phone,
                              "Phone",
                              complaint.clientData!.phone ?? "N/A",
                            ),
                          if (complaint.clientData!.contactPerson != null)
                            _buildDetailRow(
                              Icons.person,
                              "Contact Person",
                              complaint.clientData!.contactPerson ?? "N/A",
                            ),
                        ]),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                // Equipment Details Section
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                  child: sectionTitle("Equipment Information"),
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
                          offset: const Offset(0, 2),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Column(
                      children: _buildDetailItemsWithDividers([
                        if (complaint.equipment != null)
                          _buildDetailRow(
                            Icons.precision_manufacturing,
                            "Equipment Name",
                            complaint.equipment?.name ?? "N/A",
                          ),
                        if (complaint.equipment?.supervisor != null) ...[
                          _buildDetailRow(
                            Icons.person,
                            "Supervisor Name",
                            "${complaint.equipment!.supervisor!.firstName ?? ''} ${complaint.equipment!.supervisor!.lastName ?? ''}"
                                    .trim()
                                    .isEmpty
                                ? "N/A"
                                : "${complaint.equipment!.supervisor!.firstName ?? ''} ${complaint.equipment!.supervisor!.lastName ?? ''}"
                                    .trim(),
                          ),
                          if (complaint.equipment!.supervisor!.phone != null)
                            _buildDetailRow(
                              Icons.phone,
                              "Supervisor Phone",
                              complaint.equipment!.supervisor!.phone ?? "N/A",
                            ),
                          if (complaint.equipment!.supervisor!.email != null)
                            _buildDetailRow(
                              Icons.email,
                              "Supervisor Email",
                              complaint.equipment!.supervisor!.email ?? "N/A",
                            ),
                        ],
                        _buildDetailRow(
                          Icons.calendar_today,
                          "Reported At",
                          formatDate(complaint.reportedAt),
                        ),
                        _buildDetailRow(
                          Icons.access_time,
                          "Created At",
                          formatDate(complaint.createdAt),
                        ),
                      ]),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Action Buttons Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      if (userDetailModel!.data!.role == "WORKER") ...[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: sectionTitle("Parts Request"),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Get.dialog(PartRequestDialog(
                                complaintId: complaint.id!,
                              ));
                            },
                            icon: const Icon(Icons.build, size: 20),
                            label: const Text("Parts Request"),
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
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              await complaintController.getRequestedPartsList();
                              Get.toNamed('/requestedPartWorker');
                            },
                            icon: const Icon(Icons.list, size: 20),
                            label: const Text("View Requested Parts"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: containerColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                          ),
                        ),
                      ],
                      if (userDetailModel!.data!.role != "WORKER") ...[
                        // Comment Input Section
                        Container(
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
                                offset: const Offset(0, 2),
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.add_comment_outlined,
                                    color: buttonColor,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Add Comment",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: containerColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: commentController,
                                maxLines: 4,
                                decoration: InputDecoration(
                                  hintText: "Type your comment here...",
                                  hintStyle: TextStyle(
                                    color: subtitleColor,
                                    fontSize: 14,
                                  ),
                                  filled: true,
                                  fillColor: searchBackgroundColor,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: dividerColor,
                                      width: 1,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: dividerColor,
                                      width: 1,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: buttonColor,
                                      width: 2,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                ),
                                style: TextStyle(
                                  color: containerColor,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Obx(
                                () => SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: complaintController
                                            .isLoading2.value
                                        ? null
                                        : () async {
                                            if (commentController.text
                                                .trim()
                                                .isEmpty) {
                                              Get.snackbar(
                                                "Error",
                                                "Please enter a comment",
                                                backgroundColor:
                                                    notWorkingTextColor,
                                                colorText: backgroundColor,
                                                snackPosition:
                                                    SnackPosition.BOTTOM,
                                              );
                                              return;
                                            }

                                            await complaintController
                                                .updateComplaintComment(
                                              userDetailModel!.data!.role!
                                                  .toLowerCase(),
                                              complaint.id!,
                                              commentController.text.trim(),
                                            );

                                            // Refresh complaint details
                                            await complaintController
                                                .fetchComplaintDetails(
                                              complaint.id!,
                                              userDetailModel!.data!.role!
                                                  .toLowerCase(),
                                            );

                                            // Clear the text field
                                            commentController.clear();

                                            Get.snackbar(
                                              "Success",
                                              "Comment added successfully",
                                              backgroundColor: workingTextColor,
                                              colorText: backgroundColor,
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                            );
                                          },
                                    icon: complaintController.isLoading2.value
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                            ),
                                          )
                                        : const Icon(Icons.send_rounded,
                                            size: 20),
                                    label: Text(
                                      complaintController.isLoading2.value
                                          ? "Adding..."
                                          : "Add Comment",
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: workingTextColor,
                                      foregroundColor: backgroundColor,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      if (userDetailModel!.data!.role != "CLIENT") ...[
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Get.dialog(StatusUpdateDialog(
                                complaintId: widget.complaintId,
                              ));
                            },
                            icon: const Icon(Icons.update, size: 20),
                            label: const Text("Update Status"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: buttonColor,
                              foregroundColor: backgroundColor,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                          ),
                        ),
                      ],
                      if (userDetailModel!.data!.role == "CLIENT" &&
                          complaint.status == "Closed") ...[
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Get.dialog(StatusUpdateDialog(
                              //   complaintId: complaintId,
                              // ));
                            },
                            icon: const Icon(Icons.feedback, size: 20),
                            label: const Text("Feedback"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: buttonColor,
                              foregroundColor: backgroundColor,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                // Timeline Section
                if (combinedTimeline.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                    child: sectionTitle("Timeline"),
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
                            offset: const Offset(0, 2),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: ComplaintTimelineWidget(
                        entries: combinedTimeline,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                // Assign Worker Section
                if (userDetailModel!.data!.role == "ADMIN" ||
                    complaint.equipment?.supervisor?.id ==
                        userDetailModel!.data!.id)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          final isUpdating =
                              complaint.assignedWorkers!.isNotEmpty;
                          Get.toNamed('/assignWork', arguments: {
                            'complaintId': widget.complaintId,
                            'isUpdating': isUpdating,
                          });
                        },
                        icon: Icon(
                          complaint.assignedWorkers!.isEmpty
                              ? Icons.person_add
                              : Icons.person_outline,
                          size: 20,
                        ),
                        label: Text(
                          complaint.assignedWorkers!.isEmpty
                              ? "Assign Complaint"
                              : "Update Worker",
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: containerColor,
                          foregroundColor: backgroundColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget sectionTitle(String title) {
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

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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

  List<Widget> _buildDetailItemsWithDividers(List<Widget> items) {
    if (items.isEmpty) return [];
    if (items.length == 1) return items;

    final List<Widget> result = [];
    for (int i = 0; i < items.length; i++) {
      result.add(items[i]);
      if (i < items.length - 1) {
        result.add(SizedBox(
          height: 24,
        ));
      }
    }
    return result;
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: subtitleColor),
        const SizedBox(width: 8),
        Text(
          "$label: ",
          style: TextStyle(
            color: subtitleColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: containerColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
