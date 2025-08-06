import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Colors/Colors.dart';
import '../../../Controlls/EquipmentController/EquipmentController.dart';
import '../../../Widget/CustomTextField.dart';

class UpdateEquipmentPage extends StatelessWidget {
  final String equipmentId;

  UpdateEquipmentPage({
    super.key,
    required this.equipmentId,
  });

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

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        centerTitle: true,
        title: const Text(
          "Update Equipment",
          style: TextStyle(color: containerColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
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
              ),
              const SizedBox(height: 16),
              Obx(() => TextFormField(
                    readOnly: true,
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
                    validator: (_) => controller.installationDate.value == null
                        ? "Please select installation date"
                        : null,
                    decoration: customInputDecoration(
                      label: "Installation Date",
                      icon: Icons.calendar_today,
                    ),
                  )),
              const SizedBox(height: 16),
              Obx(() => TextFormField(
                    readOnly: true,
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
                    validator: (_) => controller.warrantyExpiry.value == null
                        ? "Please select warranty expiry"
                        : null,
                    decoration: customInputDecoration(
                      label: "Warranty Expiry",
                      icon: Icons.calendar_today,
                    ),
                  )),
              const SizedBox(height: 16),
              Obx(() => DropdownButtonFormField<String>(
                    value: controller.equipmentTypeId.value.isEmpty
                        ? null
                        : controller.equipmentTypeId.value,
                    isExpanded: true,
                    decoration:
                        customInputDecoration(label: "Select Equipment Type"),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please select equipment type'
                        : null,
                    items: controller.equipType.map((type) {
                      return DropdownMenuItem<String>(
                        value: type.id,
                        child: Text(type.name ?? 'Unnamed'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      controller.equipmentTypeId.value = value ?? '';
                    },
                  )),
              const SizedBox(height: 16),
              Obx(() => DropdownButtonFormField<String>(
                    value: controller.locationType.value.isEmpty
                        ? "INTERNAL"
                        : controller.locationType.value,
                    isExpanded: true,
                    decoration:
                        customInputDecoration(label: "Select Location Type"),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please select location type'
                        : null,
                    items: const [
                      DropdownMenuItem(
                          value: "INTERNAL", child: Text("Internal")),
                      DropdownMenuItem(
                          value: "EXTERNAL", child: Text("External")),
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
              const SizedBox(height: 16),
              Obx(() => DropdownButtonFormField<String>(
                    value: controller.categoryId.value.isEmpty
                        ? null
                        : controller.categoryId.value,
                    isExpanded: true,
                    decoration: customInputDecoration(label: "Category"),
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
                      controller.getSubCategories(categoryId: value);
                    },
                  )),
              const SizedBox(height: 16),
              Obx(() => TextFormField(
                    readOnly: true,
                    controller: TextEditingController(
                      text: controller.selectedSubCategoryName.value ?? '',
                    ),
                    validator: (_) =>
                        controller.selectedSubCategoryName.value.isEmpty
                            ? "Please select subcategory"
                            : null,
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
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        minimumSize: const Size.fromHeight(50),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          controller.updateEquipment(equipmentId);
                        }
                      },
                      child: const Text(
                        "Update Equipment",
                        style: TextStyle(
                            color: backgroundColor,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
            ],
          ),
        ),
      ),
    );
  }

  void _showSubCategoryDialog(
      BuildContext context, EquipmentController controller) {
    controller.getSubCategories(categoryId: controller.categoryId.value);

    Get.dialog(
      AlertDialog(
        title: const Text("Select Subcategory"),
        content: Obx(() {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: controller.subCatData.map((subCat) {
              return ListTile(
                title: Text(subCat.name ?? ''),
                onTap: () {
                  controller.subCategoryId!.value = subCat.id ?? '';
                  controller.selectedSubCategoryName.value = subCat.name ?? '';
                  Get.back();
                },
              );
            }).toList(),
          );
        }),
      ),
    );
  }
}
