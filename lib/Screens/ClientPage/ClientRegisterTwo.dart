import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Controlls/ClientController/ClientController.dart';
import '../../Colors/Colors.dart';

class ClientRegisterPageTwo extends StatelessWidget {
  final controller = Get.find<ClientRegisterController>();

  ClientRegisterPageTwo({super.key});

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
    final hotelFields = [
      ["Hotel Name", controller.hotelName, Icons.business, false],
      ["Hotel Address", controller.hotelAddress, Icons.location_on, false],
      ["Hotel City", controller.hotelCity, Icons.location_city, false],
      ["Hotel State", controller.hotelState, Icons.map, false],
      ["Hotel Country", controller.hotelCountry, Icons.flag, false],
      ["Hotel Postal Code", controller.hotelPostalCode, Icons.mail, false],
      ["Hotel Phone", controller.hotelPhone, Icons.phone_android, false],
      ["Hotel Email", controller.hotelEmail, Icons.email_outlined, false],
      ["Contact Person", controller.contactPerson, Icons.contact_page, false],
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Hotel Details", style: GoogleFonts.poppins()),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: Colors.black87,
      ),
      body: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Card(
                color: buttonShadeColor,
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: hotelFields
                        .map((e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: _buildInput(
                        label: e[0] as String,
                        controller: e[1] as TextEditingController,
                        icon: e[2] as IconData,
                        isPassword: e[3] as bool,
                      ),
                    ))
                        .toList(),
                  ),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () {
                  if (controller.formKey.currentState!.validate()) {
                    // Submit API here
                    Get.snackbar("Success", "Client registration data is ready to submit",
                        snackPosition: SnackPosition.BOTTOM);
                  }
                },
                icon: Icon(Icons.check_circle),
                label: Text("Submit", style: GoogleFonts.poppins(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
