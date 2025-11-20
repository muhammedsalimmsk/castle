import 'package:castle/Colors/Colors.dart';
import 'package:castle/Controlls/InvoiceController/InvoiceController.dart';
import 'package:castle/Model/invoice_model/invoice_data.dart';
import 'package:castle/Screens/InvoicePage/CreateInvoicePage.dart';
import 'package:castle/Screens/InvoicePage/InvoiceDetailsPage.dart';
import 'package:castle/Widget/CustomAppBarWidget.dart';
import 'package:castle/Widget/CustomDrawer.dart';
import 'package:castle/Utils/ResponsiveHelper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class InvoiceListPage extends StatelessWidget {
  final InvoiceController controller = Get.put(InvoiceController());

  InvoiceListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: ResponsiveHelper.getMaxContentWidth(context),
            ),
            child: Column(
              children: [
                _buildHeader(context),
                _buildFilters(context),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value &&
                        controller.invoices.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(buttonColor),
                              strokeWidth: 3,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Loading invoices...",
                              style: TextStyle(
                                color: subtitleColor,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (controller.invoices.isEmpty) {
                      return RefreshIndicator(
                        onRefresh: () =>
                            controller.fetchInvoices(refresh: true),
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
                                      Icons.receipt_long_outlined,
                                      size: 64,
                                      color: subtitleColor,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Text(
                                    "No invoices found",
                                    style: TextStyle(
                                      color: containerColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Create your first invoice",
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

                    // Use GridView for large screens, ListView for mobile
                    if (ResponsiveHelper.isLargeScreen(context)) {
                      return RefreshIndicator(
                        onRefresh: () =>
                            controller.fetchInvoices(refresh: true),
                        color: buttonColor,
                        child: GridView.builder(
                          padding:
                              ResponsiveHelper.getResponsivePadding(context)
                                  .copyWith(
                            top: 0,
                          ),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                ResponsiveHelper.getGridCrossAxisCount(context),
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 12,
                            childAspectRatio:
                                ResponsiveHelper.isDesktop(context) ? 1.3 : 1.2,
                          ),
                          itemCount: controller.invoices.length +
                              (controller.isLoadingMore.value ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == controller.invoices.length) {
                              return Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      buttonColor),
                                ),
                              );
                            }

                            final invoice = controller.invoices[index];
                            return _buildInvoiceCard(invoice, context);
                          },
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () => controller.fetchInvoices(refresh: true),
                      color: buttonColor,
                      child: ListView.builder(
                        padding: ResponsiveHelper.getResponsivePadding(context)
                            .copyWith(
                          top: 0,
                        ),
                        itemCount: controller.invoices.length +
                            (controller.isLoadingMore.value ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == controller.invoices.length) {
                            return Padding(
                              padding: const EdgeInsets.all(20),
                              child: Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      buttonColor),
                                ),
                              ),
                            );
                          }

                          final invoice = controller.invoices[index];
                          return _buildInvoiceCard(invoice, context);
                        },
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          controller.clearForm();
          Get.toNamed('/createInvoice');
        },
        backgroundColor: buttonColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'New Invoice',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: ResponsiveHelper.getResponsivePadding(context),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Invoices & Reports',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: containerColor,
                  ),
                ),
                const SizedBox(height: 4),
                Obx(() => Text(
                      '${controller.invoices.length} total',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    )),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () => controller.fetchInvoices(refresh: true),
                icon: Obx(() => controller.isLoading.value
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(buttonColor),
                        ),
                      )
                    : Icon(Icons.refresh, color: buttonColor)),
                tooltip: 'Refresh',
              ),
              IconButton(
                onPressed: () => _showSearchDialog(context),
                icon: Icon(Icons.search, color: buttonColor),
                tooltip: 'Search',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(context) {
    return Padding(
      padding: ResponsiveHelper.getResponsivePadding(context).copyWith(
        top: 0,
        bottom: 12,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: Colors.white,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              children: [
                Flexible(
                  flex: 1,
                  child: Obx(() => DropdownButtonFormField<String>(
                        value: controller.selectedStatus.value.isEmpty
                            ? null
                            : controller.selectedStatus.value,
                        decoration: InputDecoration(
                          labelText: 'Status',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: borderColor),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          isDense: true,
                        ),
                        isExpanded: true,
                        items: [
                          const DropdownMenuItem<String>(
                            value: '',
                            child: Text('All Status'),
                          ),
                          ...controller.statusTypes
                              .map((status) => DropdownMenuItem(
                                    value: status,
                                    child: Text(status),
                                  )),
                        ],
                        onChanged: (value) {
                          controller.selectedStatus.value = value ?? '';
                          controller.fetchInvoices(refresh: true);
                        },
                      )),
                ),
                const SizedBox(width: 12),
                Flexible(
                  flex: 1,
                  child: Obx(() => DropdownButtonFormField<String>(
                        value: controller.selectedReportType.value.isEmpty
                            ? null
                            : controller.selectedReportType.value,
                        decoration: InputDecoration(
                          labelText: 'Type',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: borderColor),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          isDense: true,
                        ),
                        isExpanded: true,
                        items: [
                          const DropdownMenuItem<String>(
                            value: '',
                            child: Text('All Types'),
                          ),
                          ...controller.reportTypes
                              .map((type) => DropdownMenuItem(
                                    value: type,
                                    child: Text(type.replaceAll('_', ' ')),
                                  )),
                        ],
                        onChanged: (value) {
                          controller.selectedReportType.value = value ?? '';
                          controller.fetchInvoices(refresh: true);
                        },
                      )),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildInvoiceCard(InvoiceData invoice, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            controller.fetchInvoiceById(invoice.id!);
            Get.toNamed('/invoiceDetails',
                arguments: {'invoiceId': invoice.id!});
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
                // Icon Container with Gradient
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
                    Icons.receipt_long,
                    color: backgroundColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              invoice.invoiceNumber ?? 'N/A',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: containerColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          _buildStatusChip(invoice.status ?? 'DRAFT'),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        invoice.reportType?.replaceAll('_', ' ') ?? 'N/A',
                        style: TextStyle(
                          fontSize: 12,
                          color: subtitleColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.business, size: 14, color: subtitleColor),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              invoice.client?.clientName ??
                                  (invoice.client?.firstName != null ||
                                          invoice.client?.lastName != null
                                      ? '${invoice.client?.firstName ?? ''} ${invoice.client?.lastName ?? ''}'
                                          .trim()
                                      : 'No Client'),
                              style: TextStyle(
                                fontSize: 13,
                                color: containerColor,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.calendar_today,
                              size: 14, color: subtitleColor),
                          const SizedBox(width: 6),
                          Text(
                            invoice.dueDate != null
                                ? DateFormat('MMM dd, yyyy')
                                    .format(invoice.dueDate!)
                                : 'No due date',
                            style: TextStyle(
                              fontSize: 12,
                              color: subtitleColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: subtitleColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '\$${invoice.total?.toStringAsFixed(2) ?? '0.00'}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: buttonColor,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: buttonColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    controller.downloadInvoicePdf(invoice.id!);
                                  },
                                  icon: Icon(Icons.download,
                                      color: buttonColor, size: 20),
                                  tooltip: 'Download PDF',
                                  padding: const EdgeInsets.all(8),
                                  constraints: const BoxConstraints(),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: IconButton(
                                  onPressed: () =>
                                      _showDeleteDialog(context, invoice),
                                  icon: const Icon(Icons.delete_outline,
                                      color: Colors.red, size: 20),
                                  tooltip: 'Delete',
                                  padding: const EdgeInsets.all(8),
                                  constraints: const BoxConstraints(),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color chipColor;
    Color textColor;

    switch (status.toUpperCase()) {
      case 'PAID':
        chipColor = Colors.green.shade50;
        textColor = Colors.green.shade700;
        break;
      case 'SENT':
        chipColor = buttonColor.withOpacity(0.15);
        textColor = buttonColor;
        break;
      case 'OVERDUE':
        chipColor = Colors.red.shade50;
        textColor = Colors.red.shade700;
        break;
      case 'CANCELLED':
        chipColor = Colors.grey.shade200;
        textColor = Colors.grey.shade700;
        break;
      default: // DRAFT
        chipColor = Colors.orange.shade50;
        textColor = Colors.orange.shade700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    final searchController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Invoices'),
        content: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search by invoice number or notes',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            prefixIcon: Icon(Icons.search, color: buttonColor),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.searchQuery.value = searchController.text;
              controller.fetchInvoices(refresh: true);
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
            ),
            child: const Text('Search', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, InvoiceData invoice) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Invoice'),
        content: Text(
          'Are you sure you want to delete invoice ${invoice.invoiceNumber}? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              final success = await controller.deleteInvoice(invoice.id!);
              if (success) {
                controller.fetchInvoices(refresh: true);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
