import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../../Controlls/ClientController/ClientController.dart';
import '../../Colors/Colors.dart';
import '../../Widget/CustomTextField.dart';
import '../../Widget/PasswordStrengthIndicator.dart';

class ClientRegisterOne extends StatefulWidget {
  const ClientRegisterOne({super.key});

  @override
  State<ClientRegisterOne> createState() => _ClientRegisterOneState();
}

class _ClientRegisterOneState extends State<ClientRegisterOne> {
  final ClientRegisterController controller =
      Get.put(ClientRegisterController());
  final formKeyOne = GlobalKey<FormState>();
  late RxBool isObscure;
  late RxBool isObscure2;

  @override
  void initState() {
    super.initState();
    isObscure = true.obs;
    isObscure2 = true.obs;

    // If not updating, clear all fields for new client
    if (!controller.isUpdate) {
      controller.firstName.clear();
      controller.lastName.clear();
      controller.email.clear();
      controller.password.clear();
      controller.conformPass.clear();
      controller.phone.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Initialize phone number - parse from controller text if it exists
    PhoneNumber initialPhoneNumber = PhoneNumber(isoCode: 'IN');

    // If controller has phone text and we're updating, parse it properly
    if (controller.isUpdate && controller.phone.text.isNotEmpty) {
      // Extract just the digits (remove all non-digit characters)
      String phoneDigits =
          controller.phone.text.replaceAll(RegExp(r'[^\d]'), '');
      if (phoneDigits.isNotEmpty) {
        // Remove country code if present (assuming IN +91, so remove first 2 digits if phone starts with 91)
        if (phoneDigits.startsWith('91') && phoneDigits.length > 10) {
          phoneDigits = phoneDigits.substring(2);
        }
        // Ensure we have at least 10 digits
        if (phoneDigits.length >= 10) {
          initialPhoneNumber = PhoneNumber(
            isoCode: 'IN',
            phoneNumber: phoneDigits,
          );
        }
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
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
          controller.isUpdate ? 'Edit Client' : 'Create Client',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: containerColor,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: formKeyOne,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Personal Information Section
              _sectionTitle('Personal Information'),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: dividerColor,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: cardShadowColor.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    CustomTextField(
                      controller: controller.firstName,
                      hint: "First Name",
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? 'First name is required'
                              : null,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: controller.lastName,
                      hint: "Last Name",
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? 'Last name is required'
                              : null,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: controller.email,
                      hint: "Email",
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Email is required';
                        }
                        final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
                        if (!emailRegex.hasMatch(value)) {
                          return 'Invalid email format';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    InternationalPhoneNumberInput(
                      inputBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: borderColor),
                      ),
                      onInputChanged: (PhoneNumber number) {},
                      selectorConfig: const SelectorConfig(
                        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                      ),
                      initialValue: initialPhoneNumber,
                      textFieldController: controller.phone,
                      ignoreBlank: controller.isUpdate,
                      inputDecoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 20,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: borderColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: borderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: buttonColor),
                        ),
                        hintText: controller.isUpdate
                            ? "Phone Number (optional)"
                            : "Phone Number",
                        hintStyle: TextStyle(color: subtitleColor),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Password Section
              _sectionTitle('Password'),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: dividerColor,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: cardShadowColor.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Obx(() => TextFormField(
                          controller: controller.password,
                          validator: (val) {
                            if (!controller.isUpdate) {
                              // Required for new clients
                              if (val == null || val.isEmpty) {
                                return "Password is required";
                              } else if (val.length < 6) {
                                return "Password should be more than 6 letters";
                              }
                            } else {
                              // Optional for updates, but if provided, must be valid
                              if (val != null &&
                                  val.isNotEmpty &&
                                  val.length < 6) {
                                return "Password should be more than 6 letters";
                              }
                            }
                            return null;
                          },
                          obscureText: isObscure.value,
                          style: TextStyle(color: containerColor),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 20,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                isObscure.value = !isObscure.value;
                              },
                              icon: isObscure.value
                                  ? Icon(Icons.visibility_off,
                                      color: subtitleColor)
                                  : Icon(Icons.visibility,
                                      color: subtitleColor),
                            ),
                            hintText: controller.isUpdate
                                ? "Password (leave empty to keep current)"
                                : "Password",
                            hintStyle: TextStyle(color: subtitleColor),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
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
                          ),
                        )),
                    const SizedBox(height: 8),
                    PasswordStrengthIndicator(controller: controller.password),
                    const SizedBox(height: 8),
                    Obx(() => TextFormField(
                          controller: controller.conformPass,
                          validator: (val) {
                            if (!controller.isUpdate) {
                              // Required for new clients
                              if (val == null || val.isEmpty) {
                                return "Password is required";
                              } else if (val.length < 6) {
                                return "Password should be more than 6 letters";
                              } else if (controller.password.text != val) {
                                return "Passwords don't match";
                              }
                            } else {
                              // Optional for updates, but if provided, must match
                              if (val != null && val.isNotEmpty) {
                                if (val.length < 6) {
                                  return "Password should be more than 6 letters";
                                } else if (controller.password.text != val) {
                                  return "Passwords don't match";
                                }
                              }
                            }
                            return null;
                          },
                          obscureText: isObscure2.value,
                          style: TextStyle(color: containerColor),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 20,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                isObscure2.value = !isObscure2.value;
                              },
                              icon: isObscure2.value
                                  ? Icon(Icons.visibility_off,
                                      color: subtitleColor)
                                  : Icon(Icons.visibility,
                                      color: subtitleColor),
                            ),
                            hintText: controller.isUpdate
                                ? "Confirm Password (leave empty to keep current)"
                                : "Confirm Password",
                            hintStyle: TextStyle(color: subtitleColor),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
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
                          ),
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Next Button
              InkWell(
                onTap: () {
                  if (formKeyOne.currentState!.validate()) {
                    Get.toNamed('/clientRegisterTwo');
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: buttonColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: buttonColor.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "Next",
                      style: TextStyle(
                        color: backgroundColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Row(
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
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: containerColor,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }
}
