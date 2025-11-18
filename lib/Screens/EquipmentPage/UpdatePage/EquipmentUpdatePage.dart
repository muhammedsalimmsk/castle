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
      hintStyle: TextStyle(color: subtitleColor, fontSize: 14),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      prefixIcon: icon != null
          ? Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: buttonColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: buttonColor, size: 20),
            )
          : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      filled: true,
      fillColor: backgroundColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: dividerColor, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: dividerColor, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: buttonColor, width: 2),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 8),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: containerColor,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EquipmentController());

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        surfaceTintColor: backgroundColor,
        elevation: 0,
        backgroundColor: backgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: containerColor),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Update Equipment",
          style: TextStyle(
            color: containerColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Basic Information Section
              _sectionTitle('Basic Information'),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: dividerColor,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: cardShadowColor.withOpacity(0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    CustomTextField(
                      controller: controller.nameController,
                      hint: "Name",
                      icon: Icons.precision_manufacturing,
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter name' : null,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: controller.modelController,
                      hint: "Model",
                      icon: Icons.model_training,
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter model' : null,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: controller.serialNumberController,
                      hint: "Serial Number",
                      icon: Icons.qr_code,
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter serial number' : null,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: controller.manufacturerController,
                      hint: "Manufacturer",
                      icon: Icons.business,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Date Information Section
              _sectionTitle('Date Information'),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: dividerColor,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: cardShadowColor.withOpacity(0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  children: [
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
                          style: TextStyle(color: containerColor, fontSize: 15),
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: controller.installationDate.value ??
                                  DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              controller.installationDate.value = picked;
                            }
                          },
                          validator: (_) =>
                              controller.installationDate.value == null
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
                          style: TextStyle(color: containerColor, fontSize: 15),
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: controller.warrantyExpiry.value ??
                                  DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              controller.warrantyExpiry.value = picked;
                            }
                          },
                          validator: (_) =>
                              controller.warrantyExpiry.value == null
                                  ? "Please select warranty expiry"
                                  : null,
                          decoration: customInputDecoration(
                            label: "Warranty Expiry",
                            icon: Icons.verified,
                          ),
                        )),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Category & Location Section
              _sectionTitle('Category & Location'),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: dividerColor,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: cardShadowColor.withOpacity(0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Obx(() => DropdownButtonFormField<String>(
                          value: controller.equipmentTypeId.value.isEmpty
                              ? null
                              : controller.equipmentTypeId.value,
                          isExpanded: true,
                          decoration: customInputDecoration(
                              label: "Select Equipment Type",
                              icon: Icons.type_specimen),
                          style: TextStyle(color: containerColor, fontSize: 15),
                          dropdownColor: backgroundColor,
                          icon: Icon(Icons.keyboard_arrow_down,
                              color: buttonColor),
                          validator: (value) =>
                              value == null || value.isEmpty
                                  ? 'Please select equipment type'
                                  : null,
                          items: controller.equipType.map((type) {
                            return DropdownMenuItem<String>(
                              value: type.id,
                              child: Text(
                                type.name ?? 'Unnamed',
                                style: TextStyle(color: containerColor),
                              ),
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
                          decoration: customInputDecoration(
                              label: "Select Location Type",
                              icon: Icons.location_on),
                          style: TextStyle(color: containerColor, fontSize: 15),
                          dropdownColor: backgroundColor,
                          icon: Icon(Icons.keyboard_arrow_down,
                              color: buttonColor),
                          validator: (value) =>
                              value == null || value.isEmpty
                                  ? 'Please select location type'
                                  : null,
                          items: [
                            DropdownMenuItem<String>(
                              value: "INTERNAL",
                              child: Text(
                                "Internal",
                                style: TextStyle(color: containerColor),
                              ),
                            ),
                            DropdownMenuItem<String>(
                              value: "EXTERNAL",
                              child: Text(
                                "External",
                                style: TextStyle(color: containerColor),
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            controller.locationType.value = value ?? '';
                          },
                        )),
                    const SizedBox(height: 16),
                    CustomTextField(
                      hint: "Location Remarks",
                      controller: controller.locationRemarksController,
                      icon: Icons.note,
                    ),
                    const SizedBox(height: 16),
                    Obx(() => DropdownButtonFormField<String>(
                          value: controller.categoryId.value.isEmpty
                              ? null
                              : controller.categoryId.value,
                          isExpanded: true,
                          decoration: customInputDecoration(
                              label: "Category", icon: Icons.category),
                          style: TextStyle(color: containerColor, fontSize: 15),
                          dropdownColor: backgroundColor,
                          icon: Icon(Icons.keyboard_arrow_down,
                              color: buttonColor),
                          validator: (value) =>
                              value == null || value.isEmpty
                                  ? 'Please select category'
                                  : null,
                          items: controller.catList.map((cat) {
                            return DropdownMenuItem<String>(
                              value: cat.id,
                              child: Text(
                                cat.name ?? 'Unnamed',
                                style: TextStyle(color: containerColor),
                              ),
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
                            text: controller.selectedSubCategoryName.value,
                          ),
                          style: TextStyle(color: containerColor, fontSize: 15),
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
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Update Button
              Obx(() => controller.isLoading.value
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(buttonColor),
                        ),
                      ),
                    )
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          foregroundColor: backgroundColor,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                          shadowColor: buttonColor.withOpacity(0.3),
                        ),
                        icon: const Icon(Icons.update, size: 22),
                        label: const Text(
                          "Update Equipment",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            controller.updateEquipment(equipmentId);
                          }
                        },
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
      Dialog(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Select Subcategory",
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
              Flexible(
                child: Obx(() {
                  if (controller.isSubCategoryLoading.value) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(buttonColor),
                        ),
                      ),
                    );
                  }

                  if (controller.subCatData.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.category_outlined,
                                size: 48, color: subtitleColor),
                            const SizedBox(height: 16),
                            Text(
                              "No subcategories found",
                              style: TextStyle(
                                color: subtitleColor,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.subCatData.length,
                    itemBuilder: (context, index) {
                      final subCat = controller.subCatData[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: searchBackgroundColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: dividerColor,
                            width: 1,
                          ),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: buttonColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.category,
                              color: buttonColor,
                              size: 20,
                            ),
                          ),
                          title: Text(
                            subCat.name ?? '',
                            style: TextStyle(
                              color: containerColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          onTap: () {
                            controller.subCategoryId!.value = subCat.id ?? '';
                            controller.selectedSubCategoryName.value =
                                subCat.name ?? '';
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
}
