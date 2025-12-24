import 'package:castle/Colors/Colors.dart';
import 'package:castle/Controlls/InvoiceController/InvoiceController.dart';
import 'package:castle/Model/requested_parts_model/datum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CreateInvoicePage extends StatefulWidget {
  const CreateInvoicePage({super.key});

  @override
  State<CreateInvoicePage> createState() => _CreateInvoicePageState();
}

class _CreateInvoicePageState extends State<CreateInvoicePage> {
  final InvoiceController controller = Get.find<InvoiceController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: buttonColor),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Create Invoice',
          style: TextStyle(
            color: containerColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Basic Information'),
            const SizedBox(height: 16),
            _buildClientIdField(),
            const SizedBox(height: 16),
            _buildReportTypeField(),
            const SizedBox(height: 16),
            _buildComplaintIdField(),
            const SizedBox(height: 16),
            _buildDueDateField(context),
            const SizedBox(height: 24),
            _buildSectionTitle('Invoice Items'),
            const SizedBox(height: 16),
            Obx(() => _buildItemsList()),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => controller.addInvoiceItem(),
              icon: const Icon(Icons.add),
              label: const Text('Add Item'),
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Additional Information'),
            const SizedBox(height: 16),
            _buildTaxRateField(),
            const SizedBox(height: 16),
            _buildDiscountField(),
            const SizedBox(height: 16),
            _buildNotesField(),
            const SizedBox(height: 16),
            _buildTermsField(),
            const SizedBox(height: 32),
            Obx(() => _buildSummaryCard()),
            const SizedBox(height: 24),
            _buildSubmitButton(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: containerColor,
      ),
    );
  }

  Widget _buildClientIdField() {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: TextEditingController(
              text: controller.selectedClient.value != null
                  ? (controller.selectedClient.value!.clientName ??
                      '${controller.selectedClient.value!.firstName ?? ''} ${controller.selectedClient.value!.lastName ?? ''}'
                          .trim())
                  : '',
            ),
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Client *',
              hintText: 'Select a client',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: buttonColor, width: 2),
              ),
              prefixIcon: Icon(Icons.business, color: buttonColor),
              suffixIcon: IconButton(
                icon: Icon(
                  controller.selectedClient.value != null
                      ? Icons.clear
                      : Icons.arrow_drop_down,
                  color: buttonColor,
                ),
                onPressed: () {
                  if (controller.selectedClient.value != null) {
                    controller.selectClient(null);
                  } else {
                    _showClientSearchDialog();
                  }
                },
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            onTap: () => _showClientSearchDialog(),
          ),
          if (controller.selectedClient.value != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: buttonColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: buttonColor.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: buttonColor, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.selectedClient.value!.clientName ??
                              '${controller.selectedClient.value!.firstName ?? ''} ${controller.selectedClient.value!.lastName ?? ''}'
                                  .trim(),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: containerColor,
                          ),
                        ),
                        if (controller.selectedClient.value!.clientEmail !=
                            null)
                          Text(
                            controller.selectedClient.value!.clientEmail!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      );
    });
  }

  void _showClientSearchDialog() {
    final searchController = TextEditingController();
    controller.clientSearchQuery.value = '';
    controller.filteredClients.value = controller.clients;

    showDialog(
      context: Get.context!,
      builder: (context) => Dialog(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.all(16),
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
                    'Select Client',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: containerColor,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: containerColor),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: searchController,
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                  hintText: 'Search by client name...',
                  prefixIcon: Icon(Icons.search, color: buttonColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: buttonColor, width: 2),
                  ),
                  filled: true,
                  fillColor: backgroundColor,
                ),
                onChanged: (value) {
                  controller.searchClients(value);
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Obx(() {
                  if (controller.isLoadingClients.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.filteredClients.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person_off,
                              size: 64, color: subtitleColor),
                          const SizedBox(height: 16),
                          Text(
                            'No clients found',
                            style: TextStyle(
                              fontSize: 16,
                              color: subtitleColor,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: controller.filteredClients.length,
                    itemBuilder: (context, index) {
                      final client = controller.filteredClients[index];
                      final clientName = client.clientName ??
                          '${client.firstName ?? ''} ${client.lastName ?? ''}'
                              .trim();

                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        elevation: 2,
                        shadowColor: buttonColor.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: borderColor.withOpacity(0.5)),
                        ),
                        color: backgroundColor,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: progressBackround,
                            child: Icon(Icons.business, color: buttonColor),
                          ),
                          title: Text(
                            clientName,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: containerColor,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (client.clientEmail != null)
                                Text(
                                  client.clientEmail!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: subtitleColor,
                                  ),
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
                          trailing: controller.selectedClient.value?.id ==
                                  client.id
                              ? Icon(Icons.check_circle, color: buttonColor)
                              : Icon(Icons.chevron_right, color: subtitleColor),
                          onTap: () {
                            controller.selectClient(client);
                            Get.back();
                          },
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
    );
  }

  Widget _buildReportTypeField() {
    return Obx(() => DropdownButtonFormField<String>(
          value: controller.selectedReportTypeForm.value.isEmpty
              ? null
              : controller.selectedReportTypeForm.value,
          decoration: InputDecoration(
            labelText: 'Report Type *',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: buttonColor, width: 2),
            ),
            prefixIcon: Icon(Icons.description, color: buttonColor),
            filled: true,
            fillColor: backgroundColor,
          ),
          dropdownColor: backgroundColor,
          style: TextStyle(color: containerColor),
          items: controller.reportTypes.map((type) {
            return DropdownMenuItem(
              value: type,
              child: Text(
                type.replaceAll('_', ' '),
                style: TextStyle(color: containerColor),
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              controller.selectedReportTypeForm.value = value;
              controller.reportTypeController.text = value;
              // Clear complaint if switching to a report type that doesn't support complaints
              if (value != 'INVOICE' && value != 'COMPLAINT_REPORT') {
                controller.selectComplaint(null);
              }
            }
          },
        ));
  }

  Widget _buildComplaintIdField() {
    return Obx(() {
      final reportType = controller.selectedReportTypeForm.value;
      final showComplaintField =
          reportType == 'INVOICE' || reportType == 'COMPLAINT_REPORT';

      if (!showComplaintField) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: TextEditingController(
              text: controller.selectedComplaint.value != null
                  ? controller.selectedComplaint.value!.title ??
                      controller.selectedComplaint.value!.id ??
                      ''
                  : '',
            ),
            readOnly: true,
            decoration: InputDecoration(
              labelText: reportType == 'COMPLAINT_REPORT'
                  ? 'Complaint *'
                  : 'Complaint ',
              hintText: 'Select a complaint',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: buttonColor, width: 2),
              ),
              prefixIcon: Icon(Icons.report_problem, color: buttonColor),
              suffixIcon: IconButton(
                icon: Icon(
                  controller.selectedComplaint.value != null
                      ? Icons.clear
                      : Icons.arrow_drop_down,
                  color: buttonColor,
                ),
                onPressed: () {
                  if (controller.selectedComplaint.value != null) {
                    controller.selectComplaint(null);
                  } else {
                    _showComplaintSearchDialog();
                  }
                },
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            onTap: () => _showComplaintSearchDialog(),
          ),
          if (controller.selectedComplaint.value != null) ...[
            const SizedBox(height: 8),
            _buildComplaintDetailsCard(),
            const SizedBox(height: 16),
            _buildPartsDetailsSection(),
          ],
        ],
      );
    });
  }

  Widget _buildComplaintDetailsCard() {
    final complaint = controller.selectedComplaint.value!;

    String formatApiString(String? rawString) {
      if (rawString == null || rawString.isEmpty) {
        return "N/A";
      }
      final words = rawString.replaceAll('_', ' ').toLowerCase().split(' ');
      final capitalizedWords = words.map((word) {
        if (word.isEmpty) return '';
        return word[0].toUpperCase() + word.substring(1);
      });
      return capitalizedWords.join(' ');
    }

    Color getPriorityColor(String? priority) {
      switch (priority?.toUpperCase()) {
        case "URGENT":
          return Colors.redAccent;
        case "HIGH":
          return Colors.orange;
        case "MEDIUM":
          return Colors.blue;
        case "LOW":
          return Colors.green;
        default:
          return Colors.grey;
      }
    }

    Color getStatusColor(String? status) {
      switch (status?.toUpperCase()) {
        case "OPEN":
          return containerColor;
        case "IN_PROGRESS":
          return Colors.green;
        case "RESOLVED":
          return Colors.green;
        case "CLOSED":
          return containerColor;
        default:
          return containerColor;
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: buttonColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: buttonColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: buttonColor, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Complaint Details',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: containerColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Title
          if (complaint.title != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.title, color: buttonColor, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      complaint.title!,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: containerColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          // Description
          if (complaint.description != null &&
              complaint.description!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.description, color: buttonColor, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      complaint.description!,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 8),
          // Status and Priority badges
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (complaint.status != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: getStatusColor(complaint.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: getStatusColor(complaint.status),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    formatApiString(complaint.status),
                    style: TextStyle(
                      color: getStatusColor(complaint.status),
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                    ),
                  ),
                ),
              if (complaint.priority != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color:
                        getPriorityColor(complaint.priority).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: getPriorityColor(complaint.priority),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.flag,
                          size: 12,
                          color: getPriorityColor(complaint.priority)),
                      const SizedBox(width: 4),
                      Text(
                        formatApiString(complaint.priority),
                        style: TextStyle(
                          color: getPriorityColor(complaint.priority),
                          fontWeight: FontWeight.w500,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          // Equipment info
          if (complaint.equipment?.name != null) ...[
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.precision_manufacturing,
                    color: buttonColor, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Equipment: ${complaint.equipment!.name}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPartsDetailsSection() {
    return Obx(() {
      if (controller.isLoadingParts.value) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: progressBackround,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
          ),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      if (controller.partsDetails.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.inventory_2, color: buttonColor, size: 20),
              const SizedBox(width: 8),
              Text(
                'Requested Parts Details',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: containerColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...controller.partsDetails.asMap().entries.map((entry) {
            final index = entry.key;
            final partRequest = entry.value;
            return _buildPartCard(partRequest, index);
          }).toList(),
        ],
      );
    });
  }

  Widget _buildPartCard(RequestedParts partRequest, int index) {
    final part = partRequest.part;
    final quantity = partRequest.quantity ?? 1;
    final unitPrice = part?.unitPrice ?? 0;
    final totalPrice = quantity * unitPrice;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: buttonColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  part?.partName ?? 'Unnamed Part',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: containerColor,
                  ),
                ),
              ),
            ],
          ),
          if (part?.partNumber != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.tag, color: subtitleColor, size: 16),
                const SizedBox(width: 6),
                Text(
                  'Part Number: ${part!.partNumber}',
                  style: TextStyle(
                    fontSize: 12,
                    color: subtitleColor,
                  ),
                ),
              ],
            ),
          ],
          if (part?.description != null && part!.description!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              part.description!,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[700],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 12),
          // Price information row
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: buttonColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: buttonColor.withOpacity(0.2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quantity',
                      style: TextStyle(
                        fontSize: 12,
                        color: subtitleColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$quantity',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: containerColor,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Unit Price',
                      style: TextStyle(
                        fontSize: 12,
                        color: subtitleColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${unitPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: containerColor,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Total Price',
                      style: TextStyle(
                        fontSize: 12,
                        color: subtitleColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: buttonColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              if (part?.category != null)
                _buildInfoChip(
                  Icons.category,
                  'Category',
                  part!.category!,
                ),
              if (part?.currentStock != null)
                _buildInfoChip(
                  Icons.inventory,
                  'Stock',
                  '${part!.currentStock}',
                ),
              if (part?.supplier != null)
                _buildInfoChip(
                  Icons.local_shipping,
                  'Supplier',
                  part!.supplier!,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: progressBackround,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: subtitleColor),
          const SizedBox(width: 4),
          Text(
            '$label: $value',
            style: TextStyle(
              fontSize: 11,
              color: subtitleColor,
            ),
          ),
        ],
      ),
    );
  }

  void _showComplaintSearchDialog() {
    // Check if client is selected
    if (controller.selectedClient.value == null) {
      Get.snackbar(
        'Error',
        'Please select a client first',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final searchController = TextEditingController();
    controller.complaintSearchQuery.value = '';
    controller.filteredComplaints.value = controller.complaints;

    // Fetch complaints for the selected client if not already loaded
    if (controller.complaints.isEmpty) {
      controller.fetchComplaints(
        clientId: controller.selectedClient.value?.id,
      );
    }

    showDialog(
      context: Get.context!,
      builder: (context) => Dialog(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.all(16),
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
                    'Select Complaint',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: containerColor,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: containerColor),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: searchController,
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                  hintText: 'Search by complaint title, description, or ID...',
                  prefixIcon: Icon(Icons.search, color: buttonColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: buttonColor, width: 2),
                  ),
                  filled: true,
                  fillColor: backgroundColor,
                ),
                onChanged: (value) {
                  controller.searchComplaints(value);
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Obx(() {
                  if (controller.isLoadingComplaints.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.filteredComplaints.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.report_off,
                              size: 64, color: subtitleColor),
                          const SizedBox(height: 16),
                          Text(
                            'No complaints found',
                            style: TextStyle(
                              fontSize: 16,
                              color: subtitleColor,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: controller.filteredComplaints.length,
                    itemBuilder: (context, index) {
                      final complaint = controller.filteredComplaints[index];

                      String formatApiString(String? rawString) {
                        if (rawString == null || rawString.isEmpty) {
                          return "N/A";
                        }
                        final words = rawString
                            .replaceAll('_', ' ')
                            .toLowerCase()
                            .split(' ');
                        final capitalizedWords = words.map((word) {
                          if (word.isEmpty) return '';
                          return word[0].toUpperCase() + word.substring(1);
                        });
                        return capitalizedWords.join(' ');
                      }

                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        elevation: 2,
                        shadowColor: buttonColor.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: borderColor.withOpacity(0.5)),
                        ),
                        color: backgroundColor,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: progressBackround,
                            child:
                                Icon(Icons.report_problem, color: buttonColor),
                          ),
                          title: Text(
                            complaint.title ?? 'No Title',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: containerColor,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (complaint.description != null &&
                                  complaint.description!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    complaint.description!.length > 50
                                        ? '${complaint.description!.substring(0, 50)}...'
                                        : complaint.description!,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: subtitleColor,
                                    ),
                                  ),
                                ),
                              if (complaint.status != null ||
                                  complaint.priority != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Wrap(
                                    spacing: 8,
                                    runSpacing: 4,
                                    children: [
                                      if (complaint.status != null)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color:
                                                containerColor.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            formatApiString(complaint.status),
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: subtitleColor,
                                            ),
                                          ),
                                        ),
                                      if (complaint.priority != null)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: buttonColor.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            formatApiString(complaint.priority),
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: buttonColor,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          trailing: controller.selectedComplaint.value?.id ==
                                  complaint.id
                              ? Icon(Icons.check_circle, color: buttonColor)
                              : Icon(Icons.chevron_right, color: subtitleColor),
                          onTap: () {
                            controller.selectComplaint(complaint);
                            Get.back();
                          },
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
    );
  }

  Widget _buildDueDateField(BuildContext context) {
    return Obx(() => InkWell(
          onTap: () => controller.selectDueDate(context),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: 'Due Date *',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: buttonColor, width: 2),
              ),
              prefixIcon: Icon(Icons.calendar_today, color: buttonColor),
              filled: true,
              fillColor: backgroundColor,
            ),
            child: Text(
              controller.selectedDueDate.value != null
                  ? DateFormat('yyyy-MM-dd')
                      .format(controller.selectedDueDate.value!)
                  : 'Select due date',
              style: TextStyle(
                color: controller.selectedDueDate.value != null
                    ? containerColor
                    : subtitleColor,
              ),
            ),
          ),
        ));
  }

  Widget _buildItemsList() {
    if (controller.invoiceItems.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: progressBackround,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.inbox_outlined, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 8),
              Text(
                'No items added',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: controller.invoiceItems.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        return _buildItemCard(index, item);
      }).toList(),
    );
  }

  Widget _buildItemCard(int index, Map<String, dynamic> item) {
    return _InvoiceItemCard(
      index: index,
      item: item,
      controller: controller,
    );
  }

  Widget _buildTaxRateField() {
    return TextFormField(
      controller: controller.taxRateController,
      decoration: InputDecoration(
        labelText: 'Tax Rate (%)',
        hintText: 'e.g., 5.0',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: buttonColor, width: 2),
        ),
        prefixIcon: Icon(Icons.percent, color: buttonColor),
        filled: true,
        fillColor: backgroundColor,
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      ],
    );
  }

  Widget _buildDiscountField() {
    return TextFormField(
      controller: controller.discountController,
      decoration: InputDecoration(
        labelText: 'Discount (\$)',
        hintText: 'e.g., 50.00',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: buttonColor, width: 2),
        ),
        prefixIcon: Icon(Icons.discount, color: buttonColor),
        prefixText: '\$ ',
        filled: true,
        fillColor: backgroundColor,
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      ],
    );
  }

  Widget _buildNotesField() {
    return TextFormField(
      controller: controller.notesController,
      decoration: InputDecoration(
        labelText: 'Notes',
        hintText: 'Additional notes...',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: buttonColor, width: 2),
        ),
        prefixIcon: Icon(Icons.note, color: buttonColor),
        filled: true,
        fillColor: backgroundColor,
      ),
      maxLines: 3,
    );
  }

  Widget _buildTermsField() {
    return TextFormField(
      controller: controller.termsController,
      decoration: InputDecoration(
        labelText: 'Terms & Conditions',
        hintText: 'e.g., Net 30',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: buttonColor, width: 2),
        ),
        prefixIcon: Icon(Icons.description, color: buttonColor),
        filled: true,
        fillColor: backgroundColor,
      ),
      maxLines: 2,
    );
  }

  Widget _buildSummaryCard() {
    double subtotal = 0.0;
    for (var item in controller.invoiceItems) {
      subtotal += (item['quantity'] ?? 0.0) * (item['unitPrice'] ?? 0.0);
    }

    // Calculate parts total from requested parts
    double partsTotal = 0.0;
    for (var partRequest in controller.partsDetails) {
      final quantity = partRequest.quantity ?? 0;
      final unitPrice = partRequest.part?.unitPrice ?? 0;
      partsTotal += quantity * unitPrice;
    }

    // Add parts total to subtotal
    final totalSubtotal = subtotal + partsTotal;

    final taxRate = double.tryParse(controller.taxRateController.text) ?? 0.0;
    final discount = double.tryParse(controller.discountController.text) ?? 0.0;
    final taxAmount = (totalSubtotal - discount) * (taxRate / 100);
    final total = totalSubtotal - discount + taxAmount;

    return Card(
      elevation: 3,
      shadowColor: buttonColor.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: borderColor.withOpacity(0.5), width: 1),
      ),
      color: backgroundColor,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              progressBackround,
              backgroundColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            _buildSummaryRow('Items Subtotal', subtotal),
            if (partsTotal > 0) _buildSummaryRow('Parts Total', partsTotal),
            _buildSummaryRow('Subtotal', totalSubtotal),
            if (discount > 0) _buildSummaryRow('Discount', -discount),
            if (taxRate > 0) _buildSummaryRow('Tax ($taxRate%)', taxAmount),
            const Divider(height: 24),
            _buildSummaryRow('Total', total, isTotal: true),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, double value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: containerColor,
            ),
          ),
          Text(
            '\$${value.abs().toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: isTotal ? 20 : 16,
              fontWeight: FontWeight.bold,
              color: isTotal ? buttonColor : containerColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Obx(() => SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: controller.isLoading.value
                ? null
                : () async {
                    final success = await controller.createInvoice();
                    if (success) {
                      // Navigate to InvoiceListPage and refresh data
                      // The controller already shows success message and refreshes data
                      Get.offNamed('/invoices');
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: controller.isLoading.value
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'Create Invoice',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ));
  }
}

