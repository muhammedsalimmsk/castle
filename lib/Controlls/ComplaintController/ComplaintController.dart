import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ComplaintController extends GetxController {
  final ScrollController scrollController = ScrollController();

  void scrollToRight() {
    scrollController.animateTo(
      scrollController.offset + 410,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void scrollToLeft() {
    scrollController.animateTo(
      scrollController.offset - 410,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
