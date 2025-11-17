import 'package:castle/Controlls/PartsController/PartsController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Colors/Colors.dart';

class PartRegisterPage extends StatelessWidget {
  final formKey = GlobalKey<FormState>();

  // TextEditingControllers for each field
  final partName = TextEditingController();
  final partNumber = TextEditingController();
  final description = TextEditingController();
  final category = TextEditingController();
  final unit = TextEditingController();
  final currentStock = TextEditingController();
  final minStockLevel = TextEditingController();
  final maxStockLevel = TextEditingController();
  final unitPrice = TextEditingController();
  final supplier = TextEditingController();
  final location = TextEditingController();
  final PartsController controller = Get.find();
  PartRegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
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
          'Add New Part',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: containerColor,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            // Modern Header Section
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              decoration: BoxDecoration(
                color: backgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: cardShadowColor.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          buttonColor,
                          buttonColor.withOpacity(0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: buttonColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.add_circle_outline,
                      color: backgroundColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Create New Part",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: containerColor,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Fill in the details below",
                          style: TextStyle(
                            fontSize: 14,
                            color: subtitleColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Form Fields
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Basic Information Section
                    _sectionTitle('Basic Information'),
                    CustomTextField(
                      controller: partName,
                      hint: "Part Name",
                      validator: _requiredValidator,
                      icon: Icons.precision_manufacturing_rounded,
                    ),
                    CustomTextField(
                      controller: partNumber,
                      hint: "Part Number",
                      validator: _requiredValidator,
                      icon: Icons.confirmation_number_outlined,
                    ),
                    CustomTextField(
                      controller: category,
                      hint: "Category",
                      validator: _requiredValidator,
                      icon: Icons.category_outlined,
                    ),
                    CustomTextField(
                      controller: description,
                      hint: "Description",
                      maxLines: 3,
                      validator: _requiredValidator,
                      icon: Icons.description_outlined,
                    ),
                    const SizedBox(height: 24),
                    // Stock Information Section
                    _sectionTitle('Stock Information'),
                    CustomTextField(
                      controller: unit,
                      hint: "Unit (e.g., pcs, kg)",
                      validator: _requiredValidator,
                      icon: Icons.straighten,
                    ),
                    CustomTextField(
                      controller: currentStock,
                      hint: "Current Stock",
                      keyboardType: TextInputType.number,
                      validator: _numberValidator,
                      icon: Icons.inventory_2_rounded,
                    ),
                    CustomTextField(
                      controller: minStockLevel,
                      hint: "Minimum Stock Level",
                      keyboardType: TextInputType.number,
                      validator: _numberValidator,
                      icon: Icons.trending_down_rounded,
                    ),
                    CustomTextField(
                      controller: maxStockLevel,
                      hint: "Maximum Stock Level",
                      keyboardType: TextInputType.number,
                      validator: _numberValidator,
                      icon: Icons.trending_up_rounded,
                    ),
                    const SizedBox(height: 24),
                    // Pricing & Supplier Section
                    _sectionTitle('Pricing & Supplier'),
                    CustomTextField(
                      controller: unitPrice,
                      hint: "Unit Price",
                      keyboardType: TextInputType.number,
                      validator: _numberValidator,
                      icon: Icons.attach_money_rounded,
                    ),
                    CustomTextField(
                      controller: supplier,
                      hint: "Supplier",
                      validator: _requiredValidator,
                      icon: Icons.store_outlined,
                    ),
                    CustomTextField(
                      controller: location,
                      hint: "Location",
                      validator: _requiredValidator,
                      icon: Icons.location_on_outlined,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            // Submit Button
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              decoration: BoxDecoration(
                color: backgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: cardShadowColor.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final data = {
                        "partName": partName.text.trim(),
                        "partNumber": partNumber.text.trim(),
                        "description": description.text.trim(),
                        "category": category.text.trim(),
                        "unit": unit.text.trim(),
                        "currentStock":
                            int.tryParse(currentStock.text.trim()) ?? 0,
                        "minStockLevel":
                            int.tryParse(minStockLevel.text.trim()) ?? 0,
                        "maxStockLevel":
                            int.tryParse(maxStockLevel.text.trim()) ?? 0,
                        "unitPrice":
                            double.tryParse(unitPrice.text.trim()) ?? 0.0,
                        "supplier": supplier.text.trim(),
                        "location": location.text.trim(),
                      };
                      Get.dialog(
                        Center(
                          child: CircularProgressIndicator(
                            color: buttonColor,
                          ),
                        ),
                        barrierDismissible: false,
                      );
                      final success = await controller.createParts(data);
                      Get.back();
                      Get.back();
                      if (success) {
                        Get.snackbar(
                          "Success",
                          "Part registered successfully",
                          backgroundColor: workingTextColor,
                          colorText: backgroundColor,
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      } else {
                        Get.snackbar(
                          "Error",
                          "Failed to register part",
                          backgroundColor: notWorkingTextColor,
                          colorText: backgroundColor,
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    foregroundColor: backgroundColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    "Create Part",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
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

  String? _requiredValidator(String? value) {
    return (value == null || value.trim().isEmpty)
        ? "This field is required"
        : null;
  }

  String? _numberValidator(String? value) {
    if (value == null || value.trim().isEmpty) return "This field is required";
    if (double.tryParse(value) == null) return "Enter a valid number";
    return null;
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final int maxLines;
  final IconData? icon;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: cardShadowColor.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: TextStyle(
          color: containerColor,
          fontSize: 15,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: subtitleColor,
            fontSize: 15,
          ),
          prefixIcon: icon != null
              ? Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: buttonColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: buttonColor,
                    size: 20,
                  ),
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          filled: true,
          fillColor: backgroundColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: dividerColor,
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: dividerColor,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: buttonColor,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: notWorkingTextColor,
              width: 1,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: notWorkingTextColor,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