class _InvoiceItemCard extends StatefulWidget {
  final int index;
  final Map<String, dynamic> item;
  final InvoiceController controller;

  const _InvoiceItemCard({
    required this.index,
    required this.item,
    required this.controller,
  });

  @override
  State<_InvoiceItemCard> createState() => _InvoiceItemCardState();
}

class _InvoiceItemCardState extends State<_InvoiceItemCard> {
  late TextEditingController typeController;
  late TextEditingController descriptionController;
  late TextEditingController quantityController;
  late TextEditingController unitPriceController;

  @override
  void initState() {
    super.initState();
    typeController =
        TextEditingController(text: widget.item['type'] ?? 'SERVICE');
    descriptionController =
        TextEditingController(text: widget.item['description'] ?? '');
    quantityController = TextEditingController(
        text: (widget.item['quantity'] ?? 1.0).toString());
    unitPriceController = TextEditingController(
        text: (widget.item['unitPrice'] ?? 0.0).toString());

    // Sync with item data when it changes externally
    descriptionController.addListener(_syncDescription);
    quantityController.addListener(_syncQuantity);
    unitPriceController.addListener(_syncUnitPrice);
  }

  void _syncDescription() {
    if (descriptionController.text != (widget.item['description'] ?? '')) {
      widget.controller.updateInvoiceItem(widget.index, {
        ...widget.item,
        'description': descriptionController.text,
      });
    }
  }

