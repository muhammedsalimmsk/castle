import 'package:castle/Colors/Colors.dart';
import 'package:castle/Controlls/AuthController/AuthController.dart';
import 'package:castle/Controlls/ComplaintController/ComplaintController.dart';
import 'package:castle/Controlls/WorkersController/WorkerController.dart';
import 'package:castle/Controlls/DepartmentController/DepartmentController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AssignWorkPage extends StatefulWidget {
  final String complaintId;
  bool? isUpdating;
  AssignWorkPage(
      {super.key, required this.complaintId, this.isUpdating = false});

  @override
  State<AssignWorkPage> createState() => _AssignWorkPageState();
}

class _AssignWorkPageState extends State<AssignWorkPage> {
  final TextEditingController commentController = TextEditingController();

  bool isCheckingUpdate = true;
  late DepartmentController deptController;

  @override
  void initState() {
    super.initState();
    deptController = Get.put(DepartmentController());
    deptController.getDepartment();
    _checkIfUpdating();
  }

  Future<void> _checkIfUpdating() async {
    final ComplaintController assignController = Get.find();

    try {
      await assignController.fetchComplaintDetails(
        widget.complaintId,
        userDetailModel!.data!.role!.toLowerCase(),
      );

      // Ensure isLoading is reset after fetch
      if (assignController.isLoading.value) {
        assignController.isLoading.value = false;
      }

      if (mounted) {
        final hasAssignedWorkers =
            assignController.complaintDetailModel.data?.assignedWorkers !=
                    null &&
                assignController
                    .complaintDetailModel.data!.assignedWorkers!.isNotEmpty;

        print(
            'AssignWorkPage - Checking if updating: hasAssignedWorkers = $hasAssignedWorkers');
        print(
            'AssignWorkPage - assignedWorkers count: ${assignController.complaintDetailModel.data?.assignedWorkers?.length ?? 0}');

        setState(() {
          widget.isUpdating = hasAssignedWorkers;
          isCheckingUpdate = false;
        });

        print('AssignWorkPage - isUpdating set to: $widget.isUpdating');
      }
    } catch (e) {
      // Ensure isLoading is reset even on error
      if (assignController.isLoading.value) {
        assignController.isLoading.value = false;
      }
      if (mounted) {
        setState(() {
          isCheckingUpdate = false;
        });
      }
    }
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ComplaintController assignController = Get.find();
    final WorkerController workerController = Get.find<WorkerController>();

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: backgroundColor,
        title: const Text('Assign Work'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      backgroundColor: Colors.white,
      body: isCheckingUpdate
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
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

                    // Comment Section (only shown when updating)
                    if (widget.isUpdating!) ...[
                      const SizedBox(height: 20),
                      _buildCommentSection(assignController),
                    ],

                    const SizedBox(height: 30),
                    // Assign/Update Button
                    Obx(() => ElevatedButton(
                          onPressed: assignController.isLoading.value
                              ? null
                              : () async {
                                  if (assignController
                                      .selectedTeamLead.isEmpty) {
                                    Get.snackbar(
                                        'Error', 'Please select a team lead');
                                    return;
                                  }
                                  if (assignController
                                      .selectedWorkers.isEmpty) {
                                    Get.snackbar('Error',
                                        'Please select at least one worker');
                                    return;
                                  }

                                  // Assign complaint
                                  await assignController.assignComplaint(
                                    widget.complaintId,
                                    teamLeadId:
                                        assignController.selectedTeamLead.value,
                                    workerIds: assignController.selectedWorkers,
                                    dueDate: assignController.dueDate.value,
                                  );

                                  // If updating and comment is provided, add comment
                                  if (widget.isUpdating! &&
                                      commentController.text
                                          .trim()
                                          .isNotEmpty) {
                                    await assignController
                                        .updateComplaintComment(
                                      userDetailModel!.data!.role!
                                          .toLowerCase(),
                                      widget.complaintId,
                                      commentController.text.trim(),
                                    );
                                    commentController.clear();
                                  }
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
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : Text(
                                  widget.isUpdating!
                                      ? 'Update Work'
                                      : 'Assign Work',
                                  style: const TextStyle(fontSize: 16),
                                ),
                        )),
                  ],
                ),
              ),
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
        Obx(() => Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: deptController.isLoading.value
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : DropdownButton<String>(
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
                        await workerController.getWorkerByDepartment(
                          value,
                        );
                      },
                    ),
            )),
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
        Obx(() => Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: assignController.selectedDepartment.value.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        'Please select a department first',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    )
                  : workerController.workersDataByDep.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : DropdownButton<String>(
                          dropdownColor: backgroundColor,
                          isExpanded: true,
                          value: assignController.selectedTeamLead.value.isEmpty
                              ? null
                              : assignController.selectedTeamLead.value,
                          hint: const Text('Select Team Lead'),
                          underline: const SizedBox(),
                          items:
                              workerController.workersDataByDep.map((worker) {
                            return DropdownMenuItem<String>(
                              value: worker.id,
                              child: Text(
                                  "${worker.firstName} ${worker.lastName}"),
                            );
                          }).toList(),
                          onChanged: (value) {
                            assignController.selectedTeamLead.value =
                                value ?? '';
                          },
                        ),
            )),
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
          backgroundColor: backgroundColor,
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
              child: const Text(
                "Cancel",
                style: TextStyle(color: buttonColor),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
              onPressed: () {
                assignController.selectedWorkers.value =
                    List.from(assignController.tempSelectedWorkers);
                Navigator.of(context).pop();
              },
              child: const Text(
                "Done",
                style: TextStyle(color: backgroundColor),
              ),
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

  Widget _buildCommentSection(ComplaintController assignController) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: dividerColor,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: cardShadowColor.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.add_comment_outlined,
                color: buttonColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                "Reason",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: containerColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: commentController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: "Type your reason here...",
              hintStyle: TextStyle(
                color: subtitleColor,
                fontSize: 14,
              ),
              filled: true,
              fillColor: searchBackgroundColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: dividerColor,
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: dividerColor,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: buttonColor,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            style: TextStyle(
              color: containerColor,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
