import 'package:castle/Controlls/EquipmentController/EquipmentController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Colors/Colors.dart';
import '../../../Controlls/AssignRoutineController/RoutineController.dart';

class AssignRoutinePage extends StatelessWidget {
  AssignRoutinePage({
    super.key,
  });

  final AssignRoutineController controller = Get.put(AssignRoutineController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Assign Routine"),
        backgroundColor: backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  _buildTextField("Name", controller.nameController),
                  const SizedBox(height: 12),
                  _buildTextField(
                      "Description", controller.descriptionController,
                      maxLines: 3),
                  const SizedBox(height: 12),

                  // Frequency Dropdown
                  Obx(() => DropdownButtonFormField<String>(
                        value: controller.selectedFrequency.value,
                        onChanged: (val) {
                          if (val != null)
                            controller.selectedFrequency.value = val;
                        },
                        items: ["DAILY", "WEEKLY", "MONTHLY"]
                            .map((f) => DropdownMenuItem(
                                  value: f,
                                  child: Text(f),
                                ))
                            .toList(),
                        decoration: _inputDecoration("Frequency"),
                      )),

                  const SizedBox(height: 12),

                  // Time Picker
                  Obx(() => InkWell(
                        onTap: () => controller.pickTime(context),
                        child: InputDecorator(
                          decoration: _inputDecoration("Select Time"),
                          child: Text(controller.selectedTime.value.isEmpty
                              ? "Tap to pick time"
                              : controller.selectedTime.value),
                        ),
                      )),

                  const SizedBox(height: 12),

                  // Day of Week
                  Obx(() => controller.selectedFrequency.value == "WEEKLY"
                      ? DropdownButtonFormField<int>(
                          value: controller.selectedDayOfWeek.value,
                          onChanged: (val) {
                            if (val != null) {
                              controller.selectedDayOfWeek.value = val;
                            }
                          },
                          items: List.generate(7, (i) {
                            final days = [
                              "Sunday",
                              "Monday",
                              "Tuesday",
                              "Wednesday",
                              "Thursday",
                              "Friday",
                              "Saturday"
                            ];
                            return DropdownMenuItem(
                                value: i, child: Text(days[i]));
                          }),
                          decoration: _inputDecoration("Day of Week"),
                        )
                      : const SizedBox()),

                  // Day of Month
                  Obx(() => controller.selectedFrequency.value == "MONTHLY"
                      ? DropdownButtonFormField<int>(
                          value: controller.selectedDayOfMonth.value,
                          onChanged: (val) {
                            if (val != null) {
                              controller.selectedDayOfMonth.value = val;
                            }
                          },
                          items: List.generate(31, (i) {
                            return DropdownMenuItem(
                                value: i + 1, child: Text((i + 1).toString()));
                          }),
                          decoration: _inputDecoration("Day of Month"),
                        )
                      : const SizedBox()),

                  const SizedBox(height: 12),

                  // Equipment Selector (assume controller.partsList from another controller)
                  Obx(() => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: containerColor),
                          ),
                          minimumSize: const Size.fromHeight(50),
                        ),
                        onPressed: () => _showEquipmentDialog(context),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            controller.selectedEquipmentName.value.isEmpty
                                ? "Select Equipment"
                                : controller.selectedEquipmentName.value,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Obx(() => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: containerColor),
                          ),
                          minimumSize: const Size.fromHeight(50),
                        ),
                        onPressed: () => _showWorkerDialog(context),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            controller.selectedWorkerName.value.isEmpty
                                ? "Select Worker"
                                : controller.selectedWorkerName.value,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      )),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Obx(() => controller.isSubmitting.value
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () =>
                          controller.submitRoutine(controller.selectedWorkerId),
                      // controller.submitRoutine(assignedWorkerId),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: containerColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10), // 👈 sets border radius
                        ),
                        minimumSize: const Size.fromHeight(50),
                      ),
                      child: const Text(
                        "Assign Routine",
                        style: TextStyle(color: backgroundColor),
                      ),
                    )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: _inputDecoration(label),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: containerColor)),
    );
  }

  void _showWorkerDialog(BuildContext context) async {
    final assignController = Get.find<AssignRoutineController>();
    final TextEditingController searchController = TextEditingController();
    RxList filteredList = <dynamic>[].obs;
    RxBool isLoading = true.obs;
    RxBool isError = false.obs;

    // Call API when dialog opens
    assignController.getWorkers().then((_) {
      isLoading.value = false;
      isError.value = false;
      filteredList.assignAll(assignController.workerList);
    }).catchError((error) {
      isLoading.value = false;
      isError.value = true;
    });

    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: backgroundColor,
        child: Container(
          padding: const EdgeInsets.all(16),
          height: 400,
          width: double.infinity,
          child: Column(
            children: [
              Obx(() {
                if (isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                } else if (isError.value) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Failed to load workers."),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          isLoading.value = true;
                          isError.value = false;
                          assignController.getWorkers().then((_) {
                            isLoading.value = false;
                            filteredList.assignAll(assignController.workerList);
                          }).catchError((error) {
                            isLoading.value = false;
                            isError.value = true;
                          });
                        },
                        child: const Text("Retry"),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      TextField(
                        controller: searchController,
                        decoration: const InputDecoration(
                          labelText: 'Search Worker',
                          prefixIcon: Icon(Icons.search),
                        ),
                        onChanged: (value) {
                          filteredList.value = assignController.workerList
                              .where((worker) =>
                                  ('${worker.firstName} ${worker.lastName}')
                                      .toLowerCase()
                                      .contains(value.toLowerCase()))
                              .toList();
                        },
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 280,
                        child: Obx(() => ListView.builder(
                              itemCount: filteredList.length,
                              itemBuilder: (context, index) {
                                final worker = filteredList[index];
                                return ListTile(
                                  title: Text(
                                      '${worker.firstName} ${worker.lastName}'),
                                  onTap: () {
                                    assignController.selectedWorkerName.value =
                                        '${worker.firstName} ${worker.lastName}';
                                    assignController.selectedWorkerId =
                                        worker.id ?? '';
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            )),
                      ),
                    ],
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _showEquipmentDialog(BuildContext context) async {
    final assignController = Get.find<AssignRoutineController>();
    final TextEditingController searchController = TextEditingController();
    RxList filteredList = <dynamic>[].obs;
    RxBool isLoading = true.obs;
    RxBool isError = false.obs;

    // Call API when dialog opens
    assignController.getEquipment().then((_) {
      isLoading.value = false;
      isError.value = false;
      filteredList.assignAll(assignController.equipmentDetail);
    }).catchError((error) {
      isLoading.value = false;
      isError.value = true;
    });

    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: backgroundColor,
        child: Container(
          padding: const EdgeInsets.all(16),
          height: 400,
          width: double.infinity,
          child: Column(
            children: [
              Obx(() {
                if (isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                } else if (isError.value) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Failed to load equipment."),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          isLoading.value = true;
                          isError.value = false;
                          assignController.getEquipment().then((_) {
                            isLoading.value = false;
                            filteredList
                                .assignAll(assignController.equipmentDetail);
                          }).catchError((error) {
                            isLoading.value = false;
                            isError.value = true;
                          });
                        },
                        child: const Text("Retry"),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      TextField(
                        controller: searchController,
                        decoration: const InputDecoration(
                          labelText: 'Search Equipment',
                          prefixIcon: Icon(Icons.search),
                        ),
                        onChanged: (value) {
                          filteredList.value = assignController.equipmentDetail
                              .where((equipment) => ('${equipment.name}')
                                  .toLowerCase()
                                  .contains(value.toLowerCase()))
                              .toList();
                        },
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 280,
                        child: Obx(() => ListView.builder(
                              itemCount: filteredList.length,
                              itemBuilder: (context, index) {
                                final equipment = filteredList[index];
                                return ListTile(
                                  title: Text(equipment.name),
                                  onTap: () {
                                    assignController.selectedEquipmentName
                                        .value = equipment.name;
                                    assignController.selectedEquipmentId.value =
                                        equipment.id ?? '';
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            )),
                      ),
                    ],
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
