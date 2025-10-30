import 'package:castle/Screens/ClientPage/ClientPage.dart';
import 'package:castle/Widget/CustomTextField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Controlls/ClientController/ClientController.dart';
import '../../Colors/Colors.dart';

class ClientRegisterPageTwo extends StatelessWidget {
  final controller = Get.find<ClientRegisterController>();
  final formKeyTwo = GlobalKey<FormState>();

  ClientRegisterPageTwo({super.key});

  @override
  Widget build(BuildContext context) {
    final clientFields = [
      [
        "client Name",
        controller.clientName,
        Icons.business,
        (String? val) =>
            val == null || val.isEmpty ? "client name required" : null
      ],
      [
        "client Address",
        controller.clientAddress,
        Icons.location_on,
        (String? val) => val == null || val.isEmpty ? "Address required" : null
      ],
      // [
      //   "client City",
      //   controller.clientCity,
      //   Icons.location_city,
      //   (String? val) => val == null || val.isEmpty ? "City required" : null
      // ],
      // [
      //   "client State",
      //   controller.clientState,
      //   Icons.map,
      //   (String? val) => val == null || val.isEmpty ? "State required" : null
      // ],
      // [
      //   "client Country",
      //   controller.clientCountry,
      //   Icons.flag,
      //   (String? val) => val == null || val.isEmpty ? "Country required" : null
      // ],
      // [
      //   "client Postal Code",
      //   controller.clientPostalCode,
      //   Icons.mail,
      //   (String? val) =>
      //       val == null || val.isEmpty ? "Postal code required" : null
      // ],
      [
        "client Phone",
        controller.clientPhone,
        Icons.phone_android,
        (String? val) => val == null || val.isEmpty ? "Phone required" : null
      ],
      [
        "client Email",
        controller.clientEmail,
        Icons.email_outlined,
        (String? val) {
          if (val == null || val.isEmpty) return "Email required";
          final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
          return emailRegex.hasMatch(val) ? null : "Invalid email";
        }
      ],
      [
        "Contact Person",
        controller.contactPerson,
        Icons.contact_page,
        (String? val) =>
            val == null || val.isEmpty ? "Contact person required" : null
      ],
    ];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text("client Details", style: GoogleFonts.poppins()),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: Colors.black87,
      ),
      body: Form(
        key: formKeyTwo,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: clientFields.length,
                  separatorBuilder: (context, index) => SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = clientFields[index];
                    return CustomTextField(
                      controller: item[1] as TextEditingController,
                      icon: item[2] as IconData,
                      hint: item[0] as String,
                      validator: item[3] as String? Function(String?),
                    );
                  },
                ),
              ),
              Obx(
                () => controller.isLoading.value
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : InkWell(
                        onTap: () async {
                          if (formKeyTwo.currentState!.validate()) {
                            // Add submit API logic here
                            if (controller.isUpdate) {
                              await controller
                                  .updateClient(controller.clientDetails.id!);
                            } else {
                              await controller.createClient();
                            }

                            Get.off(ClientPage());
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
                              "Submit",
                              style: TextStyle(
                                  color: backgroundColor, fontSize: 16),
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
}
