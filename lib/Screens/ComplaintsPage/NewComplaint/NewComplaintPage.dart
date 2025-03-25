import 'package:castle/Widget/CustomAppBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Colors/Colors.dart';
class NewComplaintRegister extends StatelessWidget {
  const NewComplaintRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        centerTitle: true,
        title: Text("New Equipment"),
      ),
    );
  }
}