  void _syncQuantity() {
    final quantity = double.tryParse(quantityController.text) ?? 0.0;
    if (quantity != (widget.item['quantity'] ?? 0.0)) {
      widget.controller.updateInvoiceItem(widget.index, {
        ...widget.item,
        'quantity': quantity,
      });
    }
  }

  void _syncUnitPrice() {
    final unitPrice = double.tryParse(unitPriceController.text) ?? 0.0;
    if (unitPrice != (widget.item['unitPrice'] ?? 0.0)) {
      widget.controller.updateInvoiceItem(widget.index, {
        ...widget.item,
        'unitPrice': unitPrice,
      });
    }
  }

  @override
  void didUpdateWidget(_InvoiceItemCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update controllers if item data changed externally
    if (oldWidget.item['description'] != widget.item['description']) {
      if (descriptionController.text != (widget.item['description'] ?? '')) {
        descriptionController.text = widget.item['description'] ?? '';
      }
    }
    if (oldWidget.item['quantity'] != widget.item['quantity']) {
      final newQuantity = (widget.item['quantity'] ?? 1.0).toString();
      if (quantityController.text != newQuantity) {
        quantityController.text = newQuantity;
      }
    }
    if (oldWidget.item['unitPrice'] != widget.item['unitPrice']) {
      final newUnitPrice = (widget.item['unitPrice'] ?? 0.0).toString();
      if (unitPriceController.text != newUnitPrice) {
        unitPriceController.text = newUnitPrice;
      }
    }
    if (oldWidget.item['type'] != widget.item['type']) {
      typeController.text = widget.item['type'] ?? 'SERVICE';
    }
  }

