import 'package:castle/Colors/Colors.dart';
import 'package:castle/Controlls/AuthController/AuthController.dart';
import 'package:castle/Controlls/EquipmentController/EquipmentController.dart';
import 'package:castle/Screens/EquipmentPage/EquipmentCategoryPage/EquipmentCategoryPage.dart';

import 'package:castle/Screens/EquipmentPage/EquipmentDetails/ClientAddPage.dart';
import 'package:castle/Screens/EquipmentPage/EquipmentDetails/EquipmentDetails.dart';
import 'package:castle/Screens/EquipmentPage/EquipmentTypePage/EquipmentTypePage.dart';
import 'package:castle/Widget/CustomAppBarWidget.dart';
import 'package:castle/Widget/CustomDrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../Model/equipment_model/datum.dart';

class EquipmentPage extends StatefulWidget {
  EquipmentPage({super.key});

  @override
  State<EquipmentPage> createState() => _EquipmentPageState();
}

class _EquipmentPageState extends State<EquipmentPage> {
  final EquipmentController controller = Get.put(EquipmentController());

  String role = userDetailModel!.data!.role!.toLowerCase();
  final _key = GlobalKey<ExpandableFabState>();

  Future<List<EquipmentDetailData>?>? _equipmentFuture;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _equipmentFuture = controller.getEquipmentDetail(role);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: CustomAppBar(),
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Modern Header Section
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
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
              child: Column(
                children: [
                  // Title Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Equipment",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: containerColor,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Obx(() => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: searchBackgroundColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: dividerColor,
                                width: 1,
                              ),
                            ),
                            child: DropdownButton<String>(
                              value: controller.selectedValue.value,
                              underline: const SizedBox(),
                              icon: Icon(Icons.keyboard_arrow_down,
                                  color: buttonColor),
                              style: TextStyle(
                                color: containerColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              items: controller.sortOptions
                                  .map((value) => DropdownMenuItem(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: TextStyle(
                                            color: containerColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                controller.selectedValue.value = value!;
                              },
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // 🔍 Modern Search & Filter UI
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: searchBackgroundColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: dividerColor,
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: cardShadowColor.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Search equipment...",
                              hintStyle: TextStyle(
                                color: subtitleColor,
                                fontSize: 15,
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: buttonColor,
                                size: 22,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  color: subtitleColor,
                                  size: 20,
                                ),
                                onPressed: () {
                                  // Clear search
                                },
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                            style: TextStyle(
                              color: containerColor,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: buttonColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: buttonColor.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              // filter action
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              child: Icon(
                                FontAwesomeIcons.sliders,
                                color: backgroundColor,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 📋 Equipment List using FutureBuilder
            Expanded(
              child: FutureBuilder(
                future: _equipmentFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(buttonColor),
                            strokeWidth: 3,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Loading equipment...",
                            style: TextStyle(
                              color: subtitleColor,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: notWorkingWidgetColor.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.error_outline,
                                size: 48,
                                color: notWorkingTextColor,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "Oops! Something went wrong",
                              style: TextStyle(
                                color: containerColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "${snapshot.error}",
                              style: TextStyle(
                                color: subtitleColor,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  _equipmentFuture =
                                      controller.getEquipmentDetail(role);
                                });
                              },
                              icon: const Icon(Icons.refresh, size: 20),
                              label: const Text("Retry"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: buttonColor,
                                foregroundColor: backgroundColor,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        setState(() {
                          _equipmentFuture = controller.getEquipmentDetail(role);
                        });
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
                                    Icons.precision_manufacturing_outlined,
                                    size: 64,
                                    color: subtitleColor,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  "No equipment found",
                                  style: TextStyle(
                                    color: containerColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Try adjusting your search or filters",
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
                    );
                  }

                  final equipmentList = snapshot.data!;
                  return RefreshIndicator(
                    onRefresh: () async {
                      setState(() {
                        _equipmentFuture = controller.getEquipmentDetail(role);
                      });
                    },
                    color: buttonColor,
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                      itemCount: equipmentList.length,
                      itemBuilder: (context, index) {
                        final datas = equipmentList[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Get.to(EquipmentDetailsPage(
                                  equipment: datas,
                                ));
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: backgroundColor,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: dividerColor,
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: cardShadowColor.withOpacity(0.4),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                      spreadRadius: 0,
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      // Icon Container
                                      Container(
                                        width: 56,
                                        height: 56,
                                        decoration: BoxDecoration(
                                          color: buttonColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(14),
                                        ),
                                        child: Icon(
                                          Icons.precision_manufacturing,
                                          color: buttonColor,
                                          size: 28,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      // Content
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              datas.name!,
                                              style: TextStyle(
                                                color: containerColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: -0.3,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 6),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.tag,
                                                  size: 14,
                                                  color: subtitleColor,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  datas.serialNumber ?? "N/A",
                                                  style: TextStyle(
                                                    color: subtitleColor,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      // Category Badge & Arrow
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: buttonColor.withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              datas.category?.name ?? 'N/A',
                                              style: TextStyle(
                                                color: buttonColor,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Icon(
                                            Icons.chevron_right,
                                            color: subtitleColor,
                                            size: 20,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: userDetailModel!.data!.role == "ADMIN"
          ? ExpandableFab(
              openButtonBuilder: RotateFloatingActionButtonBuilder(
                child: const Icon(Icons.menu),
                fabSize: ExpandableFabSize.regular,
                foregroundColor: Colors.white,
                backgroundColor: buttonColor,
              ),
              closeButtonBuilder: DefaultFloatingActionButtonBuilder(
                child: const Icon(Icons.close),
                fabSize: ExpandableFabSize.small,
                foregroundColor: Colors.white,
                backgroundColor: buttonColor,
                shape: const CircleBorder(),
              ),
              key: _key,
              type: ExpandableFabType.up,
              childrenAnimation: ExpandableFabAnimation.none,
              distance: 70,
              overlayStyle: ExpandableFabOverlayStyle(
                color: Colors.white.withOpacity(0.9),
              ),
              children: [
                Row(
                  children: [
                    Text('New Equipment',
                        style: TextStyle(
                            color: buttonColor, fontWeight: FontWeight.bold)),
                    SizedBox(width: 20),
                    FloatingActionButton(
                      backgroundColor: buttonColor,
                      heroTag: "f12",
                      onPressed: () => Get.to(ClientAddPage()),
                      child: Image.asset(
                        'assets/icons/equipment.png',
                        width: 24,
                        height: 24,
                        color: Colors.white,
                        // optional
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Categories',
                      style: TextStyle(
                          color: buttonColor, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 20),
                    FloatingActionButton(
                      foregroundColor: Colors.white,
                      backgroundColor: buttonColor,
                      heroTag: ":f14",
                      onPressed: () {
                        Get.to(EquipmentCategoryPage());
                      },
                      child: Icon(Icons.category),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('Equipment Type',
                        style: TextStyle(
                            color: buttonColor, fontWeight: FontWeight.bold)),
                    SizedBox(width: 20),
                    FloatingActionButton(
                      foregroundColor: Colors.white,
                      backgroundColor: buttonColor,
                      heroTag: ":f34",
                      onPressed: () {
                        Get.to(EquipmentTypePage());
                      },
                      child: Icon(Icons.type_specimen),
                    ),
                  ],
                ),
              ],
            )
          : SizedBox.shrink(),
      floatingActionButtonLocation: ExpandableFab.location,
    );
  }
}
