import 'package:castle/Controlls/AuthController/AuthController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Colors/Colors.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({super.key});

  // Define RxBool variables for menu items
  final RxBool overviewSelected = false.obs;
  final RxBool equipmentSelected = false.obs;
  final RxBool complaintsSelected = false.obs;
  final RxBool routineSelected = false.obs;
  final RxBool clientsSelected = false.obs;
  final RxBool workersSelected = false.obs;
  final RxBool partsListSelected = false.obs;
  final RxBool requestedPartsSelected = false.obs;

  void resetSelection() {
    overviewSelected.value = false;
    equipmentSelected.value = false;
    complaintsSelected.value = false;
    routineSelected.value = false;
    clientsSelected.value = false;
    workersSelected.value = false;
    partsListSelected.value = false;
    requestedPartsSelected.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: backgroundColor,
      child: SafeArea(
        child: Column(
          children: [
            // Drawer Header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    color: buttonColor,
                    'assets/images/book-square.png',
                    width: 35,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Nuegas",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),

            // Drawer Menu Items
            Expanded(
              child: ListView(
                children: [
                  // Overview
                  Obx(() => DrawerListTile(
                        title: "Overview",
                        iconWidget: Image.asset(
                          'assets/icons/category-2.png',
                          width: 24,
                          height: 24,
                        ),
                        iSSelected: overviewSelected.value,
                        onTap: () {
                          resetSelection();
                          overviewSelected.value = true;

                          if (userDetailModel!.data!.role == "ADMIN") {
                            Get.offAllNamed('/home');
                          } else if (userDetailModel!.data!.role == "WORKER") {
                            Get.offAllNamed('/workerHome');
                          } else {
                            Get.offAllNamed('/clientHome');
                          }
                        },
                      )),

                  // Equipment
                  if (userDetailModel!.data!.role != "WORKER")
                    Obx(() => DrawerListTile(
                          title: "Equipment",
                          iconWidget: Image.asset(
                            color: buttonColor,
                            'assets/icons/equipment.png',
                            width: 24,
                            height: 24,
                          ),
                          iSSelected: equipmentSelected.value,
                          onTap: () {
                            resetSelection();
                            equipmentSelected.value = true;
                            Get.toNamed('/equipment');
                          },
                        )),

                  // Complaints
                  Obx(() => DrawerListTile(
                        title: "Complaints",
                        iconWidget: Image.asset(
                          color: buttonColor,
                          'assets/icons/book.png',
                          width: 24,
                          height: 24,
                        ),
                        iSSelected: complaintsSelected.value,
                        onTap: () {
                          resetSelection();
                          complaintsSelected.value = true;
                          Navigator.pop(context);
                          Get.toNamed('/complaints');
                        },
                      )),

                  // Routine
                  if (userDetailModel!.data!.role == "ADMIN")
                    Obx(() => DrawerListTile(
                          title: "Routine",
                          iconWidget: Image.asset(
                            color: buttonColor,
                            'assets/icons/routing.png',
                            width: 24,
                            height: 24,
                          ),
                          iSSelected: routineSelected.value,
                          onTap: () {
                            resetSelection();
                            routineSelected.value = true;
                            Navigator.pop(context);
                            Get.toNamed('/routine');
                          },
                        )),

                  if (userDetailModel!.data!.role == "WORKER")
                    Obx(() => DrawerListTile(
                          title: "Routine Task",
                          icon: Icons.repeat,
                          iSSelected: routineSelected.value,
                          onTap: () {
                            resetSelection();
                            routineSelected.value = true;
                            Navigator.pop(context);
                            Get.toNamed('/workerRoutine');
                          },
                        )),

                  // Parts List
                  if (userDetailModel!.data!.role == "ADMIN")
                    Obx(() => DrawerListTile(
                          title: "Parts List",
                          icon: Icons.add_circle_outline,
                          iSSelected: partsListSelected.value,
                          onTap: () {
                            resetSelection();
                            partsListSelected.value = true;
                            Navigator.pop(context);
                            Get.toNamed('/partsList');
                          },
                        )),

                  // Clients
                  if (userDetailModel!.data!.role == "ADMIN")
                    Obx(() => DrawerListTile(
                          title: 'Clients',
                          icon: Icons.person,
                          iSSelected: clientsSelected.value,
                          onTap: () {
                            resetSelection();
                            clientsSelected.value = true;
                            Navigator.pop(context);
                            Get.toNamed('/clients');
                          },
                        )),

                  // Workers
                  if (userDetailModel!.data!.role == "ADMIN")
                    Obx(() => DrawerListTile(
                          title: 'Workers',
                          icon: Icons.group,
                          iSSelected: workersSelected.value,
                          onTap: () {
                            resetSelection();
                            workersSelected.value = true;
                            Navigator.pop(context);
                            Get.toNamed('/workers');
                          },
                        )),

                  // Requested Parts
                  if (userDetailModel!.data!.role != "WORKER")
                    Obx(() => DrawerListTile(
                          title: "Requested Parts",
                          icon: Icons.settings_applications,
                          iSSelected: requestedPartsSelected.value,
                          onTap: () {
                            resetSelection();
                            requestedPartsSelected.value = true;
                            Navigator.pop(context);
                            Get.toNamed('/requestedParts');
                          },
                        )),
                ],
              ),
            ),

            // Help Center Footer
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: containerColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const Icon(Icons.help_outline, color: Colors.white),
                          const SizedBox(height: 8),
                          const Text(
                            "Help Center",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Having Trouble? Please contact us for help.",
                            style: TextStyle(color: Colors.white, fontSize: 10),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: backgroundColor,
                            ),
                            child: const Text(
                              "Go To Help Center",
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 12,
                                color: containerColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: -100,
                    left: -94,
                    child: Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -70,
                    right: -94,
                    child: Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Widget? iconWidget;
  final VoidCallback onTap;
  final bool iSSelected;

  const DrawerListTile({
    super.key,
    required this.title,
    this.icon,
    this.iconWidget,
    required this.onTap,
    required this.iSSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Divider(),
        ListTile(
          leading: iconWidget ??
              Icon(
                icon,
                color: buttonColor,
                size: 25,
              ),
          title: Text(
            title,
            style: TextStyle(
              color: iSSelected ? containerColor : drawerItemColor,
              fontWeight: iSSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          onTap: onTap,
        ),
      ],
    );
  }
}
