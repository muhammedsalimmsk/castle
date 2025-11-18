import 'package:castle/Colors/Colors.dart';
import 'package:castle/Controlls/InvoiceController/InvoiceController.dart';
import 'package:castle/Model/invoice_model/invoice_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

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
        backgroundColor: backgroundColor,
        surfaceTintColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: containerColor),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Invoice Details',
          style: TextStyle(
            color: containerColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          Obx(() {
            if (controller.selectedInvoice.value?.pdfUrl != null) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: buttonColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        controller.downloadInvoicePdf(invoiceId);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child:
                            Icon(Icons.download, color: buttonColor, size: 22),
                      ),
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value &&
            controller.selectedInvoice.value == null) {
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
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderCard(invoice),
              const SizedBox(height: 24),
              const Text(
                'Client Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              _buildClientCard(invoice),
              const SizedBox(height: 24),
              const Text(
                'Invoice Dates',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              _buildDatesCard(invoice),
              if (invoice.complaint != null) ...[
                const SizedBox(height: 24),
                const Text(
                  'Related Complaint',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                _buildComplaintCard(invoice),
              ],
              const SizedBox(height: 24),
              const Text(
                'Invoice Items',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              _buildItemsCard(invoice),
              const SizedBox(height: 24),
              const Text(
                'Summary',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              _buildSummaryCard(invoice),
              if (invoice.notes != null && invoice.notes!.isNotEmpty) ...[
                const SizedBox(height: 24),
                const Text(
                  'Notes',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                _buildNotesCard(invoice),
              ],
              if (invoice.terms != null && invoice.terms!.isNotEmpty) ...[
                const SizedBox(height: 24),
                const Text(
                  'Terms & Conditions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                _buildTermsCard(invoice),
              ],
              const SizedBox(height: 24),
              _buildActionsCard(invoice, context),
              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHeaderCard(InvoiceData invoice) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: buttonColor.withOpacity(0.1),
            child: Icon(
              LucideIcons.receipt,
              color: buttonColor,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  invoice.invoiceNumber ?? 'N/A',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(invoice.status ?? 'DRAFT')
                        .withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
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
        ],
      ),
    );
  }

  Widget _buildClientCard(InvoiceData invoice) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          if (invoice.client?.clientName != null)
            _buildDetailRow(
              LucideIcons.building2,
              'Company',
              invoice.client!.clientName!,
            ),
          if (invoice.client?.firstName != null ||
              invoice.client?.lastName != null) ...[
            if (invoice.client?.clientName != null) const Divider(height: 24),
            _buildDetailRow(
              LucideIcons.user,
              'Contact Person',
              '${invoice.client?.firstName ?? ''} ${invoice.client?.lastName ?? ''}'
                  .trim(),
            ),
          ],
          if (invoice.client?.clientEmail != null) ...[
            if (invoice.client?.clientName != null ||
                invoice.client?.firstName != null ||
                invoice.client?.lastName != null)
              const Divider(height: 24),
            _buildDetailRow(
              LucideIcons.mail,
              'Email',
              invoice.client!.clientEmail!,
            ),
          ],
          if (invoice.client?.clientPhone != null) ...[
            if (invoice.client?.clientName != null ||
                invoice.client?.clientEmail != null ||
                invoice.client?.firstName != null ||
                invoice.client?.lastName != null)
              const Divider(height: 24),
            _buildDetailRow(
              LucideIcons.phone,
              'Phone',
              invoice.client!.clientPhone!,
            ),
          ],
          if (invoice.client?.clientAddress != null) ...[
            if (invoice.client?.clientName != null ||
                invoice.client?.clientEmail != null ||
                invoice.client?.clientPhone != null ||
                invoice.client?.firstName != null ||
                invoice.client?.lastName != null)
              const Divider(height: 24),
            _buildDetailRow(
              LucideIcons.mapPin,
              'Address',
              invoice.client!.clientAddress!,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDatesCard(InvoiceData invoice) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          if (invoice.issueDate != null)
            _buildDetailRow(
              LucideIcons.calendar,
              'Issue Date',
              DateFormat('MMM dd, yyyy').format(invoice.issueDate!),
            ),
          if (invoice.dueDate != null) ...[
            if (invoice.issueDate != null) const Divider(height: 24),
            _buildDetailRow(
              LucideIcons.calendarClock,
              'Due Date',
              DateFormat('MMM dd, yyyy').format(invoice.dueDate!),
            ),
          ],
          if (invoice.paidDate != null) ...[
            if (invoice.issueDate != null || invoice.dueDate != null)
              const Divider(height: 24),
            _buildDetailRow(
              Icons.check_circle,
              'Paid Date',
              DateFormat('MMM dd, yyyy').format(invoice.paidDate!),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: buttonColor, size: 22),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildComplaintCard(InvoiceData invoice) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (invoice.complaint?.title != null) ...[
            Text(
              invoice.complaint!.title!,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
          ],
          if (invoice.complaint?.description != null)
            Text(
              invoice.complaint!.description!,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          if (invoice.complaint?.equipment != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: buttonColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(LucideIcons.wrench, size: 18, color: buttonColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      invoice.complaint!.equipment!.name ?? 'N/A',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildItemsCard(InvoiceData invoice) {
    if (invoice.items == null || invoice.items!.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            'No items',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ),
      );
    }

    return Column(
      children: invoice.items!.map((item) => _buildItemRow(item)).toList(),
    );
  }

  Widget _buildItemRow(item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
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
                  item.description ?? 'N/A',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: buttonColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
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
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Qty: ${item.quantity ?? 0} × \$${item.unitPrice?.toStringAsFixed(2) ?? '0.00'}',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                '\$${item.total?.toStringAsFixed(2) ?? '0.00'}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: buttonColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(InvoiceData invoice) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: buttonColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSummaryRow(
            'Subtotal',
            '\$${invoice.subtotal?.toStringAsFixed(2) ?? '0.00'}',
          ),
          if (invoice.discount != null && invoice.discount! > 0) ...[
            const SizedBox(height: 8),
            _buildSummaryRow(
              'Discount',
              '-\$${invoice.discount!.toStringAsFixed(2)}',
            ),
          ],
          if (invoice.taxRate != null && invoice.taxRate! > 0) ...[
            const SizedBox(height: 8),
            _buildSummaryRow(
              'Tax (${invoice.taxRate}%)',
              '\$${invoice.taxAmount?.toStringAsFixed(2) ?? '0.00'}',
            ),
          ],
          const Divider(height: 24),
          _buildSummaryRow(
            'Total',
            '\$${invoice.total?.toStringAsFixed(2) ?? '0.00'}',
            isTotal: true,
          ),
        ],
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
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        invoice.notes!,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[700],
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildTermsCard(InvoiceData invoice) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        invoice.terms!,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[700],
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildActionsCard(InvoiceData invoice, BuildContext context) {
    return Column(
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
                elevation: 2,
              ),
            ),
          ),
        if (invoice.status != 'PAID' && invoice.status != 'CANCELLED') ...[
          if (invoice.pdfUrl != null) const SizedBox(height: 12),
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
              child:
                  const Text('Update', style: TextStyle(color: Colors.white)),
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
