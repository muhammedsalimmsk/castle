import 'package:castle/Widget/CustomTextField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        "Client Name",
        controller.clientName,
        Icons.business,
        (String? val) =>
            val == null || val.isEmpty ? "Client name required" : null
      ],
      [
        "Client Address",
        controller.clientAddress,
        Icons.location_on,
        (String? val) => val == null || val.isEmpty ? "Address required" : null
      ],
      [
        "Client Phone",
        controller.clientPhone,
        Icons.phone_android,
        (String? val) => val == null || val.isEmpty ? "Phone required" : null
      ],
      [
        "Client Email",
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
        key: formKeyTwo,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Client Details Section
              _sectionTitle('Client Details'),
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
                    ...clientFields.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      return Column(
                        children: [
                          CustomTextField(
                            controller: item[1] as TextEditingController,
                            icon: item[2] as IconData,
                            hint: item[0] as String,
                            validator: item[3] as String? Function(String?),
                          ),
                          if (index < clientFields.length - 1)
                            const SizedBox(height: 16),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Submit Button
              Obx(
                () => controller.isLoading.value
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : InkWell(
                        onTap: () async {
                          if (formKeyTwo.currentState!.validate()) {
                            if (controller.isUpdate) {
                              await controller
                                  .updateClient(controller.clientDetails.id!);
                            } else {
                              await controller.createClient();
                            }
                            Get.offNamed('/clients');
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
                              controller.isUpdate ? "Update Client" : "Submit",
                              style: TextStyle(
                                color: backgroundColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
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
