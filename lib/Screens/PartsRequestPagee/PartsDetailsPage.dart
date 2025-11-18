import 'package:castle/Colors/Colors.dart';
import 'package:castle/Model/parts_list_model/datum.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PartsDetailsPage extends StatelessWidget {
  final PartsDetail part;

  PartsDetailsPage({super.key, required this.part});

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
    final stockStatusColor = getStockStatusColor(part);
    final stockStatusText = getStockStatusText(part);
    final stockPercentage = part.maxStockLevel != null && part.maxStockLevel! > 0
        ? (part.currentStock ?? 0) / part.maxStockLevel!
        : 0.0;

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
          'Part Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: containerColor,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Modern Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
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
                  // Icon Container
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          buttonColor,
                          buttonColor.withOpacity(0.7),
                        ],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: buttonColor.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.precision_manufacturing_rounded,
                      color: backgroundColor,
                      size: 50,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Part Name
                  Text(
                    part.partName ?? 'Unknown Part',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: containerColor,
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: part.isActive == true
                          ? workingWidgetColor
                          : notWorkingWidgetColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: part.isActive == true
                                ? workingTextColor
                                : notWorkingTextColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          part.isActive == true ? "Active" : "Inactive",
                          style: TextStyle(
                            color: part.isActive == true
                                ? workingTextColor
                                : notWorkingTextColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Part Information Section
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: _sectionTitle('Part Information'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: dividerColor,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: cardShadowColor.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  children: _buildDetailItemsWithDividers([
                    _buildDetailRow(
                      Icons.tag_rounded,
                      "Part Number",
                      part.partNumber ?? 'N/A',
                    ),
                    _buildDetailRow(
                      Icons.category_rounded,
                      "Category",
                      part.category ?? 'N/A',
                    ),
                    _buildDetailRow(
                      Icons.scale_rounded,
                      "Unit",
                      part.unit ?? 'N/A',
                    ),
                  ]),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Stock Information Section
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
              child: _sectionTitle('Stock Information'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: stockStatusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: stockStatusColor.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.inventory_2_rounded,
                              color: stockStatusColor,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Stock Level",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: containerColor,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: stockStatusColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            stockStatusText,
                            style: TextStyle(
                              color: stockStatusColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Current Stock",
                          style: TextStyle(
                            fontSize: 14,
                            color: subtitleColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "${part.currentStock ?? 0} ${part.unit ?? ''}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: containerColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: stockPercentage.clamp(0.0, 1.0),
                        minHeight: 10,
                        backgroundColor: dividerColor,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          stockStatusColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStockInfo(
                            "Min Level",
                            part.minStockLevel?.toString() ?? 'N/A',
                            Colors.orange,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStockInfo(
                            "Max Level",
                            part.maxStockLevel?.toString() ?? 'N/A',
                            Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Pricing & Supplier Section
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
              child: _sectionTitle('Pricing & Supplier'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: dividerColor,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: cardShadowColor.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  children: _buildDetailItemsWithDividers([
                    _buildDetailRow(
                      Icons.attach_money_rounded,
                      "Unit Price",
                      part.unitPrice != null
                          ? "\$${part.unitPrice!.toStringAsFixed(2)}"
                          : 'N/A',
                    ),
                    if (part.supplier != null)
                      _buildDetailRow(
                        Icons.business_rounded,
                        "Supplier",
                        part.supplier!,
                      ),
                    if (part.location != null)
                      _buildDetailRow(
                        Icons.location_on_rounded,
                        "Location",
                        part.location!,
                      ),
                  ]),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Description Section
            if (part.description != null && part.description!.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                child: _sectionTitle('Description'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: searchBackgroundColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: dividerColor,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    part.description!,
                    style: TextStyle(
                      fontSize: 14,
                      color: containerColor,
                      height: 1.6,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
            // Additional Information Section
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
              child: _sectionTitle('Additional Information'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: dividerColor,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: cardShadowColor.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  children: _buildDetailItemsWithDividers([
                    _buildDetailRow(
                      Icons.calendar_today_rounded,
                      "Created At",
                      formatDate(part.createdAt),
                    ),
                    _buildDetailRow(
                      Icons.update_rounded,
                      "Updated At",
                      formatDate(part.updatedAt),
                    ),
                  ]),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: containerColor,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockInfo(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: subtitleColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: buttonColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: buttonColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: subtitleColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  color: containerColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildDetailItemsWithDividers(List<Widget> items) {
    if (items.isEmpty) return [];
    if (items.length == 1) return items;

    final List<Widget> result = [];
    for (int i = 0; i < items.length; i++) {
      result.add(items[i]);
      if (i < items.length - 1) {
        result.add(const SizedBox(height: 24));
      }
    }
    return result;
  }
}

