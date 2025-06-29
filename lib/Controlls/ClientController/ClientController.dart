import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ClientRegisterController extends GetxController {
  final formKey = GlobalKey<FormState>();

  // Text controllers
  final email = TextEditingController();
  final password = TextEditingController();
  final conformPass=TextEditingController();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final phone = TextEditingController();
  final hotelName = TextEditingController();
  final hotelAddress = TextEditingController();
  final hotelCity = TextEditingController();
  final hotelState = TextEditingController();
  final hotelCountry = TextEditingController();
  final hotelPostalCode = TextEditingController();
  final hotelPhone = TextEditingController();
  final hotelEmail = TextEditingController();
  final contactPerson = TextEditingController();

}
