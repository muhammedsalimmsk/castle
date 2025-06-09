import 'package:get/get.dart';
import 'package:flutter/material.dart';
class NewComplaintController extends GetxController {
  var currentPage = 0.obs; // Observable page index
  PageController pageController = PageController();

  void nextPage() {
    if (currentPage.value == 0) {
      pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      // Handle form submission here
      print("Form Submitted");
    }
  }
}