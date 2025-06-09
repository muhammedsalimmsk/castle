import 'package:castle/Widget/CustomPhoneNumberField.dart';
import 'package:castle/Widget/CustomTextField.dart';
import 'package:castle/Widget/DropDownWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Colors/Colors.dart';
import '../../../Controlls/ComplaintController/NewComplaintController/NewComplaintController.dart';
import 'Widgets/TaskAddWidgetOne.dart';
class NewComplaintRegister extends StatelessWidget {
  const NewComplaintRegister({super.key});

  @override
  Widget build(BuildContext context) {
    final NewComplaintController controller = Get.put(NewComplaintController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        centerTitle: true,
        title: Text("Complaint Register"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: PageView(
                controller: controller.pageController,
                onPageChanged: (index) => controller.currentPage.value = index,
                children: [
                  // 🔹 Page 1: Client Details
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Client Details",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      progressIndicator(controller.currentPage.value, 0),
                      SizedBox(height: 40),
                      DropDownOptionWidget(
                        hint: "Client Name",
                        options: ["John", "Midlaj", "No one"],
                        label: 'Client Name',
                      ),
                      SizedBox(height: 20),
                      CustomPhoneNumberField(),
                      SizedBox(height: 20),
                      CustomTextField(hint: "Email"),
                      SizedBox(height: 20),
                      CustomTextField(hint: "Contact person name"),
                    ],
                  ),

                  // 🔹 Page 2: Complaint Details
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Assign Work",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        progressIndicator(controller.currentPage.value, 1),
                        SizedBox(height: 20),
                        SizedBox(
                          height: 640,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    VideoSection(),
                                    SizedBox(height: 20),
                                    WorkDetails(),
                                    SizedBox(height: 10,),
                                    TaskAddWidgetOne(),
                                    SizedBox(height: 10),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                    
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 🔹 Bottom Button (Next / Submit)
            Obx(() => InkWell(
              onTap: controller.nextPage,
              child: Container(
                padding: EdgeInsets.all(12),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: containerColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    controller.currentPage.value == 0 ? "Next" : "Submit",
                    style: TextStyle(
                      color: backgroundColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  // 🔹 Progress Indicator Function
  Widget progressIndicator(int currentPage, int page) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "Step ${page + 1} of 2",
          style: TextStyle(color: containerColor),
        ),
        SizedBox(height: 8),
        LinearProgressIndicator(
          value: (page == 0) ? 0.5 : 1.0,
          backgroundColor: shadeColor,
          valueColor: AlwaysStoppedAnimation<Color>(containerColor),
          minHeight: 8,
        ),
      ],
    );
  }
}

class VideoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 230,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/complaint.jpeg'),
            fit: BoxFit.cover),
        color: Colors.black12,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Icon(Icons.play_circle_fill, size: 50, color: Colors.white),
      ),
    );
  }
}

class WorkDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Air Conditioner (AC)",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        Text("Performance Issue - 18/12/2024"),
        SizedBox(height: 10),
        Text("Description",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        Text("Follow the video tutorial above..."),
        SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
            hintText: "Your text goes here",
            border: OutlineInputBorder(),
          ),
          maxLines: 5,
        ),
      ],
    );
  }
}