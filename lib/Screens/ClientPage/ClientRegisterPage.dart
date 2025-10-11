import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../../Controlls/ClientController/ClientController.dart';
import '../../Colors/Colors.dart';
import '../../Widget/CustomTextField.dart';
import 'ClientRegisterTwo.dart';

class ClientRegisterOne extends StatelessWidget {
  final ClientRegisterController controller =
      Get.put(ClientRegisterController());
  final formKeyOne = GlobalKey<FormState>();

  ClientRegisterOne({super.key});

  @override
  Widget build(BuildContext context) {
    PhoneNumber number = PhoneNumber(isoCode: 'IN');
    RxBool isObscure = true.obs;
    RxBool isObscure2 = true.obs;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: buttonColor),
        surfaceTintColor: backgroundColor,
        title: Text("Client Details", style: TextStyle(color: buttonColor)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: Colors.black87,
      ),
      body: Form(
        key: formKeyOne,
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
                    controller: controller.email,
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
                    // textFieldController: controller,
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
                              borderSide: BorderSide(color: containerColor),
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
                              borderSide: BorderSide(color: containerColor),
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
              InkWell(
                onTap: () {
                  if (formKeyOne.currentState!.validate()) {
                    Get.to(ClientRegisterPageTwo());
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
                      style: TextStyle(color: backgroundColor, fontSize: 16),
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
}
