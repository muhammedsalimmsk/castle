import 'package:castle/Colors/Colors.dart';
import 'package:castle/Controlls/ClientController/ClientController.dart';
import 'package:castle/Model/client_model/datum.dart';
import 'package:castle/Screens/ClientPage/ClientDetailsPage.dart';
import 'package:castle/Screens/ClientPage/ClientRegisterPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Widget/CustomAppBarWidget.dart';
import '../../Widget/CustomDrawer.dart';
import '../../Utils/ResponsiveHelper.dart';

class ClientPage extends StatelessWidget {
  ClientPage({super.key});
  final ClientRegisterController controller = Get.put(ClientRegisterController());

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
                    "Clients",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: containerColor,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: buttonColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: buttonColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Obx(
                      () => Text(
                        "${controller.clientData.length} Clients",
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
                    hintText: "Search clients...",
                    hintStyle: TextStyle(
                      color: subtitleColor,
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: buttonColor,
                      size: 22,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.filter_list_rounded,
                        color: buttonColor,
                        size: 22,
                      ),
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
            // Clients List
            Expanded(
              child: Obx(
                    () => controller.isLoading.value
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
                                  "Loading clients...",
                                  style: TextStyle(
                                    color: subtitleColor,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : controller.clientData.isEmpty
                            ? RefreshIndicator(
                                onRefresh: () async {
                                  await controller.getClientList();
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
                                              Icons.business_outlined,
                                              size: 64,
                                              color: subtitleColor,
                                            ),
                                          ),
                                          const SizedBox(height: 24),
                                          Text(
                                            "No clients found",
                                            style: TextStyle(
                                              color: containerColor,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            "Add new clients to get started",
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
                                    onRefresh: () async {
                                      await controller.getClientList();
                                    },
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
                                      itemCount: controller.clientData.length,
                                      itemBuilder: (context, index) {
                                        final ClientData client = controller.clientData[index];
                                        return _buildClientCard(client);
                                      },
                                    ),
                                  )
                                : RefreshIndicator(
                                    onRefresh: () async {
                                      await controller.getClientList();
                                    },
                                    color: buttonColor,
                                    child: ListView.builder(
                                      padding: ResponsiveHelper.getResponsivePadding(context).copyWith(
                                        top: 0,
                                      ),
                                      itemCount: controller.clientData.length,
                                      itemBuilder: (context, index) {
                                        final ClientData client = controller.clientData[index];
                                        return _buildClientCard(client);
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
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              buttonColor,
              buttonColor.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: buttonColor.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          backgroundColor: Colors.transparent,
          elevation: 0,
          onPressed: () {
            controller.clearAllControllers();
            Get.to(ClientRegisterOne());
          },
          icon: const Icon(Icons.add, color: backgroundColor),
          label: Text(
            "New Client",
            style: TextStyle(
              color: backgroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildClientCard(ClientData client) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Get.to(() => ClientDetailPage(clientId: client.id!));
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
                    Icons.business_rounded,
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
                        client.clientName ?? 'Unknown Client',
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
                      if (client.firstName != null || client.lastName != null)
                        Row(
                          children: [
                            Icon(Icons.person_outline, size: 14, color: subtitleColor),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                "${client.firstName ?? ''} ${client.lastName ?? ''}".trim(),
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
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          if (client.clientPhone != null)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.phone, size: 14, color: subtitleColor),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    client.clientPhone!,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: subtitleColor,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          if (client.count != null) ...[
                            if (client.count!.equipment != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: buttonColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.precision_manufacturing, size: 12, color: buttonColor),
                                    const SizedBox(width: 4),
                                    Text(
                                      "${client.count!.equipment} Equipment",
                                      style: TextStyle(
                                        color: buttonColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (client.count!.createdComplaints != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.report_problem, size: 12, color: Colors.orange),
                                    const SizedBox(width: 4),
                                    Text(
                                      "${client.count!.createdComplaints} Complaints",
                                      style: TextStyle(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: client.isActive == true
                            ? workingWidgetColor
                            : notWorkingWidgetColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              color: client.isActive == true
                                  ? workingTextColor
                                  : notWorkingTextColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            client.isActive == true ? "Active" : "Inactive",
                            style: TextStyle(
                              color: client.isActive == true
                                  ? workingTextColor
                                  : notWorkingTextColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    IconButton(
                      onPressed: () async {
                        Get.defaultDialog(
                          backgroundColor: backgroundColor,
                          title: "Delete Client",
                          titleStyle: TextStyle(
                            color: containerColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          middleText: "Are you sure you want to delete this client?",
                          middleTextStyle: TextStyle(
                            color: subtitleColor,
                            fontSize: 14,
                          ),
                          contentPadding: const EdgeInsets.all(20),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Get.back();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: searchBackgroundColor,
                                foregroundColor: containerColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                              ),
                              child: const Text("Cancel"),
                            ),
                            const SizedBox(width: 12),
                            Obx(
                              () => controller.isLoading.value
                                  ? const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: CircularProgressIndicator(),
                                    )
                                  : ElevatedButton(
                                      onPressed: () async {
                                        await controller.deleteClient(client.id!);
                                        Get.back();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: notWorkingTextColor,
                                        foregroundColor: backgroundColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 12,
                                        ),
                                      ),
                                      child: const Text("Delete"),
                                    ),
                            )
                          ],
                        );
                      },
                      icon: Icon(
                        Icons.delete_outline,
                        color: notWorkingTextColor,
                        size: 20,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(height: 4),
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
