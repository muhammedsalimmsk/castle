import 'package:castle/Colors/Colors.dart';
import 'package:castle/Controlls/AuthController/AuthController.dart';
import 'package:castle/Controlls/EquipmentController/EquipmentController.dart';
import 'package:castle/Model/complaint_detail_model/complaint_detail_model.dart';
import 'package:castle/Screens/ComplaintsPage/ComplaintDetailsPage.dart';
import 'package:castle/Widget/CustomAppBarWidget.dart';
import 'package:castle/Widget/CustomDrawer.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Controlls/DashboardController/DashboardController.dart';
import 'Widgets/ActivityChart.dart'; // Assuming you might use this later
import 'Widgets/ComplaintWidget.dart';
import 'Widgets/TopWidget.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final DashboardController dashboardController =
      Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (dashboardController.isLoading.value) {
        return Scaffold(
          appBar: CustomAppBar(),
          body: const Center(child: CircularProgressIndicator()),
        );
      }

      final data = dashboardController.dashboardData.value;
      final clients = data.clientStats;
      // Assuming your data model has these fields (adjust if needed)
      final totalWorkers = data.overview?.workers?.total.toString() ?? "N/A";
      final totalClients = data.overview?.clients?.total.toString() ?? "N/A";
      final totalEquipments =
          data.overview?.equipment?.total.toString() ?? "N/A";
print(token);
      return Scaffold(
        drawer: CustomDrawer(),
        appBar: CustomAppBar(),
        body: SingleChildScrollView(
          // Added SingleChildScrollView for overall scrollability
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Increased padding a bit
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align text to start
              children: [
                TopWidgetOfHomePage(data: data),
                const SizedBox(height: 20), // Increased spacing

                // --- New Stats Section ---
                _buildStatsSection(
                  totalWorkers: totalWorkers,
                  totalClients: totalClients,
                  totalEquipments: totalEquipments,
                ),
                const SizedBox(height: 20), // Increased spacing

                // --- Recent Complaints Section ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Recent Complaints",
                      style: TextStyle(
                          fontSize: 18, // Slightly larger
                          fontWeight: FontWeight.bold,
                          color: Colors.black87), // Darker text
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => {}, // implement if needed
                          icon: Icon(Icons.arrow_back_ios,
                              size: 18, color: Colors.blue.shade700),
                        ),
                        IconButton(
                          onPressed: () => {}, // implement if needed
                          icon: Icon(Icons.arrow_forward_ios,
                              size: 18, color: Colors.blue.shade700),
                        ),
                      ],
                    ),
                  ],
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      data.recentComplaints?.length ?? 0,
                      (index) {
                        final complaint = data.recentComplaints![index];
                        return Padding(
                          // Added padding around complaint widgets
                          padding: const EdgeInsets.only(right: 12.0),
                          child: GestureDetector(
                            onTap: (){

                              Get.to(ComplaintDetailsPage(complaintId: complaint.id!,));
                            },
                            child: ComplaintWidget(
                              location: complaint.client!.clientName ?? "N/A",
                              date: DateFormat('MMM dd, yyyy')
                                  .format(complaint.createdAt!),
                              title: complaint.title ?? "N/A",
                              paragraph: complaint.description ?? "",
                              subtitle: complaint.teamLead?.lastName ?? "N/A",
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // --- Client Stats Section ---
                const SizedBox(height: 25),
                Text(
                  "Clients",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      clients?.length ?? 0,
                      (index) {
                        final client = clients![index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 6.0),
                          child: _buildClientCard(
                            name: client.clientName ?? "Unknown",
                            equipment: client.equipment?.total.toString() ??
                                "No Equipment",
                            complaints:
                                client.complaints?.inProgress?.toString() ??
                                    "0",
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildClientCard({
    required String name,
    required String equipment,
    required String complaints,
  }) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.blue.shade100,
                child: Icon(Icons.business, color: Colors.blue.shade700),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.build, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  equipment,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.folder, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                "$complaints Complaints",
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- Helper Widget for Stats Section ---
  Widget _buildStatsSection({
    required String totalWorkers,
    required String totalClients,
    required String totalEquipments,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Overview",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade800, // Blue heading
          ),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStatCard(
              icon: Icons.people_outline,
              label: "Total Workers",
              value: totalWorkers,
            ),
            const SizedBox(width: 12), // Spacing between cards
            _buildStatCard(
              icon: Icons.business_center_outlined,
              label: "Total Clients",
              value: totalClients,
              // Different color for variety
            ),
            const SizedBox(width: 12), // Spacing between cards
            _buildStatCard(
              icon: Icons.build_circle_outlined,
              label: "Total Equipment",
              value: totalEquipments,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      // Ensures cards take available space and wrap if needed on smaller screens
      child: Card(
        elevation: 4.0, // Adds a subtle shadow
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), // Rounded corners
        ),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0), color: buttonColor),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: backgroundColor),
              const SizedBox(height: 10),
              Text(
                value,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: containerColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: backgroundColor,
                ),
                textAlign: TextAlign.center,
                maxLines: 2, // Allow label to wrap if long
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
