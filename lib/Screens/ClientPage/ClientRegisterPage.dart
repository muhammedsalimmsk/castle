import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../../Controlls/ClientController/ClientController.dart';
import '../../Colors/Colors.dart';
import '../../Widget/CustomTextField.dart';
import 'ClientRegisterTwo.dart';
class ClientRegisterOne extends StatelessWidget {
  final controller = Get.put(ClientRegisterController());

  ClientRegisterOne({super.key});

  Widget _buildInput({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blueGrey),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.blueAccent)),
        contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      ),
      validator: (value) => value == null || value.isEmpty ? 'Required' : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    String initialCountry = 'IN';
    PhoneNumber number = PhoneNumber(isoCode: 'IN');
    RxBool isObscure=true.obs;
    RxBool isObscure2=true.obs;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("User Details", style: GoogleFonts.poppins()),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: Colors.black87,
      ),
      body: Form(
        key: controller.formKey,
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
                    hint: "First Name",
                  ),
                  CustomTextField(hint: "Last Name"),
                  CustomTextField(hint: "Email"),
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
          Obx(()=>TextFormField(
            obscureText: isObscure.value,
            decoration: InputDecoration(
                suffixIcon:IconButton(onPressed: (){
                  isObscure.value=!isObscure.value;
                }, icon: isObscure.value?Icon(Icons.visibility_off):Icon(Icons.visibility)),
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
                  Obx(()=>TextFormField(
                    obscureText: isObscure2.value,
                    decoration: InputDecoration(
                        suffixIcon:IconButton(onPressed: (){
                          isObscure2.value=!isObscure2.value;
                        }, icon: isObscure2.value?Icon(Icons.visibility_off):Icon(Icons.visibility)),
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
                onTap: (){
                  Get.to(ClientRegisterPageTwo());
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: containerColor,
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
