import 'dart:io';
import 'package:castle/Colors/Colors.dart';
import 'package:castle/Controlls/AuthController/AuthController.dart';
import 'package:castle/Controlls/ClientController/ClientController.dart';
import 'package:castle/Model/invoice_model/invoice_model.dart';
import 'package:castle/Model/invoice_model/invoice_data.dart';
import 'package:castle/Model/client_model/datum.dart';
import 'package:castle/Model/complaint_model/complaint_model.dart';
import 'package:castle/Model/complaint_model/datum.dart';
import 'package:castle/Model/requested_parts_model/requested_parts_model.dart';
import 'package:castle/Model/requested_parts_model/datum.dart';
import 'package:castle/Services/ApiService.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

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

  // Complaint selection
  RxList<ComplaintDetails> complaints = <ComplaintDetails>[].obs;
  Rx<ComplaintDetails?> selectedComplaint = Rx<ComplaintDetails?>(null);
  RxString complaintSearchQuery = ''.obs;
  RxList<ComplaintDetails> filteredComplaints = <ComplaintDetails>[].obs;
  RxBool isLoadingComplaints = false.obs;

  // Parts details (part requests with nested part data)
  RxList<RequestedParts> partsDetails = <RequestedParts>[].obs;
  RxBool isLoadingParts = false.obs;

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
      // Fetch complaints for the selected client
      fetchComplaints(clientId: client.id);
    } else {
      clientIdController.clear();
      // Clear complaints when client is deselected
      complaints.clear();
      filteredComplaints.clear();
      selectedComplaint.value = null;
      partsDetails.clear();
    }
  }

  // Fetch complaints (optionally filtered by clientId)
  Future<void> fetchComplaints({String? clientId}) async {
    if (isLoadingComplaints.value) return;

    isLoadingComplaints.value = true;
    try {
      final role = userDetailModel?.data?.role?.toLowerCase() ?? 'admin';
      String endpoint = '/api/v1/$role/complaints?page=1&limit=100';

      // Add clientId to endpoint if provided
      if (clientId != null && clientId.isNotEmpty) {
        endpoint += '&clientId=$clientId';
      }

      final response =
          await _apiService.getRequest(endpoint, bearerToken: token);

      if (response.isOk) {
        final model = ComplaintModel.fromJson(response.body);
        complaints.value = model.data ?? [];
        filteredComplaints.value = complaints;
      } else {
        print('Error fetching complaints: ${response.body}');
        Get.snackbar(
          'Error',
          'Failed to fetch complaints',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error fetching complaints: $e');
      Get.snackbar(
        'Error',
        'Failed to fetch complaints: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingComplaints.value = false;
    }
  }

  // Search complaints
  void searchComplaints(String query) {
    complaintSearchQuery.value = query;
    if (query.isEmpty) {
      filteredComplaints.value = complaints;
    } else {
      filteredComplaints.value = complaints.where((complaint) {
        final title = (complaint.title ?? '').toLowerCase();
        final description = (complaint.description ?? '').toLowerCase();
        final id = (complaint.id ?? '').toLowerCase();
        final searchLower = query.toLowerCase();
        return title.contains(searchLower) ||
            description.contains(searchLower) ||
            id.contains(searchLower);
      }).toList();
    }
  }

  // Select complaint
  void selectComplaint(ComplaintDetails? complaint) {
    selectedComplaint.value = complaint;
    if (complaint != null) {
      complaintIdController.text = complaint.id ?? '';
      // Fetch parts details for the selected complaint
      fetchPartsDetailsByComplaintId(complaint.id ?? '');
    } else {
      complaintIdController.clear();
      partsDetails.clear();
    }
  }

  // Fetch parts details by complaint ID
  Future<void> fetchPartsDetailsByComplaintId(String complaintId) async {
    if (complaintId.isEmpty) {
      partsDetails.clear();
      return;
    }

    if (isLoadingParts.value) return;

    isLoadingParts.value = true;
    try {
      final role = userDetailModel?.data?.role?.toLowerCase() ?? 'admin';
      final endpoint = '/api/v1/$role/part-requests/complaint/$complaintId';

      final response =
          await _apiService.getRequest(endpoint, bearerToken: token);

      if (response.isOk) {
        final model = RequestedPartsModel.fromJson(response.body);
        partsDetails.value = model.data ?? [];
      } else {
        print('Error fetching parts details: ${response.body}');
        partsDetails.clear();
        // Don't show error snackbar as this is optional information
      }
    } catch (e) {
      print('Error fetching parts details: $e');
      partsDetails.clear();
    } finally {
      isLoadingParts.value = false;
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
        '/api/v1/reports/invoices/$invoiceId',
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
        '/api/v1/reports/invoices/$invoiceId',
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
        '/api/v1/reports/invoices/$invoiceId',
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
      isLoading.value = true;

      // Check and request storage permission
      if (Platform.isAndroid) {
        // Check current permission status
        PermissionStatus storageStatus = await Permission.storage.status;

        // If not granted, request it
        if (!storageStatus.isGranted) {
          storageStatus = await Permission.storage.request();
        }

        // If still not granted, check if it's permanently denied
        if (!storageStatus.isGranted) {
          if (storageStatus.isPermanentlyDenied) {
            isLoading.value = false;
            _showPermissionDialog();
            return;
          }

          // Try manage external storage for Android 11+ (API 30+)
          PermissionStatus manageStorageStatus =
              await Permission.manageExternalStorage.status;
          if (!manageStorageStatus.isGranted) {
            manageStorageStatus =
                await Permission.manageExternalStorage.request();
          }

          // If both permissions are denied, show dialog
          if (!manageStorageStatus.isGranted) {
            isLoading.value = false;
            if (manageStorageStatus.isPermanentlyDenied) {
              _showPermissionDialog();
            } else {
              Get.snackbar(
                'Permission Required',
                'Storage permission is required to download files',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.orange,
                colorText: Colors.white,
              );
            }
            return;
          }
        }
      }

      final baseUrl =
          _apiService.baseUrl ?? 'https://api-tekcastle-9360.onrender.com';
      final pdfUrl = '$baseUrl/api/v1/reports/invoices/$invoiceId/download';

      // Get download directory
      Directory? downloadDir;
      if (Platform.isAndroid) {
        // For Android, use external storage downloads directory
        final externalDir = await getExternalStorageDirectory();
        if (externalDir != null) {
          // Navigate to Downloads folder
          final basePath = externalDir.path.split('Android')[0];
          downloadDir = Directory('$basePath/Download');
          if (!await downloadDir.exists()) {
            // Try alternative path
            downloadDir = Directory('$basePath/Downloads');
            if (!await downloadDir.exists()) {
              // Create Download directory if it doesn't exist
              downloadDir = Directory('$basePath/Download');
              await downloadDir.create(recursive: true);
            }
          }
        }
      } else if (Platform.isIOS) {
        // For iOS, use application documents directory
        downloadDir = await getApplicationDocumentsDirectory();
      } else {
        // For other platforms (Windows, macOS, Linux)
        // Try to get Downloads directory, fallback to Documents
        final appDocDir = await getApplicationDocumentsDirectory();
        Directory? platformDownloadDir;
        if (Platform.isWindows) {
          final userProfile = Platform.environment['USERPROFILE'] ?? '';
          platformDownloadDir = Directory('$userProfile\\Downloads');
        } else if (Platform.isMacOS || Platform.isLinux) {
          final userHome = Platform.environment['HOME'] ?? '';
          platformDownloadDir = Directory('$userHome/Downloads');
        }

        // Use platform download dir if it exists, otherwise use app documents
        if (platformDownloadDir != null && await platformDownloadDir.exists()) {
          downloadDir = platformDownloadDir;
        } else {
          downloadDir = appDocDir;
        }
      }

      if (downloadDir == null) {
        throw Exception('Could not access download directory');
      }

      // Create filename
      final fileName = 'invoice_$invoiceId.pdf';
      final filePath = '${downloadDir.path}/$fileName';

      // Download file using Dio
      final dio = Dio();
      final response = await dio.download(
        pdfUrl,
        filePath,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) => status! < 500,
        ),
        onReceiveProgress: (received, total) {
          // Progress tracking can be added here if needed
          // final progress = (received / total * 100).toStringAsFixed(0);
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          'Success',
          'Invoice PDF downloaded to Downloads folder',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      } else {
        throw Exception('Download failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Download error: $e');
      Get.snackbar(
        'Error',
        'Failed to download invoice PDF: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Show permission dialog
  void _showPermissionDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Storage Permission Required',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: containerColor,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          'Storage permission is required to download invoice PDFs to your device. Please enable it in the app settings.',
          style: TextStyle(
            fontSize: 14,
            color: containerColor,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: subtitleColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              await openAppSettings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text(
              'Open Settings',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: true,
    );
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
    // Use selectClient to properly clear client and related data
    selectClient(null);
    clientSearchQuery.value = '';
    filteredClients.value = clients;
    complaintSearchQuery.value = '';
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
