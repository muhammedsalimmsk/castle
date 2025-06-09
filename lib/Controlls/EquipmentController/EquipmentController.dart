import 'package:get/get.dart';

class EquipmentController extends GetxController {
  var selectedValue = "Name".obs;
  List<String> sortOptions = ["Name", "Price", "Rating"];
  var isOpen = false.obs;

  void toggle() {
    isOpen.value = !isOpen.value;
  }
}
