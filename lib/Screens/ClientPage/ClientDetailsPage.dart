import 'package:castle/Colors/Colors.dart';
import 'package:castle/Screens/ClientPage/ClientRegisterPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:castle/Controlls/ClientController/ClientController.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ClientDetailPage extends StatelessWidget {
  final String clientId;
  ClientDetailPage({super.key, required this.clientId});
  final controller = Get.put(ClientRegisterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        surfaceTintColor: backgroundColor,
        elevation: 0,
        title: Text(
          "Client Details",
          style: TextStyle(
            color: buttonColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                controller.fillClientData(controller.clientDetails);
                Get.to(ClientRegisterOne());
              },
              icon: Icon(Icons.edit))
        ],
        centerTitle: true,
        iconTheme: const IconThemeData(color: buttonColor),
      ),
      body: FutureBuilder(
        future: controller.getClientById(clientId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("No Client Data Found"));
          }

          final client = snapshot.data;

          // Count equipment and complaints safely
          final equipmentCount = client?.equipment?.length ?? 0;
          final complaintCount = client?.createdComplaints?.length ?? 0;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER CARD
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: buttonColor.withOpacity(0.1),
                        child: Icon(
                          LucideIcons.building2,
                          color: buttonColor,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              client!.clientName ?? "Unknown Client",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              client.contactPerson ?? "No contact person",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // DETAILS SECTION
                const Text(
                  "Client Information",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),

                _infoTile(LucideIcons.mail, "Email", client.clientEmail),
                _infoTile(LucideIcons.phone, "Phone", client.phone?.toString()),
                _infoTile(LucideIcons.mapPin, "Address", client.clientAddress),
                _infoTile(
                    LucideIcons.user, "Contact Person", client.contactPerson),
                _infoTile(
                    LucideIcons.calendar,
                    "Created At",
                    client.createdAt != null
                        ? client.createdAt.toString().split(' ')[0]
                        : "-"),

                const SizedBox(height: 30),

                // ACTIVE STATUS
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: client.isActive == true
                        ? buttonColor.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: client.isActive == true
                            ? buttonColor
                            : Colors.grey),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        client.isActive == true
                            ? LucideIcons.circleCheck
                            : LucideIcons.circleX,
                        color:
                            client.isActive == true ? buttonColor : Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        client.isActive == true ? "Active Client" : "Inactive",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: client.isActive == true
                              ? buttonColor
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // STATS SECTION
                const Text(
                  "Client Statistics",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: _statCard(
                        icon: LucideIcons.toolCase,
                        title: "Equipments",
                        value: equipmentCount.toString(),
                        color: buttonColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _statCard(
                        icon: LucideIcons.circleAlert,
                        title: "Complaints",
                        value: complaintCount.toString(),
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _infoTile(IconData icon, String title, String? value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: buttonColor, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value ?? "-",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
