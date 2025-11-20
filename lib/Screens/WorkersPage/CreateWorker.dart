import 'package:castle/Colors/Colors.dart';
import 'package:castle/Controlls/WorkersController/WorkerController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

import '../../Controlls/DepartmentController/DepartmentController.dart';
import '../../Widget/CustomTextField.dart';

class CreateWorker extends StatefulWidget {
  final String? workerId;
  const CreateWorker({super.key, this.workerId});

  @override
  State<CreateWorker> createState() => _CreateWorkerState();
}

class _CreateWorkerState extends State<CreateWorker> {
  final WorkerController controller = Get.find();
  final DepartmentController deptController = Get.put(DepartmentController());
  final formKey = GlobalKey<FormState>();
  late RxBool isObscure;
  late RxBool isObscure2;

  @override
  void initState() {
    super.initState();
    isObscure = true.obs;
    isObscure2 = true.obs;

    // If workerId is null, we're creating a new worker - clear all fields
    if (widget.workerId == null) {
      controller.clearField();
    }

    deptController.getDepartment();
  }

  @override
  Widget build(BuildContext context) {
    PhoneNumber number = PhoneNumber(isoCode: 'IN');

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
          controller.isUpdateWorker ? 'Edit Worker' : 'Create Worker',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: containerColor,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (deptController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final departments = deptController.departDetails;

        return Form(
          key: formKey,
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
                        controller: controller.emailController,
                        hint: "Email",
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? 'Email is required'
                                : null,
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
                        initialValue: number,
                        textFieldController: controller.phoneController,
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
                          hintText: "Phone Number",
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
                              if (!controller.isUpdateWorker) {
                                // Required for new workers
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
                              hintText: controller.isUpdateWorker
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
                      const SizedBox(height: 16),
                      Obx(() => TextFormField(
                            validator: (val) {
                              if (!controller.isUpdateWorker) {
                                // Required for new workers
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
                              hintText: controller.isUpdateWorker
                                  ? "Confirm Password (leave empty to keep current"
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
                const SizedBox(height: 24),
                // Department Section
                _sectionTitle('Department Assignment'),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Primary Department",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: containerColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        dropdownColor: backgroundColor,
                        decoration: InputDecoration(
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
                        ),
                        hint: Text(
                          "Select Primary Department",
                          style: TextStyle(color: subtitleColor),
                        ),
                        value: controller.primaryDepartment.value.isEmpty
                            ? null
                            : controller.primaryDepartment.value,
                        items: departments
                            .map((dept) => DropdownMenuItem(
                                  value: dept.id,
                                  child: Text(
                                    dept.name ?? "",
                                    style: TextStyle(color: containerColor),
                                  ),
                                ))
                            .toList(),
                        onChanged: (value) {
                          controller.primaryDepartment.value = value ?? '';

                          // Add primary to secondary if missing
                          if (value != null &&
                              !controller.selectedDepartments.contains(value)) {
                            controller.selectedDepartments.add(value);
                          }
                        },
                        validator: (val) => val == null || val.isEmpty
                            ? "Select primary department"
                            : null,
                        style: TextStyle(color: containerColor),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "Secondary Departments",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: containerColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      MultiSelectDialogField(
                        backgroundColor: backgroundColor,
                        items: departments.map((dept) {
                          bool isPrimary =
                              controller.primaryDepartment.value == dept.id;
                          return MultiSelectItem(
                            dept.id,
                            "${dept.name}${isPrimary ? " (Primary)" : ""}",
                          );
                        }).toList(),
                        title: Text(
                          "Select Secondary Departments",
                          style: TextStyle(
                            color: containerColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        selectedColor: buttonColor,
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor),
                        ),
                        buttonIcon:
                            Icon(Icons.arrow_drop_down, color: subtitleColor),
                        buttonText: Text(
                          "Choose Department(s)",
                          style: TextStyle(
                            fontSize: 14,
                            color: subtitleColor,
                          ),
                        ),
                        onConfirm: (values) {
                          List<String> selected = values.cast<String>();

                          // Ensure primary department is ALWAYS in the list
                          String primary = controller.primaryDepartment.value;
                          if (primary.isNotEmpty &&
                              !selected.contains(primary)) {
                            selected.add(primary);
                          }

                          controller.selectedDepartments.value = selected;
                        },
                        chipDisplay: MultiSelectChipDisplay(
                          onTap: (value) {
                            if (value != controller.primaryDepartment.value) {
                              controller.selectedDepartments.remove(value);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Submit Button
                Obx(() => controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : InkWell(
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            if (controller.isUpdateWorker) {
                              await controller.updateWorker(widget.workerId!);
                            } else {
                              await controller.createWorker();
                            }
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
                              controller.isUpdateWorker
                                  ? "Update Worker"
                                  : "Create Worker",
                              style: TextStyle(
                                color: backgroundColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      }),
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
