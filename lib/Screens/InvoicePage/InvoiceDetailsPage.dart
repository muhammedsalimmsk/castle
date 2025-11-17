import 'package:castle/Colors/Colors.dart';
import 'package:castle/Controlls/InvoiceController/InvoiceController.dart';
import 'package:castle/Model/invoice_model/invoice_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class InvoiceDetailsPage extends StatelessWidget {
  final String invoiceId;
  final InvoiceController controller = Get.find<InvoiceController>();

  InvoiceDetailsPage({super.key, required this.invoiceId}) {
    controller.fetchInvoiceById(invoiceId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: buttonColor),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Invoice Details',
          style: TextStyle(
            color: containerColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Obx(() {
            if (controller.selectedInvoice.value?.pdfUrl != null) {
              return IconButton(
                icon: Icon(Icons.download, color: buttonColor),
                onPressed: () {
                  controller.downloadInvoicePdf(invoiceId);
                },
                tooltip: 'Download PDF',
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.selectedInvoice.value == null) {
          return const Center(child: CircularProgressIndicator());
        }
        
        final invoice = controller.selectedInvoice.value;
        if (invoice == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Invoice not found',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderCard(invoice),
              const SizedBox(height: 16),
              _buildClientCard(invoice),
              if (invoice.complaint != null) ...[
                const SizedBox(height: 16),
                _buildComplaintCard(invoice),
              ],
              const SizedBox(height: 16),
              _buildItemsCard(invoice),
              const SizedBox(height: 16),
              _buildSummaryCard(invoice),
              if (invoice.notes != null && invoice.notes!.isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildNotesCard(invoice),
              ],
              if (invoice.terms != null && invoice.terms!.isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildTermsCard(invoice),
              ],
              const SizedBox(height: 16),
              _buildActionsCard(invoice, context),
              const SizedBox(height: 80),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHeaderCard(InvoiceData invoice) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              buttonColor.withOpacity(0.1),
              buttonColor.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        invoice.invoiceNumber ?? 'N/A',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: containerColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(invoice.status ?? 'DRAFT')
                              .withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          invoice.status ?? 'DRAFT',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _getStatusColor(invoice.status ?? 'DRAFT'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.receipt_long,
                  size: 48,
                  color: buttonColor.withOpacity(0.3),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Divider(color: Colors.grey[300]),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoItem(
                  'Issue Date',
                  invoice.issueDate != null
                      ? DateFormat('MMM dd, yyyy').format(invoice.issueDate!)
                      : 'N/A',
                  Icons.calendar_today,
                ),
                _buildInfoItem(
                  'Due Date',
                  invoice.dueDate != null
                      ? DateFormat('MMM dd, yyyy').format(invoice.dueDate!)
                      : 'N/A',
                  Icons.event,
                ),
                if (invoice.paidDate != null)
                  _buildInfoItem(
                    'Paid Date',
                    DateFormat('MMM dd, yyyy').format(invoice.paidDate!),
                    Icons.check_circle,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 20, color: buttonColor),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: containerColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildClientCard(InvoiceData invoice) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.business, color: buttonColor),
                const SizedBox(width: 8),
                Text(
                  'Client Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: containerColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (invoice.client?.clientName != null)
              _buildClientInfoRow(
                'Company',
                invoice.client!.clientName!,
                Icons.business_center,
              ),
            if (invoice.client?.firstName != null ||
                invoice.client?.lastName != null)
              _buildClientInfoRow(
                'Contact Person',
                '${invoice.client?.firstName ?? ''} ${invoice.client?.lastName ?? ''}',
                Icons.person,
              ),
            if (invoice.client?.clientEmail != null)
              _buildClientInfoRow(
                'Email',
                invoice.client!.clientEmail!,
                Icons.email,
              ),
            if (invoice.client?.clientPhone != null)
              _buildClientInfoRow(
                'Phone',
                invoice.client!.clientPhone!,
                Icons.phone,
              ),
            if (invoice.client?.clientAddress != null)
              _buildClientInfoRow(
                'Address',
                invoice.client!.clientAddress!,
                Icons.location_on,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildClientInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: containerColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComplaintCard(InvoiceData invoice) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.report_problem, color: buttonColor),
                const SizedBox(width: 8),
                Text(
                  'Related Complaint',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: containerColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (invoice.complaint?.title != null)
              Text(
                invoice.complaint!.title!,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: containerColor,
                ),
              ),
            if (invoice.complaint?.description != null) ...[
              const SizedBox(height: 8),
              Text(
                invoice.complaint!.description!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
            if (invoice.complaint?.equipment != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.build, size: 18, color: buttonColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        invoice.complaint!.equipment!.name ?? 'N/A',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: containerColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildItemsCard(InvoiceData invoice) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.list_alt, color: buttonColor),
                const SizedBox(width: 8),
                Text(
                  'Items',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: containerColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (invoice.items == null || invoice.items!.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'No items',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              )
            else
              ...invoice.items!.map((item) => _buildItemRow(item)),
          ],
        ),
      ),
    );
  }

  Widget _buildItemRow(item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item.description ?? 'N/A',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: containerColor,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: buttonColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  item.type ?? 'N/A',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: buttonColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Qty: ${item.quantity ?? 0} × \$${item.unitPrice?.toStringAsFixed(2) ?? '0.00'}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                '\$${item.total?.toStringAsFixed(2) ?? '0.00'}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: containerColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(InvoiceData invoice) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              buttonColor.withOpacity(0.1),
              buttonColor.withOpacity(0.05),
            ],
          ),
        ),
        child: Column(
          children: [
            _buildSummaryRow(
              'Subtotal',
              '\$${invoice.subtotal?.toStringAsFixed(2) ?? '0.00'}',
            ),
            if (invoice.discount != null && invoice.discount! > 0)
              _buildSummaryRow(
                'Discount',
                '-\$${invoice.discount!.toStringAsFixed(2)}',
              ),
            if (invoice.taxRate != null && invoice.taxRate! > 0)
              _buildSummaryRow(
                'Tax (${invoice.taxRate}%)',
                '\$${invoice.taxAmount?.toStringAsFixed(2) ?? '0.00'}',
              ),
            const Divider(height: 24),
            _buildSummaryRow(
              'Total',
              '\$${invoice.total?.toStringAsFixed(2) ?? '0.00'}',
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
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
            value,
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

  Widget _buildNotesCard(InvoiceData invoice) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.note, color: buttonColor),
                const SizedBox(width: 8),
                Text(
                  'Notes',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: containerColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              invoice.notes!,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermsCard(InvoiceData invoice) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.description, color: buttonColor),
                const SizedBox(width: 8),
                Text(
                  'Terms & Conditions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: containerColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              invoice.terms!,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsCard(InvoiceData invoice, BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            if (invoice.pdfUrl != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    controller.downloadInvoicePdf(invoiceId);
                  },
                  icon: const Icon(Icons.download),
                  label: const Text('Download PDF'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            if (invoice.status != 'PAID' && invoice.status != 'CANCELLED') ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _showStatusUpdateDialog(context, invoice),
                  icon: const Icon(Icons.edit),
                  label: const Text('Update Status'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: buttonColor,
                    side: BorderSide(color: buttonColor),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showStatusUpdateDialog(BuildContext context, InvoiceData invoice) {
    String? selectedStatus = invoice.status;
    DateTime? paidDate;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Update Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedStatus,
                decoration: InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: controller.statusTypes.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedStatus = value;
                  });
                },
              ),
              if (selectedStatus == 'PAID') ...[
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('Paid Date'),
                  subtitle: Text(
                    paidDate != null
                        ? DateFormat('MMM dd, yyyy').format(paidDate!)
                        : 'Select date',
                  ),
                  trailing: Icon(Icons.calendar_today, color: buttonColor),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: paidDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      setState(() {
                        paidDate = date;
                      });
                    }
                  },
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final data = <String, dynamic>{
                  'status': selectedStatus,
                };
                if (selectedStatus == 'PAID' && paidDate != null) {
                  data['paidDate'] = paidDate!.toIso8601String();
                }
                Get.back();
                await controller.updateInvoice(invoice.id!, data);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
              ),
              child: const Text('Update', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PAID':
        return Colors.green;
      case 'SENT':
        return buttonColor;
      case 'OVERDUE':
        return Colors.red;
      case 'CANCELLED':
        return Colors.grey;
      default:
        return Colors.orange;
    }
  }
}

