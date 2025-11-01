import 'package:castle/Controlls/AuthController/AuthController.dart';
import 'package:castle/Screens/ClientPage/ClientPage.dart';
import 'package:castle/Screens/ComplaintsPage/ComplaintPage.dart';
import 'package:castle/Screens/EquipmentPage/EquipmentPage.dart';
import 'package:castle/Screens/HomePage/AdminHomePage.dart';
import 'package:castle/Screens/HomePage/ClientHomePage.dart';
import 'package:castle/Screens/HomePage/HomePage.dart';
import 'package:castle/Screens/HomePage/WorkerHomePage.dart';
import 'package:castle/Screens/PartsRequestPagee/PartsRequestPage.dart';
import 'package:castle/Screens/RoutineScreens/WorkerRoutinePage.dart';
import 'package:castle/Screens/WorkersPage/WorkersPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../Colors/Colors.dart';
import '../Screens/ClientPartPage/ClientPartsPage.dart';
import '../Screens/PartsRequestPagee/PartsListPage.dart';
import '../Screens/RoutineScreens/RoutinePage/RoutinePage.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({super.key});

  // Define RxBool variables for menu items
  final RxBool overviewSelected = false.obs;
  final RxBool equipmentSelected = false.obs;
  final RxBool complaintsSelected = false.obs;
  final RxBool routineSelected = false.obs;
  final RxBool inventorySelected = false.obs;
  final RxBool accountsSelected = false.obs;
  final RxBool settingsSelected = false.obs;
  final RxBool partsRequestSelected = false.obs;
  final RxBool workersRequestSelected = false.obs;
  final RxBool requestedPartsSelected = false.obs;

  void resetSelection() {
    overviewSelected.value = false;
    equipmentSelected.value = false;
    complaintsSelected.value = false;
    routineSelected.value = false;
    inventorySelected.value = false;
    accountsSelected.value = false;
    settingsSelected.value = false;
    partsRequestSelected.value = false;
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
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/book-square.png',
                    width: 35,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    "Nuegas",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  )
                ],
              ),
            ),
            // Drawer Menu Items
            Expanded(
              child: ListView(
                children: [
                  Obx(() => DrawerListTile(
                        iSSelected: overviewSelected.value,
                        title: "Overview",
                        iconWidget: Image.asset(
                          'assets/icons/category-2.png',
                          width: 24,
                          height: 24,
                          // optional
                        ),
                        onTap: () {
                          resetSelection();
                          overviewSelected.value = true;
                          if (userDetailModel!.data!.role == "ADMIN") {
                            Get.offAll(DashboardPage());
                          } else if (userDetailModel!.data!.role == "WORKER") {
                            Get.offAll(WorkerHomePage());
                          } else {
                            Get.offAll(ClientHomePage());
                          }
                        },
                      )),
                  if (userDetailModel!.data!.role != "WORKER") ...[
                    Obx(() => DrawerListTile(
                          iSSelected: equipmentSelected.value,
                          title: "Equipment",
                          iconWidget: Image.asset(
                            'assets/icons/equipment.png',
                            width: 24,
                            height: 24,
                            color: Colors.black,
                            // optional
                          ),
                          onTap: () {
                            resetSelection();
                            equipmentSelected.value = true;
                            Get.to(EquipmentPage());
                          },
                        )),
                  ],
                  Obx(() => DrawerListTile(
                        iSSelected: complaintsSelected.value,
                        title: "Complaints",
                        iconWidget: Image.asset(
                          'assets/icons/book.png',
                          width: 24,
                          height: 24,
                          // optional
                        ),
                        onTap: () {
                          resetSelection();
                          complaintsSelected.value = true;
                          if (Scaffold.of(context).isDrawerOpen) {
                            Navigator.pop(context);
                            Get.to(ComplaintPage());
                          }
                        },
                      )),
                  userDetailModel!.data!.role == 'ADMIN'
                      ? Obx(() => DrawerListTile(
                            iSSelected: routineSelected.value,
                            title: "Routine",
                            iconWidget: Image.asset(
                              'assets/icons/routing.png',
                              width: 24,
                              height: 24,
                              // optional
                            ),
                            onTap: () {
                              resetSelection();
                              routineSelected.value = true;
                              if (Scaffold.of(context).isDrawerOpen) {
                                Navigator.pop(context);
                                Get.to(RoutinePage());
                              }
                            },
                          ))
                      : SizedBox.shrink(),
                  userDetailModel!.data!.role == 'WORKER'
                      ? Obx(() => DrawerListTile(
                            iSSelected: routineSelected.value,
                            title: "Routine Task",
                            icon: Icons.repeat,
                            onTap: () {
                              resetSelection();
                              routineSelected.value = true;
                              if (Scaffold.of(context).isDrawerOpen) {
                                Navigator.pop(context);
                                Get.off(WorkerRoutinePage());
                              }
                            },
                          ))
                      : SizedBox.shrink(),
                  userDetailModel!.data!.role == 'ADMIN'
                      ? Obx(() => DrawerListTile(
                            iSSelected: routineSelected.value,
                            title: "Parts List",
                            icon: Icons.add_circle_outline,
                            onTap: () {
                              resetSelection();
                              partsRequestSelected.value = true;
                              if (Scaffold.of(context).isDrawerOpen) {
                                Navigator.pop(context);
                                Get.to(PartsListPage());
                              }
                            },
                          ))
                      : SizedBox.shrink(),
                  userDetailModel!.data!.role == 'ADMIN'
                      ? Obx(() => DrawerListTile(
                            iSSelected: inventorySelected.value,
                            title: 'Clients',
                            icon: Icons.person,
                            onTap: () {
                              resetSelection();
                              inventorySelected.value = true;
                              if (Scaffold.of(context).isDrawerOpen) {
                                Navigator.pop(context);
                                Get.to(ClientPage());
                              }
                            },
                          ))
                      : SizedBox.shrink(),
                  userDetailModel!.data!.role == 'ADMIN'
                      ? Obx(() => DrawerListTile(
                            iSSelected: inventorySelected.value,
                            title: 'Workers',
                            icon: Icons.group,
                            onTap: () {
                              resetSelection();
                              workersRequestSelected.value = true;
                              if (Scaffold.of(context).isDrawerOpen) {
                                Navigator.pop(context);
                                Get.to(WorkersPage());
                              }
                            },
                          ))
                      : SizedBox.shrink(),
                  userDetailModel!.data!.role != 'WORKER'
                      ? Obx(() => DrawerListTile(
                            iSSelected: accountsSelected.value,
                            title: "Requested Parts",
                            icon: Icons.settings_applications,
                            onTap: () {
                              resetSelection();
                              requestedPartsSelected.value = true;
                              if (Scaffold.of(context).isDrawerOpen) {
                                Navigator.pop(context);
                                Get.to(RequestedPartsPage());
                              }
                            },
                          ))
                      : SizedBox.shrink(),
                ],
              ),
            ),
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
                          SizedBox(height: 8),
                          const Text(
                            "Having Trouble in Learning. Please contact us for more questions.",
                            style: TextStyle(color: Colors.white, fontSize: 10),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8),
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: backgroundColor),
                            child: const Text(
                              "Go To Help Center",
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: containerColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: -100, // Move it upwards
                    left: -94, // Move it to the left
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
                    bottom: -70, // Move it upwards
                    right: -94, // Move it to the left
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
  final Widget? iconWidget; // optional

  final VoidCallback onTap;
  final bool iSSelected;

  const DrawerListTile(
      {super.key,
      required this.title,
      this.icon,
      required this.onTap,
      required this.iSSelected,
      this.iconWidget});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Divider(),
        ListTile(
          leading: iconWidget ??
              Icon(
                icon,
                color: iSSelected ? containerColor : containerColor,
                size: 25,
              ),
          title: Text(
            title,
            style: TextStyle(
              color: iSSelected ? containerColor : drawerItemColor,
            ),
          ),
          onTap: onTap,
        ),
      ],
    );
  }
}
