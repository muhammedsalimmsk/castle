import 'package:castle/Colors/Colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:castle/Controlls/ClientController/ClientController.dart';

class ClientDetailPage extends StatelessWidget {
  final String clientId;
  ClientDetailPage({super.key, required this.clientId});
  final controller = Get.put(ClientRegisterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        surfaceTintColor: backgroundColor,
        title: const Text("Client Details"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: controller.getClientById(clientId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("No Client Data Found"));
          }

          final client = snapshot.data;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                _infoTile("Client Name", client!.clientName),
                _infoTile("Contact Person", client.contactPerson),
                _infoTile("Email", client.clientEmail),
                _infoTile("Phone", client.phone?.toString()),
                _infoTile("Company Address", client.clientAddress),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _infoTile(String title, String? value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: buttonColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              value ?? "-",
              textAlign: TextAlign.right,
              style: const TextStyle(color: buttonColor, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
