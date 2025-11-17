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
  final RxBool invoicesSelected = false.obs;

  void resetSelection() {
    overviewSelected.value = false;
    equipmentSelected.value = false;
    complaintsSelected.value = false;
    routineSelected.value = false;
    clientsSelected.value = false;
    workersSelected.value = false;
    partsListSelected.value = false;
    requestedPartsSelected.value = false;
    invoicesSelected.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: backgroundColor,
      child: SafeArea(
        child: Column(
          children: [
            // Modern Drawer Header
            Container(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              decoration: BoxDecoration(
                color: backgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: cardShadowColor.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          buttonColor,
                          buttonColor.withOpacity(0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: buttonColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/book-square.png',
                      width: 28,
                      height: 28,
                      color: backgroundColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Nuegas",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: containerColor,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
            ),

            // Drawer Menu Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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

                  // Invoices
                  if (userDetailModel!.data!.role == "ADMIN")
                    Obx(() => DrawerListTile(
                          title: 'Invoices',
                          icon: Icons.receipt_long,
                          iSSelected: invoicesSelected.value,
                          onTap: () {
                            resetSelection();
                            invoicesSelected.value = true;
                            Navigator.pop(context);
                            Get.toNamed('/invoices');
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

            // Modern Help Center Footer
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      buttonColor,
                      buttonColor.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: buttonColor.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: backgroundColor.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.help_outline_rounded,
                        color: backgroundColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Help Center",
                      style: TextStyle(
                        color: backgroundColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Having Trouble? Please contact us for help.",
                      style: TextStyle(
                        color: backgroundColor.withOpacity(0.9),
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: backgroundColor,
                      ),
                      child: Text(
                        "Go To Help Center",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: buttonColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: iSSelected
                  ? buttonColor.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: iSSelected
                  ? Border.all(
                      color: buttonColor.withOpacity(0.3),
                      width: 1,
                    )
                  : null,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iSSelected
                        ? buttonColor.withOpacity(0.15)
                        : buttonColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: iconWidget ??
                      Icon(
                        icon,
                        color: iSSelected ? buttonColor : buttonColor.withOpacity(0.8),
                        size: 20,
                      ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: iSSelected ? containerColor : subtitleColor,
                      fontWeight: iSSelected ? FontWeight.bold : FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                ),
                if (iSSelected)
                  Icon(
                    Icons.chevron_right_rounded,
                    color: buttonColor,
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
