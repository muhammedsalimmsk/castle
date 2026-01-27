import 'package:castle/Colors/Colors.dart';
import 'package:castle/Controlls/ClientController/ClientController.dart';
import 'package:castle/Controlls/ComplaintController/NewComplaintController/NewComplaintController.dart';
import 'package:castle/Controlls/EquipmentController/EquipmentController.dart';
import 'package:castle/Model/client_model/datum.dart';
import 'package:castle/Model/equipment_model/datum.dart';
import 'package:castle/Widget/CustomTextField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controlls/AuthController/AuthController.dart';

class CreateComplaintPage extends StatefulWidget {
  final String? equipmentId;
  final List<String>? readings;
  final String? routineName;

  const CreateComplaintPage({
    super.key,
    this.equipmentId,
    this.readings,
    this.routineName,
  });

  @override
  State<CreateComplaintPage> createState() => _CreateComplaintPageState();
}

class _CreateComplaintPageState extends State<CreateComplaintPage> {
  final NewComplaintController complaintController =
      Get.put(NewComplaintController());
  late ClientRegisterController clientController;
  late EquipmentController equipmentController;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final RxString selectedPriority = 'MEDIUM'.obs;
  final Rx<ClientData?> selectedClient = Rx<ClientData?>(null);
  final Rx<EquipmentDetailData?> selectedEquipment =
      Rx<EquipmentDetailData?>(null);
  final RxBool isLoadingEquipment = false.obs;
  final RxList<EquipmentDetailData> clientEquipment =
      <EquipmentDetailData>[].obs;

  @override
  void initState() {
    super.initState();
    // Initialize ClientController
    try {
      clientController = Get.find<ClientRegisterController>();
    } catch (e) {
      clientController = Get.put(ClientRegisterController());
    }
    // Initialize EquipmentController
    try {
      equipmentController = Get.find<EquipmentController>();
    } catch (e) {
      equipmentController = Get.put(EquipmentController());
    }
    // Ensure clients are loaded
    if (clientController.clientData.isEmpty) {
      clientController.getClientList();
    }

    // Pre-fill data if provided from routine details
    if (widget.equipmentId != null) {
      _prefillFromRoutine();
    }

    // Pre-fill description with readings if provided
    if (widget.readings != null && widget.readings!.isNotEmpty) {
      final readingsText =
          widget.readings!.map((reading) => '• $reading').join('\n');
      if (widget.routineName != null) {
        descriptionController.text =
            'Routine: ${widget.routineName}\n\nReadings:\n$readingsText';
      } else {
        descriptionController.text = 'Readings:\n$readingsText';
      }
    }
  }

