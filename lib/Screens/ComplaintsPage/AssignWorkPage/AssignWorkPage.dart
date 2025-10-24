import 'package:castle/Colors/Colors.dart';
import 'package:castle/Controlls/ComplaintController/ComplaintController.dart';
import 'package:castle/Controlls/WorkersController/WorkerController.dart';
import 'package:castle/Controlls/DepartmentController/DepartmentController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AssignWorkPage extends StatelessWidget {
  final String complaintId;

  const AssignWorkPage({super.key, required this.complaintId});

  @override
  Widget build(BuildContext context) {
    final ComplaintController assignController = Get.find();
    final WorkerController workerController = Get.find<WorkerController>();
    final DepartmentController deptController = Get.put(DepartmentController());
    deptController.getDepartment();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assign Work'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Department Dropdown
                _buildDepartmentDropdown(
                    deptController, workerController, assignController),

                const SizedBox(height: 20),
                // Team Lead Dropdown (filtered by department)
                _buildTeamLeadDropdown(workerController, assignController),

                const SizedBox(height: 20),
                // Add Worker Button (filtered by department)
                _buildWorkerSelector(
                    context, workerController, assignController),

                const SizedBox(height: 20),
                // Due Date Picker
                _buildDueDatePicker(context, assignController),

                const SizedBox(height: 30),
                // Assign Button
                ElevatedButton(
                  onPressed: assignController.isLoading.value
                      ? null
                      : () {
                          if (assignController.selectedTeamLead.isEmpty) {
                            Get.snackbar('Error', 'Please select a team lead');
                            return;
                          }
                          if (assignController.selectedWorkers.isEmpty) {
                            Get.snackbar(
                                'Error', 'Please select at least one worker');
                            return;
                          }
                          assignController.assignComplaint(
                            complaintId,
                            teamLeadId: assignController.selectedTeamLead.value,
                            workerIds: assignController.selectedWorkers,
                            dueDate: assignController.dueDate.value,
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    backgroundColor: buttonColor,
                    foregroundColor: backgroundColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: assignController.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Assign Work',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ],
            )),
      ),
    );
  }

  Widget _buildDepartmentDropdown(DepartmentController deptController,
      WorkerController workerController, ComplaintController assignController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Department',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButton<String>(
            dropdownColor: backgroundColor,
            isExpanded: true,
            value: assignController.selectedDepartment.value.isEmpty
                ? null
                : assignController.selectedDepartment.value,
            hint: const Text('Select Department'),
            underline: const SizedBox(),
            items: deptController.departDetails.map((dept) {
              return DropdownMenuItem<String>(
                value: dept.id,
                child: Text(dept.name ?? ''),
              );
            }).toList(),
            onChanged: (value) async {
              if (value == null) return;
              assignController.selectedDepartment.value = value;
              assignController.selectedTeamLead.value = '';
              assignController.selectedWorkers.clear();
              workerController.workersDataByDep.clear();
              // Call API to fetch workers by department
              await workerController.getWorkerByDepartment(value);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTeamLeadDropdown(
      WorkerController workerController, ComplaintController assignController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Team Lead',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButton<String>(
            dropdownColor: backgroundColor,
            isExpanded: true,
            value: assignController.selectedTeamLead.value.isEmpty
                ? null
                : assignController.selectedTeamLead.value,
            hint: const Text('Select Team Lead'),
            underline: const SizedBox(),
            items: workerController.workersDataByDep.map((worker) {
              return DropdownMenuItem<String>(
                value: worker.id,
                child: Text("${worker.firstName} ${worker.lastName}"),
              );
            }).toList(),
            onChanged: (value) {
              assignController.selectedTeamLead.value = value ?? '';
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWorkerSelector(BuildContext context,
      WorkerController workerController, ComplaintController assignController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Assign Workers',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            _showWorkerSelectionDialog(
                context, workerController, assignController);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            foregroundColor: backgroundColor,
          ),
          child: const Text("Add Workers"),
        ),
        const SizedBox(height: 10),
        Obx(() => Wrap(
              spacing: 8,
              runSpacing: 4,
              children: assignController.selectedWorkers.map((id) {
                final worker = workerController.workerList
                    .firstWhereOrNull((w) => w.id == id);
                if (worker == null) return const SizedBox.shrink();
                return Chip(
                  backgroundColor: borderColor,
                  label: Text("${worker.firstName} ${worker.lastName}"),
                  onDeleted: () {
                    assignController.selectedWorkers.remove(id);
                  },
                );
              }).toList(),
            )),
      ],
    );
  }

  void _showWorkerSelectionDialog(BuildContext context,
      WorkerController workerController, ComplaintController assignController) {
    assignController.tempSelectedWorkers.value =
        List.from(assignController.selectedWorkers);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select Workers"),
          content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: workerController.workersDataByDep.length,
                itemBuilder: (context, index) {
                  final worker = workerController.workersDataByDep[index];
                  RxBool isSelected = assignController.tempSelectedWorkers
                      .contains(worker.id)
                      .obs;

                  return Obx(() => CheckboxListTile(
                        title: Text("${worker.firstName} ${worker.lastName}"),
                        value: isSelected.value,
                        onChanged: (value) {
                          if (value == true) {
                            isSelected.value = true;
                            if (!assignController.tempSelectedWorkers
                                .contains(worker.id)) {
                              assignController.tempSelectedWorkers
                                  .add(worker.id!);
                            }
                          } else {
                            isSelected.value = false;
                            assignController.tempSelectedWorkers
                                .remove(worker.id);
                          }
                        },
                      ));
                },
              )),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                assignController.selectedWorkers.value =
                    List.from(assignController.tempSelectedWorkers);
                Navigator.of(context).pop();
              },
              child: const Text("Done"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDueDatePicker(
      BuildContext context, ComplaintController assignController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Due Date',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Obx(() => InkWell(
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: assignController.dueDate.value,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );

                if (pickedDate != null) {
                  assignController.dueDate.value = pickedDate;
                }
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Text(
                      _formatDate(assignController.dueDate.value),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Spacer(),
                    const Icon(Icons.calendar_today, size: 20),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}
