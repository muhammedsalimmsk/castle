import 'package:castle/Colors/Colors.dart';
import 'package:castle/Controlls/AuthController/AuthController.dart';
import 'package:castle/Controlls/PartsController/PartsController.dart';
import 'package:castle/Screens/PartsRequestPagee/RequestedPartsDetailPage.dart';
import 'package:castle/Widget/CustomAppBarWidget.dart';
import 'package:castle/Widget/CustomDrawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RequestedPartsPage extends StatelessWidget {
  RequestedPartsPage({super.key});

  final PartsController controller = Get.put(PartsController());

  @override
  Widget build(BuildContext context) {
    String role = userDetailModel!.data!.role!.toLowerCase();
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Requested Parts",
              style: TextStyle(
                  color: containerColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: FutureBuilder(
                future: controller.getRequestedList(role),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return RefreshIndicator(
                      onRefresh: () async {
                        controller.currentPage = 1;
                        controller.hasMore2 = true;
                        controller.isRefresh = true;
                        await controller.getRequestedList(role);
                        controller.isRefresh = false;

                        await controller.getRequestedList(role);
                      },
                      child: controller.requestedParts.isEmpty
                          ? SingleChildScrollView(
                              physics:
                                  const AlwaysScrollableScrollPhysics(), // Important!
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.7,
                                child: Center(
                                  child: Text(
                                    "No requested parts found.\nPull to refresh.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: containerColor, fontSize: 14),
                                  ),
                                ),
                              ),
                            )
                          : Obx(
                              () => ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: controller.requestedParts.length,
                                itemBuilder: (context, index) {
                                  final data = controller.requestedParts[index];
                                  print(controller.requestedParts.length);
                                  print(data.status);
                                  return Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: shadeColor),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              containerColor.withOpacity(0.1),
                                          offset: Offset(0, 4),
                                          blurRadius: 6,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        data.worker?.firstName ?? "-",
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                      subtitle: Text(
                                        data.part?.partName ?? "-",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      trailing: Text(
                                        data.status ?? "-",
                                        style: TextStyle(
                                          color: _statusColor(data.status),
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      onTap: () {
                                        // Navigate to details here
                                        Get.to(() => RequestedPartDetailPage(
                                            partData: data));
                                      },
                                    ),
                                  );
                                },
                              ),
                            ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String? status) {
    switch (status) {
      case "APPROVED":
        return Colors.green;
      case "PENDING":
        return Colors.orange;
      case "REJECTED":
        return Colors.red;
      default:
        return Colors.black;
    }
  }
}
