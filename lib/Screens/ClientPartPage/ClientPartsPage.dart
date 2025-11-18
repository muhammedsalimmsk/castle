import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:castle/Controlls/ClientPartsController/ClientPartsController.dart';
import 'package:castle/Widget/CustomAppBarWidget.dart';
import 'package:castle/Widget/CustomDrawer.dart';
import 'package:castle/Colors/Colors.dart';
import 'package:castle/Utils/ResponsiveHelper.dart';
import '../../Controlls/AuthController/AuthController.dart';

class RequestedPartsListPage extends StatefulWidget {
  const RequestedPartsListPage({super.key});

  @override
  State<RequestedPartsListPage> createState() => _RequestedPartsPageState();
}

class _RequestedPartsPageState extends State<RequestedPartsListPage> {
  final ClientPartsController controller = Get.put(ClientPartsController());

  @override
  void initState() {
    super.initState();
    // Initial fetch
    controller.getRequestedParts(userDetailModel!.data!.role!.toLowerCase(),
        reset: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
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
                    "Requested Parts",
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
                        "${controller.partsList.length} Parts",
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
            // Search Bar with Status Filter
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
                        decoration: InputDecoration(
                          hintText: "Search requested parts...",
                          hintStyle: TextStyle(
                            color: subtitleColor,
                            fontSize: 14,
                          ),
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: buttonColor,
                            size: 22,
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
                        dropdownColor: backgroundColor,
                        value: controller.selectedStatus.value,
                        underline: const SizedBox(),
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: buttonColor,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        style: TextStyle(
                          color: containerColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        onChanged: (value) {
                          if (value != null) {
                            controller.selectedStatus.value = value;
                            controller.getRequestedParts(
                                userDetailModel!.data!.role!.toLowerCase(),
                                reset: true);
                          }
                        },
                        items: [
                          'PENDING',
                          'APPROVED',
                          'REJECTED',
                          'COLLECTED',
                          'DELIVERED'
                        ]
                            .map((status) => DropdownMenuItem(
                                  value: status,
                                  child: Text(status),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Parts List
            Expanded(
              child: Obx(
                () => controller.isLoading.value &&
                        controller.partsList.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(buttonColor),
                              strokeWidth: 3,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Loading requested parts...",
                              style: TextStyle(
                                color: subtitleColor,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )
                    : controller.partsList.isEmpty
                        ? RefreshIndicator(
                            onRefresh: () => controller.getRequestedParts(
                                userDetailModel!.data!.role!.toLowerCase(),
                                reset: true),
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
                                          Icons.inventory_2_outlined,
                                          size: 64,
                                          color: subtitleColor,
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      Text(
                                        "No parts found",
                                        style: TextStyle(
                                          color: containerColor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Try adjusting your filters",
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
                          )
                        : ResponsiveHelper.isLargeScreen(context)
                            ? RefreshIndicator(
                                onRefresh: () => controller.getRequestedParts(
                                    userDetailModel!.data!.role!.toLowerCase(),
                                    reset: true),
                                color: buttonColor,
                                child: GridView.builder(
                                  padding: ResponsiveHelper.getResponsivePadding(context).copyWith(
                                    top: 0,
                                  ),
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: ResponsiveHelper.getGridCrossAxisCount(context),
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 12,
                                    childAspectRatio: ResponsiveHelper.isDesktop(context) ? 1.3 : 1.2,
                                  ),
                                  itemCount: controller.partsList.length,
                                  itemBuilder: (context, index) {
                                    final part = controller.partsList[index];
                                    return _buildPartCard(part);
                                  },
                                ),
                              )
                            : RefreshIndicator(
                                onRefresh: () => controller.getRequestedParts(
                                    userDetailModel!.data!.role!.toLowerCase(),
                                    reset: true),
                                color: buttonColor,
                                child: ListView.builder(
                                  padding: ResponsiveHelper.getResponsivePadding(context).copyWith(
                                    top: 0,
                                  ),
                                  itemCount: controller.partsList.length,
                                  itemBuilder: (context, index) {
                                    final part = controller.partsList[index];
                                    return _buildPartCard(part);
                                  },
                                ),
                              ),
              ),
            ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPartCard(dynamic part) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Navigate to details if needed
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
                    Icons.inventory_2_rounded,
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
                        part.part?.partName ?? 'No Name',
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
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(part.status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "Status: ${part.status}",
                          style: TextStyle(
                            color: _getStatusColor(part.status),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Actions
                if (part.status == "PENDING")
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.green.shade200,
                            width: 1,
                          ),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.check, size: 18),
                          color: Colors.green.shade700,
                          onPressed: () => _showNoteDialog(part.id!, "APPROVED"),
                          padding: const EdgeInsets.all(8),
                          constraints: const BoxConstraints(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.red.shade200,
                            width: 1,
                          ),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          color: Colors.red.shade700,
                          onPressed: () => _showNoteDialog(part.id!, "REJECTED"),
                          padding: const EdgeInsets.all(8),
                          constraints: const BoxConstraints(),
                        ),
                      ),
                    ],
                  )
                else
                  Icon(
                    Icons.chevron_right,
                    color: subtitleColor,
                    size: 18,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case "APPROVED":
        return Colors.green;
      case "PENDING":
        return Colors.orange;
      case "REJECTED":
        return Colors.red;
      case "COLLECTED":
        return Colors.blue;
      case "DELIVERED":
        return Colors.teal;
      default:
        return containerColor;
    }
  }

  // ✅ This method is now much cleaner
  void _showNoteDialog(String partId, String status) {
    final TextEditingController noteController = TextEditingController();

    Get.dialog(
      AlertDialog(
        backgroundColor: backgroundColor,
        // ... dialog styling
        title: Text("Note"),
        content: TextField(
          controller: noteController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: "Enter note...",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Get.back(),
          ),
          ElevatedButton(
            // ... button styling
            child: Text(status == "APPROVED" ? "Accept" : "Reject"),
            onPressed: () async {
              final note = noteController.text.trim();
              if (note.isEmpty) {
                Get.snackbar("Note Required", "Please enter a note.");
                return;
              }
              Get.back(); // close dialog

              // Call the controller function. NO setState NEEDED!
              // The controller will handle the API call and update its own state,
              // which will automatically update the UI via Obx.
              await controller.updateParts(partId, status, note,
                  userDetailModel!.data!.role!.toLowerCase());

              Get.snackbar("Success", "Part $status successfully!",
                  backgroundColor: Colors.green, colorText: Colors.white);
            },
          ),
        ],
      ),
    );
  }
}
