import 'package:castle/Colors/Colors.dart';
import 'package:castle/Controlls/ClientController/ClientController.dart';
import 'package:castle/Controlls/WorkersController/WorkerController.dart';
import 'package:castle/Model/login_details_model/data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:intl/intl.dart';

class LoginDetailsPage extends StatelessWidget {
  final String userId;
  final String? userName;
  final bool isClient;

  LoginDetailsPage({
    super.key,
    required this.userId,
    this.userName,
    this.isClient = true,
  });

  @override
  Widget build(BuildContext context) {
    final clientController = Get.put(ClientRegisterController());
    final workerController = Get.put(WorkerController());

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
          "Login Details",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: containerColor,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<LoginDetailsData?>(
        future: isClient
            ? clientController.getLoginDetails(userId)
            : workerController.getLoginDetails(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Unable to load login details",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Go Back"),
                  ),
                ],
              ),
            );
          }

          final loginData = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Card
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
                        radius: 30,
                        backgroundColor: buttonColor.withOpacity(0.1),
                        child: Icon(
                          LucideIcons.user,
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
                              userName ?? loginData.user?.name ?? "User",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (loginData.user?.email != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                loginData.user!.email!,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                            if (loginData.user?.role != null) ...[
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: buttonColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  loginData.user!.role!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: buttonColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Login Information Section
                const Text(
                  "Login Information",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),

                if (loginData.lastLogin != null)
                  _infoTile(
                    LucideIcons.logIn,
                    "Last Login",
                    DateFormat('dd MMM yyyy, hh:mm a').format(loginData.lastLogin!),
                  ),
                if (loginData.firstLogin != null)
                  _infoTile(
                    LucideIcons.calendar,
                    "First Login",
                    DateFormat('dd MMM yyyy, hh:mm a').format(loginData.firstLogin!),
                  ),
                if (loginData.timezone != null)
                  _infoTile(
                    LucideIcons.globe,
                    "Timezone",
                    loginData.timezone ?? "-",
                  ),
                if (loginData.language != null)
                  _infoTile(
                    LucideIcons.languages,
                    "Language",
                    loginData.language?.toUpperCase() ?? "-",
                  ),
                if (loginData.country != null)
                  _infoTile(
                    LucideIcons.mapPin,
                    "Country",
                    loginData.country ?? "-",
                  ),

                const SizedBox(height: 30),

                // Devices Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Devices",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: buttonColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "${loginData.totalDevices ?? loginData.devices?.length ?? 0} Devices",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: buttonColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                if (loginData.devices != null && loginData.devices!.isNotEmpty)
                  ...loginData.devices!.map((device) => _deviceCard(device))
                else
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.withOpacity(0.2)),
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            LucideIcons.smartphone,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "No devices found",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
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

  Widget _infoTile(IconData icon, String title, String value) {
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
                  value,
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

  Widget _deviceCard(device) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: buttonColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  device.deviceType == 'AndroidPush'
                      ? LucideIcons.smartphone
                      : LucideIcons.mail,
                  color: buttonColor,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      device.deviceType ?? "Unknown",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (device.deviceModel != null)
                      Text(
                        device.deviceModel!,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                  ],
                ),
              ),
              if (device.enabled == true)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Enabled",
                    style: TextStyle(
                      color: Colors.green[700],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _deviceInfo("OS", device.deviceOS ?? "-"),
              ),
              Expanded(
                child: _deviceInfo("App Version", device.appVersion ?? "-"),
              ),
              Expanded(
                child: _deviceInfo(
                    "Sessions", device.sessionCount?.toString() ?? "0"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _deviceInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

