import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Colors/Colors.dart';
import '../../Controlls/AuthController/AuthController.dart';
import '../../Controlls/EquipmentController/EquipmentController.dart';
import '../../Controlls/WorkersController/WorkerController.dart';
import '../../Widget/CustomTextField.dart';

class NewEquipmentsRequest extends StatelessWidget {
  final String clientId;
  NewEquipmentsRequest({super.key, required this.clientId});

  final _formKey = GlobalKey<FormState>();

  InputDecoration customInputDecoration({
    required String label,
    IconData? icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: label,
      hintStyle: TextStyle(color: subtitleColor),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      suffixIcon: icon != null ? Icon(icon, color: shadeColor) : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: buttonColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EquipmentController());
    final workerController = Get.put(WorkerController());

    if (controller.equipType.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.getEquipmentTypes();
      });
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        surfaceTintColor: backgroundColor,
        centerTitle: true,
        backgroundColor: backgroundColor,
        title: const Text(
          "New Equipment",
          style: TextStyle(color: containerColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Step 2 of 2",
                  style: GoogleFonts.poppins(
                      fontSize: 12, color: Colors.grey[700]),
                ),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                minHeight: 10,
                value: 1,
                color: buttonColor,
                backgroundColor: progressBackround,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: controller.nameController,
                hint: "Name",
                validator: (value) =>
                    value!.isEmpty ? 'Please enter name' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: controller.modelController,
                hint: "Model",
                validator: (value) =>
                    value!.isEmpty ? 'Please enter model' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: controller.serialNumberController,
                hint: "Serial Number",
                validator: (value) =>
                    value!.isEmpty ? 'Please enter serial number' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: controller.manufacturerController,
                hint: "Manufacturer",
                validator: (value) =>
                    value!.isEmpty ? 'Please enter manufacturer' : null,
              ),
              const SizedBox(height: 16),
              Obx(() => TextFormField(
                    readOnly: true,
                    validator: (_) => controller.installationDate.value == null
                        ? "Please select installation date"
                        : null,
                    controller: TextEditingController(
                      text: controller.installationDate.value != null
                          ? controller.installationDate.value!
                              .toLocal()
                              .toString()
                              .split(' ')[0]
                          : '',
                    ),
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate:
                            controller.installationDate.value ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        controller.installationDate.value = picked;
                      }
                    },
                    decoration: customInputDecoration(
                        label: "Installation Date", icon: Icons.calendar_today),
                  )),
              const SizedBox(height: 16),
              Obx(() => TextFormField(
                    readOnly: true,
                    validator: (_) => controller.warrantyExpiry.value == null
                        ? "Please select warranty expiry"
                        : null,
                    controller: TextEditingController(
                      text: controller.warrantyExpiry.value != null
                          ? controller.warrantyExpiry.value!
                              .toLocal()
                              .toString()
                              .split(' ')[0]
                          : '',
                    ),
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate:
                            controller.warrantyExpiry.value ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        controller.warrantyExpiry.value = picked;
                      }
                    },
                    decoration: customInputDecoration(
                        label: "Warranty Expiry", icon: Icons.calendar_today),
                  )),
              const SizedBox(height: 16),
              Obx(() => DropdownButtonFormField<String>(
                    dropdownColor: backgroundColor,
                    value: controller.equipmentTypeId.value.isEmpty
                        ? null
                        : controller.equipmentTypeId.value,
                    isExpanded: true,
                    decoration:
                        customInputDecoration(label: "Select Equipment Type"),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please select equipment type'
                        : null,
                    items: controller.equipType
                        .where((type) => type.id != null && type.id!.isNotEmpty)
                        .map((type) {
                      return DropdownMenuItem<String>(
                        value: type.id!,
                        child: Text(type.name ?? 'Unnamed'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      controller.equipmentTypeId.value = value ?? '';
                      controller.selectedEquipmentTypeName.value = controller
                              .equipType
                              .firstWhereOrNull((e) => e.id == value)
                              ?.name ??
                          '';
                    },
                  )),
              const SizedBox(height: 16),
              Obx(() => DropdownButtonFormField<String>(
                    dropdownColor: backgroundColor,
                    value: controller.locationType.value.isEmpty
                        ? null
                        : controller.locationType.value,
                    isExpanded: true,
                    decoration:
                        customInputDecoration(label: "Select Location Type"),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please select location type'
                        : null,
                    items: const [
                      DropdownMenuItem(
                          value: "Internal", child: Text("Internal")),
                      DropdownMenuItem(
                          value: "External", child: Text("External")),
                    ],
                    onChanged: (value) {
                      controller.locationType.value = value ?? '';
                    },
                  )),
              const SizedBox(height: 16),
              CustomTextField(
                hint: "Location Remarks",
                controller: controller.locationRemarksController,
              ),
              const SizedBox(
                height: 16,
              ),
              Obx(() => DropdownButtonFormField<String>(
                    dropdownColor: backgroundColor,
                    value: controller.selectedSupervisorId.value.isEmpty
                        ? null
                        : controller.selectedSupervisorId.value,
                    isExpanded: true,
                    decoration:
                        customInputDecoration(label: "Select Supervisor"),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please select supervisor'
                        : null,
                    items: workerController.workerList.map((cat) {
                      return DropdownMenuItem<String>(
                        value: cat.id,
                        child: Text(
                            "${cat.firstName ?? 'Unnamed'} ${cat.lastName ?? 'Unnamed'}"),
                      );
                    }).toList(),
                    onChanged: (value) {
                      controller.selectedSupervisorId.value = value ?? '';
                      print(controller.selectedSupervisorId.value);
                    },
                  )),
              const SizedBox(height: 16),
              Obx(() => DropdownButtonFormField<String>(
                    dropdownColor: backgroundColor,
                    value: controller.categoryId.value.isEmpty
                        ? null
                        : controller.categoryId.value,
                    isExpanded: true,
                    decoration: customInputDecoration(label: "Select Category"),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please select category'
                        : null,
                    items: controller.catList.map((cat) {
                      return DropdownMenuItem<String>(
                        value: cat.id,
                        child: Text(cat.name ?? 'Unnamed'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      controller.categoryId.value = value ?? '';
                      controller.subCategoryId!.value = '';
                      controller.selectedSubCategoryName.value = '';
                      controller.getSubCategories(categoryId: value);
                    },
                  )),
              const SizedBox(height: 16),
              Obx(() => TextFormField(
                    readOnly: true,
                    validator: (_) =>
                        controller.selectedSubCategoryName.value.isEmpty
                            ? 'Please select subcategory'
                            : null,
                    controller: TextEditingController(
                      text: controller.selectedSubCategoryName.value,
                    ),
                    onTap: () {
                      if (controller.categoryId.value.isNotEmpty) {
                        _showSubCategoryDialog(context, controller);
                      } else {
                        Get.snackbar("Select Category",
                            "Please select a category first.");
                      }
                    },
                    decoration: customInputDecoration(
                        label: "Select Subcategory",
                        icon: Icons.arrow_drop_down),
                  )),
              const SizedBox(height: 24),
              Obx(() => controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : InkWell(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          final id = userDetailModel!.data!.role == "ADMIN"
                              ? clientId
                              : userDetailModel!.data!.id;
                          controller.createEquipment(id);
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: buttonColor,
                        ),
                        child: const Center(
                          child: Text(
                            "Submit",
                            style: TextStyle(
                              color: backgroundColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSupervisorDropdown(WorkerController workerController,
      EquipmentController equipmentController) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButton<String>(
        dropdownColor: backgroundColor,
        isExpanded: true,
        value: equipmentController.selectedSupervisorId.value.isEmpty
            ? null
            : equipmentController.selectedSupervisorId.value,
        hint: const Text('Select Team Lead'),
        underline: const SizedBox(),
        items: workerController.workersDataByDep.map((worker) {
          return DropdownMenuItem<String>(
            value: worker.id,
            child: Text("${worker.firstName} ${worker.lastName}"),
          );
        }).toList(),
        onChanged: (value) {
          equipmentController.selectedSupervisorId.value = value ?? '';
        },
      ),
    );
  }

  void _showSubCategoryDialog(
      BuildContext context, EquipmentController controller) async {
    controller.isSubCategoryLoading.value = true;
    await controller.getSubCategories(categoryId: controller.categoryId.value);
    controller.isSubCategoryLoading.value = false;

    Get.dialog(
      Dialog(
        child: Container(
          width: double.infinity,
          height: 500,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Search Subcategory",
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (query) {
                  controller.isSubCategoryLoading.value = true;
                  Future.delayed(const Duration(milliseconds: 300), () async {
                    await controller.getSubCategories(
                      search: query,
                      categoryId: controller.categoryId.value,
                    );
                    controller.isSubCategoryLoading.value = false;
                  });
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Obx(() {
                  if (controller.isSubCategoryLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.subCatData.isEmpty) {
                    return const Center(child: Text("No subcategories found"));
                  }

                  return NotificationListener<ScrollNotification>(
                    onNotification: (scrollNotification) {
                      if (scrollNotification.metrics.pixels ==
                              scrollNotification.metrics.maxScrollExtent &&
                          !controller.isLoadingMore.value &&
                          controller.hasMoreData.value) {
                        controller.getSubCategories(
                          search: controller.lastSearch,
                          categoryId: controller.lastCategoryId,
                          isLoadMore: true,
                        );
                      }
                      return true;
                    },
                    child: ListView.builder(
                      itemCount: controller.subCatData.length +
                          (controller.isLoadingMore.value ? 1 : 0),
                      itemBuilder: (_, index) {
                        if (index < controller.subCatData.length) {
                          final subCat = controller.subCatData[index];
                          return ListTile(
                            title: Text(subCat.name ?? ''),
                            onTap: () {
                              controller.subCategoryId!.value = subCat.id ?? '';
                              controller.selectedSubCategoryName.value =
                                  subCat.name ?? '';
                              Get.back();
                            },
                          );
                        } else {
                          return const Padding(
                            padding: EdgeInsets.all(12),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                      },
                    ),
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
