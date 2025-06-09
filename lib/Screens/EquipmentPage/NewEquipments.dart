import 'package:castle/Colors/Colors.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../Widget/CustomTextField.dart';

class NewEquipmentsRequest extends StatelessWidget {
  const NewEquipmentsRequest({super.key});

  @override
  Widget build(BuildContext context) {
    String initialCountry = 'IN';
    PhoneNumber number = PhoneNumber(isoCode: 'IN');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        centerTitle: true,
        title: Text("New Equipment"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              Text(
                "Client Details",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              CustomTextField(
                hint: "First Name",
              ),
              CustomTextField(hint: "Last Name"),
              CustomTextField(hint: "Display Name"),
              CustomTextField(
                hint: "Location",
                icon: Icons.add_location_alt,
              ),
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
              TextFormField(
                decoration: InputDecoration(
                    hintText: "Address",
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 40, horizontal: 16),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: shadeColor)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: shadeColor))),
              ),
              CustomTextField(hint: "ZipCode"),
              SizedBox(
                height: 20,
              ),
              Container(
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
              )
            ],
          ),
        ),
      ),
    );
  }
}


