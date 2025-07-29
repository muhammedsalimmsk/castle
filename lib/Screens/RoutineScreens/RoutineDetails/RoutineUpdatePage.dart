import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Colors/Colors.dart';
import '../../../Controlls/AssignRoutineController/RoutineController.dart';
import '../../../Model/routine_model/datum.dart';

class UpdateRoutinePage extends StatelessWidget {
  final RoutineDetail routineDetail;

  UpdateRoutinePage({super.key, required this.routineDetail});

  final AssignRoutineController controller = Get.put(AssignRoutineController());

  @override
  Widget build(BuildContext context) {
    _prefillData();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Routine"),
        backgroundColor: backgroundColor,
        foregroundColor: containerColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTextField("Name", controller.nameController),
              const SizedBox(height: 12),
              _buildTextField("Description", controller.descriptionController,
                  maxLines: 3),
              const SizedBox(height: 12),
              _buildFrequencyDropdown(),
              const SizedBox(height: 12),
              _buildTimePicker(context),
              const SizedBox(height: 12),
              _buildWorkerSelector(context),
              const SizedBox(height: 24),
              Obx(() => controller.isSubmitting.value
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        final data = {
                          "name": controller.nameController.text.trim(),
                          "description":
                              controller.descriptionController.text.trim(),
                          "frequency": controller.selectedFrequency.value,
                          "timeSlot": controller.selectedTime.value,
                          "assignedWorkerId": controller.selectedWorkerId,
                        };
                        controller.updateRoutine(routineDetail.id!, data);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: containerColor,
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text("Update Routine",
                          style: TextStyle(color: backgroundColor)),
                    )),
            ],
          ),
        ),
      ),
    );
  }

  void _prefillData() {
    controller.nameController.text = routineDetail.name ?? '';
    controller.descriptionController.text = routineDetail.description ?? '';
    controller.selectedFrequency.value = routineDetail.frequency ?? 'DAILY';
    controller.selectedTime.value = routineDetail.timeSlot ?? '';
    controller.selectedWorkerId = '';
    controller.selectedWorkerName.value =
        "${routineDetail.assignedWorker?.firstName ?? ''} ${routineDetail.assignedWorker?.lastName ?? ''}";
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: containerColor)),
      ),
    );
  }

  Widget _buildFrequencyDropdown() {
    return Obx(() => DropdownButtonFormField<String>(
          value: controller.selectedFrequency.value,
          decoration: _inputDecoration("Frequency"),
          items: ["DAILY", "WEEKLY", "MONTHLY"]
              .map((f) => DropdownMenuItem(value: f, child: Text(f)))
              .toList(),
          onChanged: (val) {
            if (val != null) controller.selectedFrequency.value = val;
          },
        ));
  }

  Widget _buildTimePicker(BuildContext context) {
    return Obx(() => InkWell(
          onTap: () => controller.pickTime(context),
          child: InputDecorator(
            decoration: _inputDecoration("Time Slot"),
            child: Text(
              controller.selectedTime.value.isEmpty
                  ? "Tap to select time"
                  : controller.selectedTime.value,
            ),
          ),
        ));
  }

  Widget _buildWorkerSelector(BuildContext context) {
    return Obx(() => ElevatedButton(
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
        ));
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
}
