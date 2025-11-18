import 'dart:async';
import 'package:castle/Colors/Colors.dart';
import 'package:castle/Controlls/AuthController/AuthController.dart';
import 'package:castle/Controlls/EquipmentController/EquipmentController.dart';
import 'package:castle/Screens/EquipmentPage/EquipmentCategoryPage/EquipmentCategoryPage.dart';

import 'package:castle/Screens/EquipmentPage/EquipmentDetails/ClientAddPage.dart';
import 'package:castle/Screens/EquipmentPage/EquipmentDetails/EquipmentDetails.dart';
import 'package:castle/Screens/EquipmentPage/EquipmentTypePage/EquipmentTypePage.dart';
import 'package:castle/Widget/CustomAppBarWidget.dart';
import 'package:castle/Widget/CustomDrawer.dart';
import 'package:castle/Utils/ResponsiveHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
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
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  Future<List<EquipmentDetailData>?>? _equipmentFuture;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadEquipment();
    // Load clients for filter dropdown if admin
    if (userDetailModel!.data!.role == "ADMIN") {
      controller.getClientList();
    }
  }

  void _loadEquipment() {
    setState(() {
      _equipmentFuture = controller.getEquipmentDetail(
        role,
        search: controller.equipmentSearchQuery.value.isEmpty 
            ? null 
            : controller.equipmentSearchQuery.value,
        clientId: controller.selectedClientId.value,
      );
    });
  }

  void _onSearchChanged(String value) {
    controller.equipmentSearchQuery.value = value;
    
    // Debounce search
    if (_debounceTimer != null) {
      _debounceTimer!.cancel();
    }
    
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _loadEquipment();
    });
  }

  void _showClientFilterDialog() {
    final searchController = TextEditingController();
    controller.clientSearchQuery.value = '';
    controller.filteredClients.value = controller.clientData;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.7,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filter by Client',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: containerColor,
                        letterSpacing: -0.5,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: containerColor),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: searchBackgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: cardShadowColor.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Obx(() => TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search by client name...',
                      hintStyle: TextStyle(
                        color: subtitleColor,
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(Icons.search, color: buttonColor),
                      suffixIcon: controller.clientSearchQuery.value.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear, color: subtitleColor, size: 20),
                              onPressed: () {
                                searchController.clear();
                                controller.clientSearchQuery.value = '';
                                controller.filteredClients.value = controller.clientData;
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: buttonColor,
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: searchBackgroundColor,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    style: TextStyle(
                      color: containerColor,
                      fontSize: 15,
                    ),
                    onChanged: (value) {
                      controller.onSearchChanged(value);
                    },
                  )),
                ),
              const SizedBox(height: 16),
              Expanded(
                child: Obx(() {
                  if (controller.isFetchingClients.value) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(buttonColor),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Loading clients...',
                            style: TextStyle(
                              color: subtitleColor,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final clientsToShow = controller.filteredClients.isEmpty
                      ? controller.clientData
                      : controller.filteredClients;

                  if (clientsToShow.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: searchBackgroundColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.person_off,
                              size: 48,
                              color: subtitleColor,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No clients found',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: containerColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try a different search term',
                            style: TextStyle(
                              fontSize: 14,
                              color: subtitleColor,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: clientsToShow.length + 1, // +1 for "All Clients" option
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        // "All Clients" option
                        final isSelected = controller.selectedClientId.value == null;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                controller.selectedClientId.value = null;
                                controller.selectedClientName.value = '';
                                _loadEquipment();
                                Get.back();
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? buttonColor.withOpacity(0.1)
                                      : searchBackgroundColor,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? buttonColor
                                        : dividerColor,
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? buttonColor
                                            : searchBackgroundColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.all_inclusive,
                                        color: isSelected
                                            ? backgroundColor
                                            : subtitleColor,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'All Clients',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                          color: isSelected
                                              ? buttonColor
                                              : containerColor,
                                        ),
                                      ),
                                    ),
                                    if (isSelected)
                                      Icon(
                                        Icons.check_circle,
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

                      final client = clientsToShow[index - 1];
                      final clientName = client.clientName ??
                          '${client.firstName ?? ''} ${client.lastName ?? ''}'
                              .trim();
                      final isSelected =
                          controller.selectedClientId.value == client.id;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              controller.selectedClientId.value = client.id;
                              controller.selectedClientName.value = clientName;
                              _loadEquipment();
                              Get.back();
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? buttonColor.withOpacity(0.1)
                                    : searchBackgroundColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? buttonColor
                                      : dividerColor,
                                  width: isSelected ? 2 : 1,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: buttonColor.withOpacity(0.2),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: isSelected
                                            ? [buttonColor, buttonColor.withOpacity(0.7)]
                                            : [
                                                searchBackgroundColor,
                                                searchBackgroundColor
                                              ],
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.business,
                                      color: isSelected
                                          ? backgroundColor
                                          : subtitleColor,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          clientName,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                            color: isSelected
                                                ? buttonColor
                                                : containerColor,
                                          ),
                                        ),
                                        if (client.clientEmail != null ||
                                            client.clientPhone != null)
                                          const SizedBox(height: 4),
                                        if (client.clientEmail != null)
                                          Text(
                                            client.clientEmail!,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: subtitleColor,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        if (client.clientPhone != null)
                                          Text(
                                            client.clientPhone!,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: subtitleColor,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  if (isSelected)
                                    Icon(
                                      Icons.check_circle,
                                      color: buttonColor,
                                      size: 20,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

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
                    "Equipment",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: containerColor,
                      letterSpacing: -0.5,
                    ),
                  ),
                  FutureBuilder(
                    future: _equipmentFuture,
                    builder: (context, snapshot) {
                      int count = 0;
                      if (snapshot.hasData && snapshot.data != null) {
                        count = snapshot.data!.length;
                      }
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: buttonColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: buttonColor.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          "$count Equipment",
                          style: TextStyle(
                            color: buttonColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      );
                    },
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
              child: Row(
                children: [
                  Expanded(
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
                      child: Obx(() => TextField(
                        controller: _searchController,
                        onChanged: _onSearchChanged,
                        decoration: InputDecoration(
                          hintText: "Search equipment...",
                          hintStyle: TextStyle(
                            color: subtitleColor,
                            fontSize: 14,
                          ),
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: buttonColor,
                            size: 22,
                          ),
                          suffixIcon: controller.equipmentSearchQuery.value.isNotEmpty
                              ? IconButton(
                                  icon: Icon(
                                    Icons.clear,
                                    color: subtitleColor,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    _searchController.clear();
                                    controller.equipmentSearchQuery.value = '';
                                    _loadEquipment();
                                  },
                                )
                              : null,
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
                        style: TextStyle(
                          color: containerColor,
                          fontSize: 15,
                        ),
                      )),
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (userDetailModel!.data!.role == "ADMIN")
                    Obx(() => GestureDetector(
                      onTap: () => _showClientFilterDialog(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: searchBackgroundColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: controller.selectedClientId.value != null
                                ? buttonColor
                                : dividerColor,
                            width: controller.selectedClientId.value != null ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.filter_list,
                              color: controller.selectedClientId.value != null
                                  ? buttonColor
                                  : subtitleColor,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                controller.selectedClientName.value.isEmpty
                                    ? "Filter by Client"
                                    : controller.selectedClientName.value,
                                style: TextStyle(
                                  color: controller.selectedClientId.value != null
                                      ? buttonColor
                                      : subtitleColor,
                                  fontSize: 14,
                                  fontWeight: controller.selectedClientId.value != null
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (controller.selectedClientId.value != null) ...[
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  controller.selectedClientId.value = null;
                                  controller.selectedClientName.value = '';
                                  _loadEquipment();
                                },
                                child: Icon(
                                  Icons.close,
                                  color: buttonColor,
                                  size: 18,
                                ),
                              ),
                            ] else ...[
                              const SizedBox(width: 4),
                              Icon(
                                Icons.arrow_drop_down,
                                color: subtitleColor,
                                size: 20,
                              ),
                            ],
                          ],
                        ),
                      ),
                    )),
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
                                _loadEquipment();
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
                        _loadEquipment();
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
                                  "Add new equipment to get started",
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
                  
                  // Use GridView for large screens, ListView for mobile
                  if (ResponsiveHelper.isLargeScreen(context)) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        _loadEquipment();
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
                        itemCount: equipmentList.length,
                        itemBuilder: (context, index) {
                          final datas = equipmentList[index];
                          return _buildEquipmentCard(datas);
                        },
                      ),
                    );
                  }
                  
                  return RefreshIndicator(
                    onRefresh: () async {
                      _loadEquipment();
                    },
                    color: buttonColor,
                    child: ListView.builder(
                      padding: ResponsiveHelper.getResponsivePadding(context).copyWith(
                        top: 0,
                      ),
                      itemCount: equipmentList.length,
                      itemBuilder: (context, index) {
                        final datas = equipmentList[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildEquipmentCard(datas),
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

  Widget _buildEquipmentCard(EquipmentDetailData datas) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Get.to(EquipmentDetailsPage(
            equipment: datas,
          ));
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
                  Icons.precision_manufacturing,
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
                        Flexible(
                          child: Text(
                            datas.serialNumber ?? "N/A",
                            style: TextStyle(
                              color: subtitleColor,
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (datas.category?.name != null)
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
                            Icon(
                              Icons.category,
                              size: 12,
                              color: buttonColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              datas.category!.name!,
                              style: TextStyle(
                                color: buttonColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Arrow
              Icon(
                Icons.chevron_right,
                color: subtitleColor,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

