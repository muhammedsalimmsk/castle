import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Colors/Colors.dart';
import '../../../Controlls/AuthController/AuthController.dart';
import '../../../Controlls/ComplaintController/ComplaintController.dart';

class AddCommentDialog extends StatelessWidget {
  final String complaintId;
  final ComplaintController controller = Get.find();

  AddCommentDialog({super.key, required this.complaintId});

  @override
  Widget build(BuildContext context) {
    final TextEditingController commentController = TextEditingController();

    return Dialog(
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Add Comment",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: commentController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: "Comment",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Obx(() => controller.isLoading2.value
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          if (commentController.text.trim().isEmpty) {
                            Get.snackbar("Error", "Please enter a comment");
                            return;
                          }

                          Get.back(); // Close dialog
                          await controller.updateComplaintComment(
                            userDetailModel!.data!.role!.toLowerCase(),
                            complaintId,
                            commentController.text.trim(),
                          );
                          controller.fetchComplaintDetails(complaintId,
                              userDetailModel!.data!.role!.toLowerCase());
                          Get.snackbar("Success", "Comment added");
                        },
                        child: const Text("Submit"),
                      ),
                    )),
            ],
          ),
        ),
      ),
    );
  }
}
