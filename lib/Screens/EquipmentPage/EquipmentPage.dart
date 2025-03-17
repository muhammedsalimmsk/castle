import 'package:castle/Colors/Colors.dart';
import 'package:castle/Controlls/EquipmentController/EquipmentController.dart';
import 'package:castle/Screens/EquipmentPage/NewEquipments.dart';
import 'package:castle/Widget/CustomAppBarWidget.dart';
import 'package:castle/Widget/CustomDrawer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class EquipmentPage extends StatelessWidget {
  EquipmentPage({super.key});
  List<Equipment> equipmentList = [
    Equipment(
      trackingId: "#20462",
      productName: "HVAC System",
      productImage:
          "https://decure.in/cdn/shop/files/1080_f_9502_xgrh.jpg?v=1712318507&width=823",
      customer: "Matt Dickerson",
      category: "Climate Control",
      subCategory: "Air Systems",
      equipmentType: "Central AC",
      status: "Working",
    ),
    Equipment(
      trackingId: "#18933",
      productName: "Kitchen Range",
      productImage:
          "https://as2.ftcdn.net/v2/jpg/00/79/96/21/1000_F_79962155_xVG8d0efElvO4hU1BRtHAoMNSEJNTK0G.jpg",
      customer: "Wiktoria",
      category: "Kitchen Equipment",
      subCategory: "Cooking Appliances",
      equipmentType: "Gas Stove",
      status: "Working",
    ),
    Equipment(
      trackingId: "#17188",
      productName: "Elevator",
      productImage:
          "https://www.airconditioningdoctor.com.au/wp-content/uploads/2024/03/20231110_084813-1080x675.webp",
      customer: "Sanderson",
      category: "Guest Transport",
      subCategory: "Lifting Systems",
      equipmentType: "Passenger Elevator",
      status: "Not Working",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    EquipmentController controller = Get.put(EquipmentController());
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 10,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                        suffixIcon: Icon(Icons.search),
                        hintText: "Search here..",
                        fillColor: secondaryColor,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: containerColor)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                IconButton(
                  onPressed: () {
                    // Your action here
                  },
                  icon: Container(
                    padding: EdgeInsets.all(11),
                    // width: 50, // Adjust width
                    // height: 50, // Adjust height
                    decoration: BoxDecoration(
                      border: Border.all(color: containerColor),
                      color: secondaryColor, // Background color
                      borderRadius: BorderRadius.circular(
                          4), // Adjust for rounded corners
                    ),
                    child: Icon(
                      FontAwesomeIcons.sliders,
                      color: containerColor,
                    ), // Your icon
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Equipment",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(() => DropdownButton<String>(
                          isDense: true,
                          padding: EdgeInsets.zero,
                          value: controller.selectedValue.value,
                          icon: Icon(Icons.arrow_drop_down), // Down arrow icon
                          underline: SizedBox(), // Removes default underline
                          borderRadius: BorderRadius.circular(10),
                          style: TextStyle(
                              color: Colors.black), // Customize text style
                          items: controller.sortOptions
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            controller.selectedValue.value = newValue!;
                          },
                        )),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 680,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: equipmentList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      child: Container(
                        padding: EdgeInsets.zero,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: shadeColor,
                                spreadRadius: 0.8,
                                blurRadius: 3,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10),
                            color: secondaryColor),
                        child: ListTile(
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                    image: NetworkImage(
                                        equipmentList[index].productImage),
                                    fit: BoxFit.cover)),
                          ),
                          title: Text(
                            equipmentList[index].productName,
                            style: TextStyle(color: containerColor),
                          ),
                          subtitle: Text(equipmentList[index].customer),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(equipmentList[index].category),
                                  Text(equipmentList[index].status),
                                ],
                              ),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.more_vert,
                                    color: containerColor,
                                  )),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: containerColor,
        onPressed: () {
          Get.to(NewEquipmentsRequest());
        },
        label: Text(
          "Add New",
          style: TextStyle(color: backgroundColor),
        ),
      ),
    );
  }
}

class Equipment {
  final String trackingId;
  final String productName;
  final String productImage;
  final String customer;
  final String category;
  final String subCategory;
  final String equipmentType;
  final String status;

  Equipment({
    required this.trackingId,
    required this.productName,
    required this.productImage,
    required this.customer,
    required this.category,
    required this.subCategory,
    required this.equipmentType,
    required this.status,
  });

  // Factory method to create an object from JSON
  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      trackingId: json['trackingId'],
      productName: json['productName'],
      productImage: json['productImage'],
      customer: json['customer'],
      category: json['category'],
      subCategory: json['subCategory'],
      equipmentType: json['equipmentType'],
      status: json['status'],
    );
  }

  // Convert an object to JSON
  Map<String, dynamic> toJson() {
    return {
      'trackingId': trackingId,
      'productName': productName,
      'productImage': productImage,
      'customer': customer,
      'category': category,
      'subCategory': subCategory,
      'equipmentType': equipmentType,
      'status': status,
    };
  }
}
