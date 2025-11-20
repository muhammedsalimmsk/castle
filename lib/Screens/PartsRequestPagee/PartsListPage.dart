import 'package:castle/Colors/Colors.dart';
import 'package:castle/Controlls/PartsController/PartsController.dart';
import 'package:castle/Model/parts_list_model/datum.dart';
import 'package:castle/Screens/PartsRequestPagee/NewPartsPage.dart';
import 'package:castle/Screens/PartsRequestPagee/PartsDetailsPage.dart';
import 'package:castle/Widget/CustomAppBarWidget.dart';
import 'package:castle/Widget/CustomDrawer.dart';
import 'package:castle/Utils/ResponsiveHelper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PartsListPage extends StatelessWidget {
  PartsListPage({super.key});
  final PartsController controller = Get.put(PartsController());

  String formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('dd MMM yyyy').format(date);
  }

  Color getStockStatusColor(PartsDetail part) {
    if (part.currentStock == null || part.minStockLevel == null) {
      return subtitleColor;
    }
    if (part.currentStock! <= part.minStockLevel!) {
      return notWorkingTextColor; // Low stock - Red
    } else if (part.maxStockLevel != null && 
               part.currentStock! >= part.maxStockLevel!) {
      return workingTextColor; // High stock - Green
    }
    return Colors.orange; // Medium stock - Orange
  }

  String getStockStatusText(PartsDetail part) {
    if (part.currentStock == null || part.minStockLevel == null) {
      return 'Unknown';
    }
    if (part.currentStock! <= part.minStockLevel!) {
      return 'Low Stock';
    } else if (part.maxStockLevel != null && 
               part.currentStock! >= part.maxStockLevel!) {
      return 'In Stock';
    }
    return 'Available';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
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
                    "Parts Inventory",
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
                        "${controller.partsData.length} Parts",
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
                    hintText: "Search parts...",
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
            // Parts List
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
                                  "Loading parts...",
                                  style: TextStyle(
                                    color: subtitleColor,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : controller.partsData.isEmpty
                            ? RefreshIndicator(
                                onRefresh: () async {
                                  await controller.getPartsList();
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
                                              Icons.inventory_2_outlined,
                                              size: 64,
                                              color: subtitleColor,
                                            ),
                                          ),
                                          const SizedBox(height: 24),
                                          Text(
                                            "No parts found",
                                            style: TextStyle(
                                              color: containerColor,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            "Add new parts to get started",
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
                                      await controller.getPartsList();
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
                                      itemCount: controller.partsData.length,
                                      itemBuilder: (context, index) {
                                        PartsDetail part = controller.partsData[index];
                                        return _buildPartCard(part);
                                      },
                                    ),
                                  )
                                : RefreshIndicator(
                                    onRefresh: () async {
                                      await controller.getPartsList();
                                    },
                                    color: buttonColor,
                                    child: ListView.builder(
                                      padding: ResponsiveHelper.getResponsivePadding(context).copyWith(
                                        top: 0,
                                      ),
                                      itemCount: controller.partsData.length,
                                      itemBuilder: (context, index) {
                                        PartsDetail part = controller.partsData[index];
                                        return _buildPartCard(part);
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
            Get.toNamed('/newPart');
          },
          icon: const Icon(Icons.add, color: backgroundColor),
          label: Text(
            "New Parts",
            style: TextStyle(
              color: backgroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPartCard(PartsDetail part) {
    final stockStatusColor = getStockStatusColor(part);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Get.toNamed('/partsDetails', arguments: {'part': part});
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
                    Icons.precision_manufacturing_rounded,
                    color: backgroundColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        part.partName ?? 'Unknown Part',
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
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          if (part.partNumber != null)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.tag, size: 14, color: subtitleColor),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    "Part #${part.partNumber}",
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
                          if (part.category != null)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.category, size: 14, color: subtitleColor),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    part.category!,
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
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: stockStatusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: stockStatusColor.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: stockStatusColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    "${part.currentStock ?? 0} ${part.unit ?? ''}",
                                    style: TextStyle(
                                      color: stockStatusColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (part.unitPrice != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "\$${part.unitPrice!.toStringAsFixed(2)}",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Status Badge and Arrow
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
                        color: part.isActive == true
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
                              color: part.isActive == true
                                  ? workingTextColor
                                  : notWorkingTextColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            part.isActive == true ? "Active" : "Inactive",
                            style: TextStyle(
                              color: part.isActive == true
                                  ? workingTextColor
                                  : notWorkingTextColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
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
