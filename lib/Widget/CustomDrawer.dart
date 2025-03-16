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
  final RxBool inventorySelected = false.obs;
  final RxBool accountsSelected = false.obs;
  final RxBool settingsSelected = false.obs;

  void resetSelection() {
    overviewSelected.value = false;
    equipmentSelected.value = false;
    complaintsSelected.value = false;
    routineSelected.value = false;
    inventorySelected.value = false;
    accountsSelected.value = false;
    settingsSelected.value = false;
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
                        icon: Icons.dashboard_outlined,
                        onTap: () {
                          resetSelection();
                          overviewSelected.value = true;
                          Get.offAndToNamed('/home');
                          if (Scaffold.of(context).isDrawerOpen) {
                            Navigator.pop(context);
                          }
                        },
                      )),
                  Obx(() => DrawerListTile(
                        iSSelected: equipmentSelected.value,
                        title: "Equipment",
                        icon: Icons.build,
                        onTap: () {
                          resetSelection();
                          equipmentSelected.value = true;

                          if (Scaffold.of(context).isDrawerOpen) {
                            Navigator.pop(context);
                          }
                        },
                      )),
                  Obx(() => DrawerListTile(
                        iSSelected: complaintsSelected.value,
                        title: "Complaints",
                        icon: Icons.book_outlined,
                        onTap: () {
                          resetSelection();
                          complaintsSelected.value = true;

                          if (Scaffold.of(context).isDrawerOpen) {
                            Navigator.pop(context);
                          }
                        },
                      )),
                  Obx(() => DrawerListTile(
                        iSSelected: routineSelected.value,
                        title: "Routine",
                        icon: Icons.repeat,
                        onTap: () {
                          resetSelection();
                          routineSelected.value = true;

                          if (Scaffold.of(context).isDrawerOpen) {
                            Navigator.pop(context);
                          }
                        },
                      )),
                  Obx(() => DrawerListTile(
                        iSSelected: inventorySelected.value,
                        title: 'Inventory',
                        icon: Icons.inventory,
                        onTap: () {
                          resetSelection();
                          inventorySelected.value = true;
                        },
                      )),
                  Obx(() => DrawerListTile(
                        iSSelected: accountsSelected.value,
                        title: "Accounts",
                        icon: Icons.account_balance,
                        onTap: () {
                          resetSelection();
                          accountsSelected.value = true;
                        },
                      )),
                  Obx(() => DrawerListTile(
                        iSSelected: settingsSelected.value,
                        title: "Settings",
                        icon: Icons.settings,
                        onTap: () {
                          resetSelection();
                          settingsSelected.value = true;
                        },
                      )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Container(
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
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool iSSelected;

  DrawerListTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    required this.iSSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: iSSelected ? containerColor : drawerItemColor,
        size: 20,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: iSSelected ? containerColor : drawerItemColor,
          fontSize: 12,
        ),
      ),
      onTap: onTap,
    );
  }
}
