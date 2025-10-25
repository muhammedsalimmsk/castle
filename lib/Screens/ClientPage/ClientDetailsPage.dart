import 'package:castle/Colors/Colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:castle/Controlls/ClientController/ClientController.dart';

class ClientDetailPage extends StatelessWidget {
  final String clientId;
  const ClientDetailPage({super.key, required this.clientId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ClientRegisterController>(
      init: ClientRegisterController()..fetchClientDetails(clientId),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: backgroundColor,
            surfaceTintColor: backgroundColor,
            title: const Text("Client Details"),
            centerTitle: true,
          ),
          body: controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : controller.clientDetailModel.data == null
                  ? const Center(child: Text("No Client Data Found"))
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView(
                        children: [
                          _infoTile("Client Name",
                              controller.clientDetails.clientName),
                          _infoTile("Contact Person",
                              controller.clientDetails.contactPerson),
                          _infoTile(
                              "Email", controller.clientDetails.clientEmail),
                          _infoTile("Phone",
                              controller.clientDetails.phone.toString()),
                          _infoTile("Company Address",
                              controller.clientDetails.clientAddress),
                        ],
                      ),
                    ),
        );
      },
    );
  }

  Widget _infoTile(String title, String? value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              value ?? "-",
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
