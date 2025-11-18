import 'package:castle/Controlls/AuthController/AuthController.dart';
import 'package:castle/Model/client_detail_model/client_detail_model.dart';
import 'package:castle/Model/client_detail_model/data.dart';
import 'package:castle/Model/client_model/client_model.dart';
import 'package:castle/Model/client_model/datum.dart';
import 'package:castle/Services/ApiService.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class ClientRegisterController extends GetxController {
  late ClientDetailModel clientDetailModel = ClientDetailModel();
  ClientDetailsData clientDetails = ClientDetailsData();
  PhoneNumber number = PhoneNumber(isoCode: 'IN');
  // Text controllers
  bool isUpdate = false;
  final email = TextEditingController();
  final password = TextEditingController();
  final conformPass = TextEditingController();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final phone = TextEditingController();
  final clientName = TextEditingController();
  final clientAddress = TextEditingController();
  final clientPhone = TextEditingController();
  final clientEmail = TextEditingController();
  final contactPerson = TextEditingController();
  final ApiService _apiService = ApiService();
  late ClientModel clientModel = ClientModel();
  RxBool showSuggestions = false.obs;
  RxList<ClientData> clientData = <ClientData>[].obs;
  RxList<ClientData> filteredClients = <ClientData>[].obs;
  RxString searchText = ''.obs;
  int page = 1;
  RxBool isExistingClient = false.obs;
  RxString selectedClientId = ''.obs;
  RxBool isLoading = false.obs;
  Future createClient() async {
    final Map<String, dynamic> body = {
      "email": email.text.trim(),
      "password": password.text,
      "firstName": firstName.text.trim(),
      "lastName": lastName.text.trim(),
      "clientName": clientName.text.trim(),
      "clientAddress": clientAddress.text.trim(),
      "clientPhone": phone.text.trim(),
      "clientEmail": clientEmail.text.trim(),
      "contactPerson": contactPerson.text.trim()
    };
    isLoading.value = true;
    try {
      final response = await _apiService
          .postRequest('/api/v1/admin/clients', body, bearerToken: token);
      if (response.isOk) {
        print(response.body);
        selectedClientId.value = response.body['data']['id'];
        await getClientList();
        Get.snackbar("Success", "Successfully created");
      } else {
        print(response.body);
        Get.snackbar("Error", response.body['error']);
      }
    } catch (e) {
      print(e);
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  void fillClientData(ClientDetailsData client) {
    isUpdate = true;
    email.text = client.email ?? '';
    password.clear(); // usually not shown during edit
    conformPass.clear();
    // number.pho = client.phone;
    firstName.text = client.firstName ?? '';
    lastName.text = client.lastName ?? '';
    phone.text = client.phone?.toString() ?? '';
    clientName.text = client.clientName ?? '';
    clientAddress.text = client.clientAddress ?? '';
    clientPhone.text = client.phone?.toString() ?? '';
    clientEmail.text = client.clientEmail ?? '';
    contactPerson.text = client.contactPerson ?? '';
  }

  Future<ClientDetailsData?> getClientById(String clientId) async {
    final endpoint = "/api/v1/admin/clients/$clientId";
    // isLoading.value = true;
    try {
      final response =
          await _apiService.getRequest(endpoint, bearerToken: token);
      if (response.isOk) {
        clientDetailModel = ClientDetailModel.fromJson(response.body);
        return clientDetails = clientDetailModel.data!;
      } else {
        print(response.body);
        Get.snackbar("Error", "Something Error");
      }
    } catch (e) {
      print(e);
      rethrow;
    } finally {
      // isLoading.value = false;
    }
    return null;
  }

  Future updateClient(String clientId) async {
    final endpoint = "/api/v1/common/clients/$clientId";
    isLoading.value = true;
    final data = {
      "email": email.text.trim(),
      "password": password.text,
      "firstName": firstName.text.trim(),
      "lastName": lastName.text.trim(),
      "clientName": clientName.text.trim(),
      "clientAddress": clientAddress.text.trim(),
      "clientPhone": phone.text.trim(),
      "clientEmail": clientEmail.text.trim(),
      "contactPerson": contactPerson.text.trim()
    };
    try {
      final response = await _apiService.patchRequest(endpoint,
          data: data, bearerToken: token);
      if (response.isOk) {
        Get.snackbar("Success", 'Successfully updated');
        final updatedClient = ClientDetailsData.fromJson(response.body);
        clientDetails = updatedClient;
        update();
      } else {
        print(response.body);
        Get.snackbar("Error", "Something error please try later");
      }
    } catch (e) {
      print(e);
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future getClientList({String? search}) async {
    try {
      clientData.clear();
      int currentPage = 1;
      bool hasMore = true;
      const int limit = 100; // Load 100 per page

      while (hasMore) {
        final queryParams = <String, String>{
          'page': currentPage.toString(),
          'limit': limit.toString(),
          if (search != null && search.isNotEmpty) 'search': search,
        };
        final uri = Uri.parse('/api/v1/admin/clients')
            .replace(queryParameters: queryParams);

        final response = await _apiService.getRequest(
          uri.toString(),
          bearerToken: token,
        );

        if (response.isOk) {
          clientModel = ClientModel.fromJson(response.body);
          final newClients = clientModel.data ?? [];
          
          if (newClients.isEmpty || newClients.length < limit) {
            hasMore = false;
          }
          
          if (newClients.isNotEmpty) {
            clientData.addAll(newClients);
            currentPage++;
          } else {
            hasMore = false;
          }
        } else {
          hasMore = false;
          print(response.body);
          Get.snackbar("Error", response.body['error']);
        }
      }
      
      // Update filtered clients
      filteredClients.value = clientData;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future deleteClient(String userId) async {
    isLoading.value = true;
    try {
      final response = await _apiService
          .deleteRequest('/api/v1/admin/clients/$userId', bearerToken: token);
      if (response.isOk) {
        clearAllControllers();
        await getClientList();

        print(response.body);
        update();

        Get.back();
        Get.snackbar("Deleted", "Successfully deleted");
      } else {
        print(response.body);
      }
    } catch (e) {
      print(e);
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  void clearAllControllers() {
    print("cleaaaaaaaaaaaaaaaaaaaaaaaaaardddddddddddd");
    TextEditingController().clear();
    isUpdate = false;
    email.clear();
    password.clear();
    conformPass.clear();
    firstName.clear();
    lastName.clear();
    phone.clear();
    clientName.clear();
    clientAddress.clear();
    // clientCity.dispose();
    // clientState.dispose();
    // clientCountry.dispose();
    // clientPostalCode.dispose();
    clientPhone.clear();
    clientEmail.clear();
    contactPerson.clear();
  }

  void searchClients(String query) {
    searchText.value = query;
    if (query.isEmpty) {
      filteredClients.clear();
      showSuggestions.value = false;
    } else {
      filteredClients.value = clientData
          .where((client) =>
              (client.firstName ?? '')
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              (client.lastName ?? '')
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();
      showSuggestions.value = true;
    }
  }

  Future<void> fetchClientDetails(String clientId) async {
    Get.dialog(Center(
      child: CircularProgressIndicator(),
    ));
    try {
      final data = await getClientById(clientId); // your API call
      // Fill controllers
      if (data != null) {
        firstName.text = data.firstName ?? '';
        lastName.text = data.lastName ?? '';
        email.text = data.email ?? '';
        phone.text = data.phone ?? '';
        clientName.text = data.clientName ?? '';
        clientAddress.text = data.clientAddress ?? '';
        clientEmail.text = data.clientEmail ?? '';
        contactPerson.text = data.contactPerson ?? '';

        isExistingClient.value = true;
      }
      // disable fields
    } catch (e) {
      print(e);
      Get.snackbar("Error", "Failed to fetch client details");
    } finally {
      Get.back();
    }
  }

  void clearSelectedClient() {
    isExistingClient.value = false;
    selectedClientId.value = '';
    firstName.clear();
    lastName.clear();
    email.clear();
    phone.clear();
    clientName.clear();
    clientAddress.clear();
    contactPerson.clear();
    password.clear();
    showSuggestions.value = true;
  }

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    if (userDetailModel!.data!.role == "ADMIN") {
      await getClientList();
    }
  }
}
