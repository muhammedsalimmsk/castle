import 'package:castle/Colors/Colors.dart';
import 'package:castle/Screens/ClientPage/ClientRegisterPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Widget/CustomAppBarWidget.dart';
import '../../Widget/CustomDrawer.dart';
class ClientPage extends StatelessWidget {
  const ClientPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: CustomAppBar(),
      backgroundColor: backgroundColor,
      body: Center(
        child: Text("Client Page"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          Get.to(ClientRegisterOne());
        },
        label: Text("Add New"),),
    );
  }
}
