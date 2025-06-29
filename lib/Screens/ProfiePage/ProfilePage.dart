import 'package:castle/Colors/Colors.dart';
import 'package:castle/Controlls/AuthController/AuthController.dart';
import 'package:castle/Screens/LoginPage/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Profile',
          style: TextStyle(color: containerColor,fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          const SizedBox(height: 40),
          const CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 16),
           Text(
            '${userDetailModel!.data!.firstName} ${userDetailModel!.data!.lastName}',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            userDetailModel!.data!.email!,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 30),
          const Divider(thickness: 1),
          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text('Phone'),
            subtitle:  Text(userDetailModel!.data!.phone!),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Role'),
            subtitle: Text(userDetailModel!.data!.role!),
          ),

          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: containerColor,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: ()async {
                await Get.defaultDialog(
                  middleText: "Do you want to logout?",
                  onCancel: (){
                    Get.back();
                  },
                  onConfirm: ()async{
                    SharedPreferences pref=await SharedPreferences.getInstance();
                    pref.clear();
                    userDetailModel=null;
                    Get.offAll(LoginPage());
                  }
                );
                // Handle logout or action
              },
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text('Logout', style: TextStyle(color: Colors.white)),
            ),
          ),
          SizedBox(height: 20,)
        ],
      ),
    );
  }
}