  Future<void> _prefillFromRoutine() async {
    if (widget.equipmentId == null) return;

    try {
      // Fetch all equipment to find the one matching equipmentId
      final role = userDetailModel!.data!.role!.toLowerCase();
      final equipmentList = await equipmentController.getEquipmentDetail(role);

      if (equipmentList != null && equipmentList.isNotEmpty) {
        EquipmentDetailData equipment;
        try {
          equipment = equipmentList.firstWhere(
            (eq) => eq.id == widget.equipmentId,
          );
        } catch (e) {
          // Equipment not found in the list
          print('Equipment not found: ${widget.equipmentId}');
          return;
        }

        // Get clientId from equipment and fetch client
        if (equipment.clientId != null) {
          // Find client from the client list
          await clientController.getClientList();
          ClientData? client;
          try {
            client = clientController.clientData.firstWhere(
              (c) => c.id == equipment.clientId,
            );
          } catch (e) {
            // Client not found
            print('Client not found: ${equipment.clientId}');
          }

          if (client != null) {
            selectedClient.value = client;
            // Fetch equipment for this client to populate dropdown
            await fetchClientEquipment(client.id!);
          }
        }

        // Set selected equipment after fetching client equipment
        // This ensures the equipment is in the dropdown list
        if (clientEquipment.isNotEmpty) {
          try {
            selectedEquipment.value = clientEquipment.firstWhere(
              (eq) => eq.id == widget.equipmentId,
            );
          } catch (e) {
            // If equipment not in client's equipment list, still set it
            selectedEquipment.value = equipment;
          }
        } else {
          selectedEquipment.value = equipment;
        }
      }
    } catch (e) {
      print('Error pre-filling from routine: $e');
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  // Fetch equipment when client is selected
  Future<void> fetchClientEquipment(String clientId) async {
    isLoadingEquipment.value = true;
    selectedEquipment.value = null;
    try {
      final role = userDetailModel!.data!.role!.toLowerCase();
      final equipment = await equipmentController.getEquipmentDetail(
        role,
        clientId: clientId,
      );
      if (equipment != null && equipment.isNotEmpty) {
        clientEquipment.value = equipment;
      } else {
        clientEquipment.clear();
      }
    } catch (e) {
      print('Error fetching equipment: $e');
      clientEquipment.clear();
    } finally {
      isLoadingEquipment.value = false;
    }
  }

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
          'Create Complaint',
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
            Text(
              "Complaint Details",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: containerColor,
              ),
            ),
            const SizedBox(height: 24),

            // Client Selection Field
            Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: TextEditingController(
                        text: selectedClient.value != null
                            ? (selectedClient.value!.clientName ??
                                '${selectedClient.value!.firstName ?? ''} ${selectedClient.value!.lastName ?? ''}'
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
                            selectedClient.value != null
                                ? Icons.clear
                                : Icons.arrow_drop_down,
                            color: buttonColor,
                          ),
                          onPressed: () {
                            if (selectedClient.value != null) {
                              selectedClient.value = null;
                              selectedEquipment.value = null;
                              clientEquipment.clear();
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
                    if (selectedClient.value != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: buttonColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border:
                              Border.all(color: buttonColor.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle,
                                color: buttonColor, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    selectedClient.value!.clientName ??
                                        '${selectedClient.value!.firstName ?? ''} ${selectedClient.value!.lastName ?? ''}'
                                            .trim(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: containerColor,
                                    ),
                                  ),
                                  if (selectedClient.value!.clientEmail != null)
                                    Text(
                                      selectedClient.value!.clientEmail!,
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
                )),

            const SizedBox(height: 20),

            // Equipment Selection Field
            Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (selectedClient.value == null)
                      TextFormField(
                        controller: TextEditingController(text: ''),
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Equipment *',
                          hintText: 'Please select a client first',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: borderColor),
                          ),
                          prefixIcon: Icon(Icons.precision_manufacturing,
                              color: Colors.grey),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                      )
                    else if (isLoadingEquipment.value)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: buttonColor,
                              strokeWidth: 2,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              "Loading equipment...",
                              style: TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      )
                    else if (clientEquipment.isEmpty)
                      TextFormField(
                        controller: TextEditingController(text: 'No equipment found'),
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Equipment *',
                          hintText: 'No equipment found',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: borderColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey, width: 2),
                          ),
                          prefixIcon: Icon(Icons.precision_manufacturing,
                              color: Colors.grey),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                      )
                    else
                      DropdownButtonFormField<String>(
                        dropdownColor: backgroundColor,
                        value: selectedEquipment.value?.id,
                        decoration: InputDecoration(
                          labelText: 'Equipment *',
                          hintText: 'Select equipment',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: borderColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: buttonColor, width: 2),
                          ),
                          prefixIcon: Icon(Icons.precision_manufacturing,
                              color: buttonColor),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        items: clientEquipment.map((equipment) {
                          return DropdownMenuItem<String>(
                            value: equipment.id,
                            child: Text(
                              equipment.name ?? 'Unnamed Equipment',
                              style: TextStyle(color: containerColor),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            selectedEquipment.value =
                                clientEquipment.firstWhere(
                              (eq) => eq.id == value,
                            );
                          }
                        },
                      ),
                    if (selectedEquipment.value != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: buttonColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border:
                              Border.all(color: buttonColor.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle,
                                color: buttonColor, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                selectedEquipment.value!.name ??
                                    'Unnamed Equipment',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: containerColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                )),

            const SizedBox(height: 20),

            // Title Field
            CustomTextField(
              controller: titleController,
              hint: "Complaint Title *",
            ),

            const SizedBox(height: 20),

            // Description Field
            TextField(
              controller: descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: "Description *",
                labelStyle: TextStyle(color: subtitleColor),
                hintText: "Enter complaint description",
                hintStyle: TextStyle(color: subtitleColor),
                alignLabelWithHint: true,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: buttonColor, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: borderColor),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
              style: TextStyle(color: containerColor),
            ),

            const SizedBox(height: 20),

            // Priority Field
            Obx(() => DropdownButtonFormField<String>(
                  dropdownColor: backgroundColor,
                  value: selectedPriority.value,
                  decoration: InputDecoration(
                    labelText: 'Priority *',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: buttonColor, width: 2),
                    ),
                    prefixIcon: Icon(Icons.flag, color: buttonColor),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: ['LOW', 'MEDIUM', 'HIGH', 'URGENT'].map((priority) {
                    return DropdownMenuItem<String>(
                      value: priority,
                      child: Text(
                        priority,
                        style: TextStyle(color: containerColor),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      selectedPriority.value = value;
                    }
                  },
                )),

            const SizedBox(height: 32),

            // Submit Button
            Obx(() => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: complaintController.isLoading.value
                        ? null
                        : () async {
                            if (selectedClient.value == null) {
                              Get.snackbar(
                                "Error",
                                "Please select a client",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                              return;
                            }
                            if (selectedEquipment.value == null) {
                              Get.snackbar(
                                "Error",
                                "Please select an equipment",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                              return;
                            }
                            if (titleController.text.trim().isEmpty) {
                              Get.snackbar(
                                "Error",
                                "Please enter a title",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                              return;
                            }
                            if (descriptionController.text.trim().isEmpty) {
                              Get.snackbar(
                                "Error",
                                "Please enter a description",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                              return;
                            }

                            final role =
                                userDetailModel!.data!.role!.toLowerCase();
                            await complaintController.complaintRegister(
                              role,
                              titleController.text.trim(),
                              descriptionController.text.trim(),
                              selectedPriority.value,
                              selectedEquipment.value!.id!,
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      disabledBackgroundColor: buttonColor.withOpacity(0.5),
                    ),
                    child: complaintController.isLoading.value
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            'Submit Complaint',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                )),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _showClientSearchDialog() {
    final searchController = TextEditingController();
    clientController.searchText.value = '';
    // Initialize filteredClients with all clients when dialog opens
    if (clientController.filteredClients.isEmpty &&
        clientController.clientData.isNotEmpty) {
      clientController.filteredClients.value = clientController.clientData;
    }

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.all(20),
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
                  if (value.isEmpty) {
                    // Show all clients when search is cleared
                    clientController.filteredClients.value =
                        clientController.clientData;
                    clientController.searchText.value = '';
                  } else {
                    clientController.searchClients(value);
                  }
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Obx(() {
                  if (clientController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Use clientData when search is empty, filteredClients when searching
                  final clientsToShow =
                      clientController.searchText.value.isEmpty
                          ? clientController.clientData
                          : clientController.filteredClients;

                  if (clientsToShow.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.business_outlined,
                            size: 64,
                            color: subtitleColor,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "No clients found",
                            style: TextStyle(
                              color: containerColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Try searching with a different name",
                            style: TextStyle(
                              color: subtitleColor,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: clientsToShow.length,
                    itemBuilder: (context, index) {
                      final client = clientsToShow[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: buttonColor.withOpacity(0.1),
                          child: Icon(
                            Icons.business,
                            color: buttonColor,
                          ),
                        ),
                        title: Text(
                          client.clientName ??
                              '${client.firstName ?? ''} ${client.lastName ?? ''}'
                                  .trim(),
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
                        trailing: selectedClient.value?.id == client.id
                            ? Icon(Icons.check_circle, color: buttonColor)
                            : Icon(Icons.chevron_right, color: subtitleColor),
                        onTap: () {
                          selectedClient.value = client;
                          if (client.id != null) {
                            fetchClientEquipment(client.id!);
                          }
                          Get.back();
                        },
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
}
