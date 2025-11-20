import 'package:castle/Controlls/ClientController/ClientController.dart';
import 'package:castle/Screens/EquipmentPage/NewEquipments.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../../../Colors/Colors.dart';
import '../../../Widget/CustomTextField.dart';

class ClientAddPage extends StatelessWidget {
  ClientAddPage({super.key});

  final ClientRegisterController controller =
      Get.put(ClientRegisterController());
  final formKeyOne = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    RxBool isObscure = true.obs;
    RxBool isObscure2 = true.obs;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        surfaceTintColor: backgroundColor,
        title: Text("Client Details", style: GoogleFonts.poppins()),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: Colors.black87,
      ),
      body: Form(
        key: formKeyOne,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Step 1 of 2",
                    style: GoogleFonts.poppins(
                        fontSize: 12, color: Colors.grey[700]),
                  ),
                ),
                SizedBox(height: 4),
                LinearProgressIndicator(
                  minHeight: 10,
                  value: 0.5,
                  color: buttonColor,
                  backgroundColor: progressBackround,
                ),
                SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() => TextFormField(
                              enabled: !controller.isExistingClient.value,
                              controller: controller.firstName,
                              style: TextStyle(color: containerColor),
                              decoration: InputDecoration(
                                hintText: "First Name (Search or Enter)",
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
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
                              onChanged: (value) {
                                controller.searchClients(value);
                              },
                            )),
                        Obx(() {
                          final results = controller.filteredClients;
                          if (controller.searchText.value.isEmpty ||
                              results.isEmpty) {
                            return SizedBox.shrink();
                          }
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: borderColor),
                            ),
                            height: 150,
                            child: ListView.builder(
                              itemCount: results.length,
                              itemBuilder: (context, index) {
                                final client = results[index];
                                return ListTile(
                                  title: Text(
                                      "${client.firstName ?? ''} ${client.lastName ?? ''}"),
                                  subtitle: Text(client.email ?? ''),
                                  onTap: () async {
                                    controller.filteredClients.clear();
                                    controller.selectedClientId.value =
                                        client.id!;
                                    await controller
                                        .fetchClientDetails(client.id!);
                                  },
                                );
                              },
                            ),
                          );
                        }),
                        Obx(() => controller.isExistingClient.value
                            ? Align(
                                alignment: Alignment.centerRight,
                                child: TextButton.icon(
                                  onPressed: () =>
                                      controller.clearSelectedClient(),
                                  icon: Icon(Icons.refresh),
                                  label: Text("Change Client"),
                                ),
                              )
                            : SizedBox.shrink()),
                        Obx(() => CustomTextField(
                              controller: controller.lastName,
                              enable: !controller.isExistingClient.value,
                              hint: "Last Name",
                              validator: (value) =>
                                  value == null || value.trim().isEmpty
                                      ? 'Last name is required'
                                      : null,
                            )),
                        Obx(() => CustomTextField(
                              label: "Email",
                              controller: controller.email,
                              hint: "User mail",
                              enable: !controller.isExistingClient.value,
                              validator: (value) =>
                                  value == null || value.trim().isEmpty
                                      ? 'Email is required'
                                      : null,
                            )),
                        Obx(() => InternationalPhoneNumberInput(
                              ignoreBlank: true,
                              isEnabled: !controller.isExistingClient.value,
                              initialValue: PhoneNumber(
                                  isoCode: 'IN',
                                  phoneNumber: controller.phone.text),
                              textFieldController: controller.phone,
                              selectorConfig: SelectorConfig(
                                selectorType:
                                    PhoneInputSelectorType.BOTTOM_SHEET,
                              ),
                              inputDecoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                labelText: "Phone Number",
                              ),
                              onInputChanged: (PhoneNumber value) {},
                            )),
                        Obx(() => controller.isExistingClient.value
                            ? SizedBox()
                            : Column(
                                children: [
                                  Obx(() => TextFormField(
                                        controller: controller.password,
                                        obscureText: isObscure.value,
                                        validator: (val) {
                                          if (val == null) {
                                            return "Password is required";
                                          }
                                          if (val.length < 6) {
                                            return "Password should be more than 6 letters";
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          suffixIcon: IconButton(
                                            onPressed: () => isObscure.value =
                                                !isObscure.value,
                                            icon: Icon(isObscure.value
                                                ? Icons.visibility_off
                                                : Icons.visibility),
                                          ),
                                          hintText: "Password",
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide:
                                                BorderSide(color: buttonColor),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide:
                                                BorderSide(color: borderColor),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide:
                                                BorderSide(color: borderColor),
                                          ),
                                        ),
                                      )),
                                  SizedBox(height: 10),
                                  Obx(() => TextFormField(
                                        validator: (val) {
                                          if (val == null)
                                            return "Password is required";
                                          if (val.length < 6) {
                                            return "Password should be more than 6 letters";
                                          }
                                          if (controller.password.text != val) {
                                            return "Passwords do not match";
                                          }
                                          return null;
                                        },
                                        obscureText: isObscure2.value,
                                        decoration: InputDecoration(
                                          suffixIcon: IconButton(
                                            onPressed: () => isObscure2.value =
                                                !isObscure2.value,
                                            icon: Icon(isObscure2.value
                                                ? Icons.visibility_off
                                                : Icons.visibility),
                                          ),
                                          hintText: "Confirm Password",
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide:
                                                BorderSide(color: buttonColor),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide:
                                                BorderSide(color: borderColor),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide:
                                                BorderSide(color: borderColor),
                                          ),
                                        ),
                                      )),
                                ],
                              )),
                        Obx(() => CustomTextField(
                              controller: controller.clientName,
                              icon: Icons.food_bank,
                              label: "Name",
                              hint: "client Name",
                              enable: !controller.isExistingClient.value,
                              validator: (val) => val == null || val.isEmpty
                                  ? "Please enter client name"
                                  : null,
                            )),
                        Obx(() => CustomTextField(
                              controller: controller.clientAddress,
                              icon: Icons.house,
                              label: "Address",
                              hint: "client Address",
                              enable: !controller.isExistingClient.value,
                              validator: (val) => val == null || val.isEmpty
                                  ? "Please enter client address"
                                  : null,
                            )),
                        Obx(() => CustomTextField(
                              label: "Email",
                              controller: controller.clientEmail,
                              icon: Icons.mail,
                              hint: "client Mail",
                              enable: !controller.isExistingClient.value,
                              validator: (val) {
                                if (val == null || val.isEmpty)
                                  return "Email required";
                                final emailRegex =
                                    RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
                                return emailRegex.hasMatch(val)
                                    ? null
                                    : "Invalid email";
                              },
                            )),
                        Obx(() => CustomTextField(
                              controller: controller.contactPerson,
                              icon: Icons.person,
                              label: "Name",
                              hint: "Contact Person",
                              enable: !controller.isExistingClient.value,
                              validator: (val) => val == null || val.isEmpty
                                  ? "Please enter contact person"
                                  : null,
                            )),
                        SizedBox(height: 16),
                        Obx(() => controller.isLoading.value
                            ? Center(child: CircularProgressIndicator())
                            : InkWell(
                                onTap: () async {
                                  if (formKeyOne.currentState!.validate()) {
                                    if (!controller.isExistingClient.value) {
                                      await controller.createClient();
                                      if (controller.selectedClientId.value !=
                                          '') {
                                        Get.toNamed('/newEquipment', arguments: {
                                          'clientId': controller.selectedClientId.value,
                                        });
                                      }
                                    } else {
                                      Get.toNamed('/newEquipment', arguments: {
                                        'clientId': controller.selectedClientId.value,
                                      });
                                    }
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
                                      style: TextStyle(
                                          color: backgroundColor, fontSize: 16),
                                    ),
                                  ),
                                ),
                              )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
