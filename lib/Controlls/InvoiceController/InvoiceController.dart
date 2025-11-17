import 'package:castle/Colors/Colors.dart';
import 'package:castle/Controlls/AuthController/AuthController.dart';
import 'package:castle/Controlls/ClientController/ClientController.dart';
import 'package:castle/Model/invoice_model/invoice_model.dart';
import 'package:castle/Model/invoice_model/invoice_data.dart';
import 'package:castle/Model/client_model/datum.dart';
import 'package:castle/Services/ApiService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InvoiceController extends GetxController {
  final ApiService _apiService = ApiService();
  late ClientRegisterController _clientController;

  // Observable variables
  RxList<InvoiceData> invoices = <InvoiceData>[].obs;
  Rx<InvoiceData?> selectedInvoice = Rx<InvoiceData?>(null);
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  RxBool hasMore = true.obs;

  // Pagination
  int currentPage = 1;
  final int limit = 10;

  // Filters
  RxString selectedStatus = ''.obs;
  RxString selectedReportType = ''.obs;
  RxString selectedClientId = ''.obs;
  RxString searchQuery = ''.obs;

  // Form controllers for create/edit
  final clientIdController = TextEditingController();
  final complaintIdController = TextEditingController();
  final reportTypeController = TextEditingController();
  final dueDateController = TextEditingController();
  final taxRateController = TextEditingController();
  final discountController = TextEditingController();
  final notesController = TextEditingController();
  final termsController = TextEditingController();

  RxList<Map<String, dynamic>> invoiceItems = <Map<String, dynamic>>[].obs;
  Rx<DateTime?> selectedDueDate = Rx<DateTime?>(null);
  RxString selectedReportTypeForm = ''.obs;

  // Client selection
  RxList<ClientData> clients = <ClientData>[].obs;
  Rx<ClientData?> selectedClient = Rx<ClientData?>(null);
  RxString clientSearchQuery = ''.obs;
  RxList<ClientData> filteredClients = <ClientData>[].obs;
  RxBool isLoadingClients = false.obs;

  // Report types
  final List<String> reportTypes = [
    'INVOICE',
    'COMPLAINT_REPORT',
    'EQUIPMENT_REPORT',
    'MAINTENANCE_REPORT',
    'CUSTOM',
  ];

  // Status types
  final List<String> statusTypes = [
    'DRAFT',
    'SENT',
    'PAID',
    'OVERDUE',
    'CANCELLED',
  ];

  // Item types
  final List<String> itemTypes = [
    'SERVICE',
    'PARTS',
    'LABOR',
    'OTHER',
  ];

  @override
  void onInit() {
    super.onInit();
    // Initialize ClientController if not already initialized
    try {
      _clientController = Get.find<ClientRegisterController>();
    } catch (e) {
      _clientController = Get.put(ClientRegisterController());
    }
    fetchInvoices();
    _initializeClients();
  }

  // Initialize clients from ClientController
  Future<void> _initializeClients() async {
    isLoadingClients.value = true;
    try {
      // Use ClientController's client list if available, otherwise fetch
      if (_clientController.clientData.isEmpty) {
        await _clientController.getClientList();
      }
      clients.value = _clientController.clientData;
      filteredClients.value = clients;
    } catch (e) {
      print('Error initializing clients: $e');
    } finally {
      isLoadingClients.value = false;
    }
  }

  // Refresh clients from ClientController
  Future<void> refreshClients() async {
    isLoadingClients.value = true;
    try {
      await _clientController.getClientList();
      clients.value = _clientController.clientData;
      filteredClients.value = clients;
    } catch (e) {
      print('Error refreshing clients: $e');
    } finally {
      isLoadingClients.value = false;
    }
  }

  // Search clients
  void searchClients(String query) {
    clientSearchQuery.value = query;
    if (query.isEmpty) {
      filteredClients.value = clients;
    } else {
      filteredClients.value = clients.where((client) {
        final name = (client.clientName ??
                '${client.firstName ?? ''} ${client.lastName ?? ''}')
            .toLowerCase();
        return name.contains(query.toLowerCase());
      }).toList();
    }
  }

  // Select client
  void selectClient(ClientData? client) {
    selectedClient.value = client;
    if (client != null) {
      clientIdController.text = client.id ?? '';
    } else {
      clientIdController.clear();
    }
  }

  @override
  void onClose() {
    clientIdController.dispose();
    complaintIdController.dispose();
    reportTypeController.dispose();
    dueDateController.dispose();
    taxRateController.dispose();
    discountController.dispose();
    notesController.dispose();
    termsController.dispose();
    super.onClose();
  }

  // Fetch all invoices with filters
  Future<void> fetchInvoices({bool refresh = false}) async {
    if (refresh) {
      currentPage = 1;
      hasMore.value = true;
      invoices.clear();
    }

    if (isLoading.value || isLoadingMore.value || !hasMore.value) return;

    if (currentPage == 1) {
      isLoading.value = true;
    } else {
      isLoadingMore.value = true;
    }

    try {
      String endpoint =
          '/api/v1/reports/invoices?page=$currentPage&limit=$limit';

      if (searchQuery.value.isNotEmpty) {
        endpoint += '&search=${Uri.encodeComponent(searchQuery.value)}';
      }
      if (selectedStatus.value.isNotEmpty) {
        endpoint += '&status=${selectedStatus.value}';
      }
      if (selectedReportType.value.isNotEmpty) {
        endpoint += '&reportType=${selectedReportType.value}';
      }
      if (selectedClientId.value.isNotEmpty) {
        endpoint += '&clientId=${selectedClientId.value}';
      }

      final response =
          await _apiService.getRequest(endpoint, bearerToken: token);

      if (response.isOk) {
        final model = InvoiceModel.fromJson(response.body);

        if (model.dataList != null && model.dataList!.isNotEmpty) {
          if (refresh || currentPage == 1) {
            invoices.value = model.dataList!;
          } else {
            invoices.addAll(model.dataList!);
          }

          if (model.meta != null) {
            hasMore.value = currentPage < (model.meta!.totalPages ?? 1);
            if (hasMore.value) {
              currentPage++;
            }
          } else {
            hasMore.value = model.dataList!.length >= limit;
            if (hasMore.value) {
              currentPage++;
            }
          }
        } else {
          hasMore.value = false;
        }
      } else {
        print(response.body);
        Get.snackbar(
          'Error',
          response.body['error'] ?? 'Failed to fetch invoices',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch invoices: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  // Fetch invoice by ID
  Future<void> fetchInvoiceById(String invoiceId) async {
    isLoading.value = true;

    try {
      final response = await _apiService.getRequest(
        '/api/invoices/$invoiceId',
        bearerToken: token,
      );

      if (response.isOk) {
        final model = InvoiceModel.fromJson(response.body);
        selectedInvoice.value = model.data;
      } else {
        Get.snackbar(
          'Error',
          response.body['error'] ?? 'Failed to fetch invoice',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch invoice: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Create invoice
  Future<bool> createInvoice() async {
    if (selectedClient.value == null || selectedClient.value!.id == null) {
      Get.snackbar('Error', 'Please select a client',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    if (invoiceItems.isEmpty) {
      Get.snackbar('Error', 'At least one item is required',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    // Validate that all items have description
    for (int i = 0; i < invoiceItems.length; i++) {
      final item = invoiceItems[i];
      final description = item['description']?.toString().trim() ?? '';
      if (description.isEmpty) {
        Get.snackbar(
          'Error',
          'Item ${i + 1}: Description is required',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    }

    if (selectedDueDate.value == null) {
      Get.snackbar('Error', 'Due date is required',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    isLoading.value = true;

    try {
      // Format date as YYYY-MM-DD (date only, no time)
      final dueDateString = '${selectedDueDate.value!.year}-'
          '${selectedDueDate.value!.month.toString().padLeft(2, '0')}-'
          '${selectedDueDate.value!.day.toString().padLeft(2, '0')}T23:59:59.000Z';

      final data = {
        'clientId': selectedClient.value!.id!,
        if (complaintIdController.text.isNotEmpty)
          'complaintId': complaintIdController.text.trim(),
        'reportType': selectedReportTypeForm.value.isNotEmpty
            ? selectedReportTypeForm.value
            : reportTypeController.text.trim(),
        'dueDate': dueDateString,
        'items': invoiceItems
            .map((item) => {
                  'type': item['type'],
                  'description': item['description']?.toString().trim() ?? '',
                  'quantity': item['quantity'],
                  'unitPrice': item['unitPrice'],
                })
            .toList(),
        if (taxRateController.text.isNotEmpty)
          'taxRate': double.tryParse(taxRateController.text) ?? 0.0,
        if (discountController.text.isNotEmpty)
          'discount': double.tryParse(discountController.text) ?? 0.0,
        if (notesController.text.isNotEmpty)
          'notes': notesController.text.trim(),
        if (termsController.text.isNotEmpty)
          'terms': termsController.text.trim(),
      };

      print('📤 Creating invoice with data:');
      print(DateTime.now().toString());
      print(data);

      final response = await _apiService.postRequest(
        '/api/v1/reports/invoices',
        data,
        bearerToken: token,
      );

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');
      print('📥 Response isOk: ${response.isOk}');

      if (response.isOk) {
        Get.snackbar(
          'Success',
          response.body['message'] ?? 'Invoice created successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        clearForm();
        fetchInvoices(refresh: true);
        return true;
      } else {
        print('❌ Error Response:');
        print('Status Code: ${response.statusCode}');
        print('Status Text: ${response.statusText}');
        print('Body: ${response.body}');
        print('Body String: ${response.bodyString}');

        final errorMessage = response.body is Map
            ? (response.body['error'] ??
                response.body['message'] ??
                'Failed to create invoice')
            : (response.bodyString?.isNotEmpty ?? false)
                ? response.bodyString!
                : 'Failed to create invoice';
        print(errorMessage);
        Get.snackbar(
          'Error',
          errorMessage.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
        return false;
      }
    } catch (e, stackTrace) {
      print('❌ Exception in createInvoice:');
      print('Error: $e');
      print('Stack Trace: $stackTrace');

      Get.snackbar(
        'Error',
        'Failed to create invoice: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Update invoice
  Future<bool> updateInvoice(
      String invoiceId, Map<String, dynamic> data) async {
    isLoading.value = true;

    try {
      final response = await _apiService.patchRequest(
        '/api/invoices/$invoiceId',
        data: data,
        bearerToken: token,
      );

      if (response.isOk) {
        Get.snackbar(
          'Success',
          response.body['message'] ?? 'Invoice updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        await fetchInvoiceById(invoiceId);
        fetchInvoices(refresh: true);
        return true;
      } else {
        Get.snackbar(
          'Error',
          response.body['error'] ?? 'Failed to update invoice',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update invoice: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Delete invoice
  Future<bool> deleteInvoice(String invoiceId) async {
    isLoading.value = true;

    try {
      final response = await _apiService.deleteRequest(
        '/api/invoices/$invoiceId',
        bearerToken: token,
      );

      if (response.isOk) {
        Get.snackbar(
          'Success',
          response.body['message'] ?? 'Invoice deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        invoices.removeWhere((invoice) => invoice.id == invoiceId);
        return true;
      } else {
        Get.snackbar(
          'Error',
          response.body['error'] ?? 'Failed to delete invoice',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete invoice: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Download PDF
  Future<void> downloadInvoicePdf(String invoiceId) async {
    try {
      final baseUrl =
          _apiService.baseUrl ?? 'https://api-tekcastle-9360.onrender.com';
      final pdfUrl = '$baseUrl/api/invoices/$invoiceId/download';

      Get.snackbar(
        'Info',
        'PDF download link: $pdfUrl',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: buttonColor,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );

      // Note: For actual download, you may need to use url_launcher package
      // or implement a custom download handler based on your platform
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to get PDF URL: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Add invoice item
  void addInvoiceItem() {
    invoiceItems.add({
      'type': 'SERVICE',
      'description': '',
      'quantity': 1.0,
      'unitPrice': 0.0,
    });
  }

  // Remove invoice item
  void removeInvoiceItem(int index) {
    if (index >= 0 && index < invoiceItems.length) {
      invoiceItems.removeAt(index);
    }
  }

  // Update invoice item
  void updateInvoiceItem(int index, Map<String, dynamic> item) {
    if (index >= 0 && index < invoiceItems.length) {
      invoiceItems[index] = item;
    }
  }

  // Clear form
  void clearForm() {
    clientIdController.clear();
    complaintIdController.clear();
    reportTypeController.clear();
    dueDateController.clear();
    taxRateController.clear();
    discountController.clear();
    notesController.clear();
    termsController.clear();
    invoiceItems.clear();
    selectedDueDate.value = null;
    selectedReportTypeForm.value = '';
    selectedClient.value = null;
    clientSearchQuery.value = '';
    filteredClients.value = clients;
  }

  // Select due date (date only, no time)
  Future<void> selectDueDate(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: selectedDueDate.value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (selectedDate != null) {
      // Set time to end of day (23:59:59) for the selected date
      selectedDueDate.value = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        23,
        59,
        59,
      );
      dueDateController.text =
          '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
    }
  }
}
