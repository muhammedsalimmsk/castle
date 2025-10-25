import 'package:castle/Screens/PartsRequestPagee/RequestedPartsDetailPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:castle/Controlls/ClientPartsController/ClientPartsController.dart';
import 'package:castle/Widget/CustomAppBarWidget.dart';
import 'package:castle/Widget/CustomDrawer.dart';
import 'package:castle/Colors/Colors.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // Use Obx to listen to changes in your observable variables
        child: Obx(
          () => Column(
            children: [
              // 🔽 Status Filter
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Requested Parts",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  DropdownButton<String>(
                    dropdownColor: backgroundColor,
                    value: controller.selectedStatus.value, // Use .value
                    underline: const SizedBox(),
                    borderRadius: BorderRadius.circular(10),
                    onChanged: (value) {
                      if (value != null) {
                        // Just update the controller, the UI will react automatically
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
                ],
              ),
              const SizedBox(height: 8),

              // 📋 Parts List
              Expanded(
                child: controller.isLoading.value &&
                        controller.partsList.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : controller.partsList.isEmpty
                        ? const Center(child: Text("No parts found."))
                        : RefreshIndicator(
                            onRefresh: () => controller.getRequestedParts(
                                userDetailModel!.data!.role!.toLowerCase(),
                                reset: true),
                            child: ListView.separated(
                              separatorBuilder: (context, index) => Divider(),
                              itemCount: controller.partsList.length,
                              itemBuilder: (context, index) {
                                final part = controller.partsList[index];
                                return ListTile(
                                  title: Text(part.part!.partName ?? 'No Name'),
                                  subtitle: Text("Status: ${part.status}"),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (part.status == "PENDING") ...[
                                        IconButton(
                                          icon: const Icon(Icons.check,
                                              color: buttonColor),
                                          onPressed: () => _showNoteDialog(
                                              part.id!, "APPROVED"),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.close,
                                              color: containerColor),
                                          onPressed: () => _showNoteDialog(
                                              part.id!, "REJECTED"),
                                        ),
                                      ],
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
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
