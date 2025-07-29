import 'package:castle/Colors/Colors.dart';
import 'package:castle/Controlls/WorkersController/WorkerController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../Widget/CustomTextField.dart';

class CreateWorker extends StatelessWidget {
  CreateWorker({super.key});
  final WorkerController controller = Get.find();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    String initialCountry = 'IN';
    PhoneNumber number = PhoneNumber(isoCode: 'IN');
    RxBool isObscure = true.obs;
    RxBool isObscure2 = true.obs;

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
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  CustomTextField(
                    controller: controller.firstName,
                    hint: "First Name",
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'First name is required'
                        : null,
                  ),
                  CustomTextField(
                    controller: controller.lastName,
                    hint: "Last Name",
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Last name is required'
                        : null,
                  ),
                  CustomTextField(
                    controller: controller.emailController,
                    hint: "Email",
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Email is required'
                        : null,
                  ),
                  InternationalPhoneNumberInput(
                    inputBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: containerColor)),
                    onInputChanged: (PhoneNumber number) {},
                    selectorConfig: SelectorConfig(
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
                            return "Password should be more than 6 letter";
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
                                    ? Icon(Icons.visibility_off)
                                    : Icon(Icons.visibility)),
                            hintText: "Password",
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: buttonColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: shadeColor)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: shadeColor))),
                      )),
                  Obx(() => TextFormField(
                        validator: (val) {
                          if (val == null) {
                            return "Password is required";
                          } else if (val.length < 6) {
                            return "Password should be more than 6 letter";
                          } else if (controller.password.text != val) {
                            return "Password doesn't match";
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
                                    ? Icon(Icons.visibility_off)
                                    : Icon(Icons.visibility)),
                            hintText: "Conform Password",
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: buttonColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: shadeColor)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: shadeColor))),
                      )),
                ],
              ),
              Obx(() => controller.isLoading.value
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : InkWell(
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          await controller.createWorker();
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: buttonColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "Next",
                            style:
                                TextStyle(color: backgroundColor, fontSize: 16),
                          ),
                        ),
                      ),
                    ))
            ],
          ),
        ),
      ),
    );
  }
}
