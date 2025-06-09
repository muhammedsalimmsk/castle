import 'package:castle/Colors/Colors.dart';
import 'package:castle/Controlls/EquipmentController/EquipmentController.dart';
import 'package:castle/Screens/ComplaintsPage/NewComplaint/NewComplaintPage.dart';
import 'package:castle/Screens/EquipmentPage/NewEquipments.dart';
import 'package:castle/Widget/CustomAppBarWidget.dart';
import 'package:castle/Widget/CustomDrawer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class ComplaintPage extends StatelessWidget {
  ComplaintPage({super.key});
  List<Equipment> equipmentList = [
    Equipment(
      trackingId: "#20462",
      productName: "HVAC System",
      productImageUrl: "https://www.lg.com/content/dam/channel/wcms/in/images/washing-machines/fhm1408bdl_alsqeil_eail_in_c/gallery/FHM1408BDL-Washing-Machines-Front-View-DZ-01-v1.jpg",
      customer: "Matt Dickerson",
      category: "Climate Control",
      subCategory: "Centralized Air Systems",
      equipmentType: "Central Air Conditioning Unit",
      status: "Working",
    ),
    Equipment(
      trackingId: "#18933",
      productName: "Commercial Kitchen Range",
      productImageUrl: 'https://www.lg.com/content/dam/channel/wcms/in/images/washing-machines/fhm1408bdl_alsqeil_eail_in_c/gallery/FHM1408BDL-Washing-Machines-Front-View-DZ-01-v1.jpg',
      customer: "Wiktoria",
      category: "Kitchen Equipment",
      subCategory: "Cooking Appliances",
      equipmentType: "Gas Stove with Oven",
      status: "Working",
    ),
    Equipment(
      trackingId: "#45169",
      productName: "Refrigeration System",
      productImageUrl: "https://www.lg.com/content/dam/channel/wcms/in/images/washing-machines/fhm1408bdl_alsqeil_eail_in_c/gallery/FHM1408BDL-Washing-Machines-Front-View-DZ-01-v1.jpg",
      customer: "Food Storage",
      category: "Food Storage",
      subCategory: "Cold Storage",
      equipmentType: "Walk-In Freezer",
      status: "On Work",
    ),
    Equipment(
      trackingId: "#34304",
      productName: "Laundry Machine",
      productImageUrl: "https://www.lg.com/content/dam/channel/wcms/in/images/washing-machines/fhm1408bdl_alsqeil_eail_in_c/gallery/FHM1408BDL-Washing-Machines-Front-View-DZ-01-v1.jpg",
      customer: "Brad Mason",
      category: "Housekeeping",
      subCategory: "Laundry Systems",
      equipmentType: "Commercial Washer and Dryer",
      status: "On Work",
    ),
    Equipment(
      trackingId: "#17188",
      productName: "Elevator",
      productImageUrl: "https://www.lg.com/content/dam/channel/wcms/in/images/washing-machines/fhm1408bdl_alsqeil_eail_in_c/gallery/FHM1408BDL-Washing-Machines-Front-View-DZ-01-v1.jpg",
      customer: "Sanderson",
      category: "Guest Transport",
      subCategory: "Vertical Lifting Systems",
      equipmentType: "Passenger Elevator",
      status: "Not Working",
    ),
    Equipment(
      trackingId: "#73003",
      productName: "Water Heater System",
      productImageUrl: "https://www.lg.com/content/dam/channel/wcms/in/images/washing-machines/fhm1408bdl_alsqeil_eail_in_c/gallery/FHM1408BDL-Washing-Machines-Front-View-DZ-01-v1.jpg",
      customer: "Jun Redfern",
      category: "Utility Equipment",
      subCategory: "Hot Water Supply",
      equipmentType: "Centralized Boiler",
      status: "Working",
    ),
    Equipment(
      trackingId: "#58825",
      productName: "Dishwasher",
      productImageUrl: "https://www.lg.com/content/dam/channel/wcms/in/images/washing-machines/fhm1408bdl_alsqeil_eail_in_c/gallery/FHM1408BDL-Washing-Machines-Front-View-DZ-01-v1.jpg",
      customer: "Miriam Kidd",
      category: "Kitchen Equipment",
      subCategory: "Cleaning Appliances",
      equipmentType: "Commercial Conveyor Dishwasher",
      status: "Working",
    ),
    Equipment(
      trackingId: "#44122",
      productName: "Fire Alarm System",
      productImageUrl: "https://www.lg.com/content/dam/channel/wcms/in/images/washing-machines/fhm1408bdl_alsqeil_eail_in_c/gallery/FHM1408BDL-Washing-Machines-Front-View-DZ-01-v1.jpg",
      customer: "Dominic",
      category: "Safety Equipment",
      subCategory: "Fire Detection",
      equipmentType: "Addressable Fire Alarm Panel",
      status: "Working",
    ),
    Equipment(
      trackingId: "#89094",
      productName: "Generator",
      productImageUrl: "https://www.lg.com/content/dam/channel/wcms/in/images/washing-machines/fhm1408bdl_alsqeil_eail_in_c/gallery/FHM1408BDL-Washing-Machines-Front-View-DZ-01-v1.jpg",
      customer: "Shanice",
      category: "Power Backup",
      subCategory: "Emergency Power Systems",
      equipmentType: "Diesel Generator",
      status: "On Work",
    ),
    Equipment(
      trackingId: "#85252",
      productName: "Swimming Pool Filtration System",
      productImageUrl: "https://www.lg.com/content/dam/channel/wcms/in/images/washing-machines/fhm1408bdl_alsqeil_eail_in_c/gallery/FHM1408BDL-Washing-Machines-Front-View-DZ-01-v1.jpg",
      customer: "Poppy-Rose",
      category: "Recreation",
      subCategory: "Water Treatment",
      equipmentType: "Sand Filter System",
      status: "On Work",
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
                            borderSide: BorderSide(color: shadeColor)),
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
                    padding: EdgeInsets.all(12),
                    // width: 50, // Adjust width
                    // height: 50, // Adjust height
                    decoration: BoxDecoration(
                      border: Border.all(color: shadeColor),
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
                  "Complaints",
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
              height: MediaQuery.of(context).size.height*0.72,
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
                                        equipmentList[index].productImageUrl),
                                    fit: BoxFit.cover)),
                          ),
                          title: Text(
                            equipmentList[index].productName,
                            style: TextStyle(color: containerColor,fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(equipmentList[index].customer),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(equipmentList[index].category,style: TextStyle(color: buttonColor),),
                                  Text(equipmentList[index].status),
                                ],
                              ),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.more_vert,
                                    color: buttonColor,
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
          Get.to(NewComplaintRegister());
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
  final String productImageUrl;
  final String customer;
  final String category;
  final String subCategory;
  final String equipmentType;
  final String status;

  Equipment({
    required this.trackingId,
    required this.productName,
    required this.productImageUrl,
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
      productImageUrl: json['productImage'],
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
      'productImage': productImageUrl,
      'customer': customer,
      'category': category,
      'subCategory': subCategory,
      'equipmentType': equipmentType,
      'status': status,
    };
  }
}
