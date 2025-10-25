import 'package:castle/Colors/Colors.dart';
import 'package:castle/Controlls/WorkersController/WorkerController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

import '../../Controlls/DepartmentController/DepartmentController.dart';
import '../../Widget/CustomTextField.dart';

class CreateWorker extends StatelessWidget {
  CreateWorker({super.key});
  final WorkerController controller = Get.find();
  final DepartmentController deptController = Get.put(DepartmentController());
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String initialCountry = 'IN';
    PhoneNumber number = PhoneNumber(isoCode: 'IN');
    RxBool isObscure = true.obs;
    RxBool isObscure2 = true.obs;

    // Fetch departments once the widget is built
    deptController.getDepartment();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text("Worker Details", style: GoogleFonts.poppins()),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: Colors.black87,
      ),
      body: Obx(() {
        if (deptController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final departments = deptController.departDetails;

        return Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10,
                      children: [
                        CustomTextField(
                          controller: controller.firstName,
                          hint: "First Name",
                          validator: (value) =>
                              value == null || value.trim().isEmpty
                                  ? 'First name is required'
                                  : null,
                        ),
                        CustomTextField(
                          controller: controller.lastName,
                          hint: "Last Name",
                          validator: (value) =>
                              value == null || value.trim().isEmpty
                                  ? 'Last name is required'
                                  : null,
                        ),
                        CustomTextField(
                          controller: controller.emailController,
                          hint: "Email",
                          validator: (value) =>
                              value == null || value.trim().isEmpty
                                  ? 'Email is required'
                                  : null,
                        ),
                        InternationalPhoneNumberInput(
                          inputBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: containerColor)),
                          onInputChanged: (PhoneNumber number) {},
                          selectorConfig: const SelectorConfig(
                            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                          ),
                          initialValue: number,
                          textFieldController: controller.phoneController,
                          inputDecoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                            labelText: "Phone Number",
                          ),
                        ),
                        Obx(() => TextFormField(
                              controller: controller.password,
                              validator: (val) {
                                if (val == null) {
                                  return "Password is required";
                                } else if (val.length < 6) {
                                  return "Password should be more than 6 letters";
                                } else {
                                  return null;
                                }
                              },
                              obscureText: isObscure.value,
                              decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        isObscure.value = !isObscure.value;
                                      },
                                      icon: isObscure.value
                                          ? const Icon(Icons.visibility_off)
                                          : const Icon(Icons.visibility)),
                                  hintText: "Password",
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: buttonColor),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          BorderSide(color: shadeColor)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          BorderSide(color: shadeColor))),
                            )),
                        Obx(() => TextFormField(
                              validator: (val) {
                                if (val == null) {
                                  return "Password is required";
                                } else if (val.length < 6) {
                                  return "Password should be more than 6 letters";
                                } else if (controller.password.text != val) {
                                  return "Passwords don't match";
                                } else {
                                  return null;
                                }
                              },
                              obscureText: isObscure2.value,
                              decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        isObscure2.value = !isObscure2.value;
                                      },
                                      icon: isObscure2.value
                                          ? const Icon(Icons.visibility_off)
                                          : const Icon(Icons.visibility)),
                                  hintText: "Confirm Password",
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: buttonColor),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          BorderSide(color: shadeColor)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          BorderSide(color: shadeColor))),
                            )),
                        const SizedBox(height: 10),
                        Text("Primary Department",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500)),
                        DropdownButtonFormField<String>(
                          dropdownColor: backgroundColor,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: shadeColor)),
                          ),
                          hint: const Text("Select Primary Department"),
                          value: controller.primaryDepartment.value.isEmpty
                              ? null
                              : controller.primaryDepartment.value,
                          items: departments
                              .map((dept) => DropdownMenuItem(
                                    value: dept.id,
                                    child: Text(dept.name ?? ""),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            controller.primaryDepartment.value = value ?? '';
                          },
                          validator: (val) => val == null || val.isEmpty
                              ? "Select primary department"
                              : null,
                        ),
                        const SizedBox(height: 15),
                        Text("Secondary Departments",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500)),
                        MultiSelectDialogField(
                          backgroundColor: backgroundColor,
                          items: departments
                              .map((dept) =>
                                  MultiSelectItem(dept.id, dept.name ?? ""))
                              .toList(),
                          title: Text("Select Secondary Departments",
                              style: GoogleFonts.poppins()),
                          selectedColor: buttonColor,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: shadeColor),
                          ),
                          buttonIcon: const Icon(Icons.arrow_drop_down,
                              color: Colors.black54),
                          buttonText: Text(
                            "Choose Department(s)",
                            style: GoogleFonts.poppins(
                                fontSize: 14, color: Colors.black54),
                          ),
                          onConfirm: (values) {
                            controller.selectedDepartments.value =
                                values.cast<String>();
                          },
                          chipDisplay: MultiSelectChipDisplay(
                            chipColor: buttonColor.withOpacity(0.2),
                            textStyle: const TextStyle(color: Colors.black87),
                            onTap: (value) {
                              controller.selectedDepartments.remove(value);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Obx(() => controller.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : InkWell(
                          onTap: () async {
                            if (formKey.currentState!.validate()) {
                              await controller.createWorker();
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: buttonColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                "Next",
                                style: TextStyle(
                                    color: backgroundColor, fontSize: 16),
                              ),
                            ),
                          ),
                        ))
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
