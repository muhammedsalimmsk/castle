import 'package:castle/Controlls/PartsController/PartsController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
        iconTheme: IconThemeData(color: buttonColor),
        title: Text(
          "Add Part",
          style: TextStyle(color: buttonColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: Colors.black87,
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 10,
                    children: [
                      CustomTextField(
                        controller: partName,
                        hint: "Part Name",
                        validator: _requiredValidator,
                        suffixIcon: Icon(
                          Icons.precision_manufacturing,
                          color: buttonColor,
                        ),
                      ),
                      CustomTextField(
                        controller: partNumber,
                        hint: "Part Number",
                        validator: _requiredValidator,
                        suffixIcon: Icon(
                          Icons.confirmation_number_outlined,
                          color: buttonColor,
                        ),
                      ),
                      CustomTextField(
                        controller: description,
                        hint: "Description",
                        maxLines: 3,
                        validator: _requiredValidator,
                        suffixIcon: Icon(
                          Icons.description_outlined,
                          color: buttonColor,
                        ),
                      ),
                      CustomTextField(
                        controller: category,
                        hint: "Category",
                        validator: _requiredValidator,
                        suffixIcon: Icon(
                          Icons.category_outlined,
                          color: buttonColor,
                        ),
                      ),
                      CustomTextField(
                        controller: unit,
                        hint: "Unit (e.g., pcs, kg)",
                        validator: _requiredValidator,
                        suffixIcon: Icon(
                          Icons.straighten,
                          color: buttonColor,
                        ),
                      ),
                      CustomTextField(
                        controller: currentStock,
                        hint: "Current Stock",
                        keyboardType: TextInputType.number,
                        validator: _numberValidator,
                        suffixIcon: Icon(
                          Icons.inventory,
                          color: buttonColor,
                        ),
                      ),
                      CustomTextField(
                        controller: minStockLevel,
                        hint: "Minimum Stock Level",
                        keyboardType: TextInputType.number,
                        validator: _numberValidator,
                        suffixIcon: Icon(
                          Icons.minimize,
                          color: buttonColor,
                        ),
                      ),
                      CustomTextField(
                        controller: maxStockLevel,
                        hint: "Maximum Stock Level",
                        keyboardType: TextInputType.number,
                        validator: _numberValidator,
                        suffixIcon: Icon(
                          Icons.maximize,
                          color: buttonColor,
                        ),
                      ),
                      CustomTextField(
                        controller: unitPrice,
                        hint: "Unit Price",
                        keyboardType: TextInputType.number,
                        validator: _numberValidator,
                        suffixIcon: Icon(
                          Icons.attach_money,
                          color: buttonColor,
                        ),
                      ),
                      CustomTextField(
                        controller: supplier,
                        hint: "Supplier",
                        validator: _requiredValidator,
                        suffixIcon: Icon(
                          Icons.store_outlined,
                          color: buttonColor,
                        ),
                      ),
                      CustomTextField(
                        controller: location,
                        hint: "Location",
                        validator: _requiredValidator,
                        suffixIcon: Icon(
                          Icons.location_on_outlined,
                          color: buttonColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () async {
                  if (formKey.currentState!.validate()) {
                    // Send data to controller or API
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
                      )),
                      barrierDismissible: false,
                    );
                    final success = await controller.createParts(data);
                    Get.back();
                    Get.back();
                    if (success) {
                      Get.snackbar("Success", "Part registered successfully",
                          backgroundColor: Colors.green,
                          colorText: Colors.white);
                    } else {
                      Get.snackbar("Error", "Failed to register part",
                          backgroundColor: Colors.red, colorText: Colors.white);
                    }
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: buttonColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      "Submit",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
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
  final Widget? suffixIcon;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          suffixIcon: suffixIcon,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          filled: true,
          fillColor: secondaryColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: shadeColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: shadeColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: buttonColor),
          ),
        ),
      ),
    );
  }
}