  @override
  void dispose() {
    descriptionController.removeListener(_syncDescription);
    quantityController.removeListener(_syncQuantity);
    unitPriceController.removeListener(_syncUnitPrice);
    typeController.dispose();
    descriptionController.dispose();
    quantityController.dispose();
    unitPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      shadowColor: buttonColor.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: borderColor.withOpacity(0.5), width: 1),
      ),
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Item ${widget.index + 1}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: containerColor,
                  ),
                ),
                IconButton(
                  onPressed: () =>
                      widget.controller.removeInvoiceItem(widget.index),
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  tooltip: 'Remove item',
                ),
              ],
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: typeController.text,
              decoration: InputDecoration(
                labelText: 'Item Type',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: buttonColor, width: 2),
                ),
                filled: true,
                fillColor: backgroundColor,
              ),
              dropdownColor: backgroundColor,
              style: TextStyle(color: containerColor),
              items: widget.controller.itemTypes.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(
                    type,
                    style: TextStyle(color: containerColor),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  typeController.text = value;
                  widget.controller.updateInvoiceItem(widget.index, {
                    ...widget.item,
                    'type': value,
                  });
                }
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: descriptionController,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: containerColor,
              ),
              decoration: InputDecoration(
                labelText: 'Description *',
                hintText: 'Enter item description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: buttonColor, width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: notWorkingTextColor),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: notWorkingTextColor, width: 2),
                ),
                filled: true,
                fillColor: backgroundColor,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: quantityController,
                    decoration: InputDecoration(
                      labelText: 'Quantity',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: buttonColor, width: 2),
                      ),
                      filled: true,
                      fillColor: backgroundColor,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}'),
                      ),
                    ],
                    onChanged: (value) {
                      // Handled by listener
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: unitPriceController,
                    decoration: InputDecoration(
                      labelText: 'Unit Price',
                      prefixText: '\$ ',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: buttonColor, width: 2),
                      ),
                      filled: true,
                      fillColor: backgroundColor,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}'),
                      ),
                    ],
                    onChanged: (value) {
                      // Handled by listener
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: buttonColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: containerColor,
                    ),
                  ),
                  Text(
                    '\$${((widget.item['quantity'] ?? 0.0) * (widget.item['unitPrice'] ?? 0.0)).toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: buttonColor,
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
