import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Colors/Colors.dart';
import '../../../Controlls/AssignRoutineController/RoutineController.dart';
import '../../../Model/routine_model/datum.dart';
import '../../../Utils/ResponsiveHelper.dart';

class UpdateRoutinePage extends StatefulWidget {
  final RoutineDetail routineDetail;

  const UpdateRoutinePage({super.key, required this.routineDetail});

  @override
  State<UpdateRoutinePage> createState() => _UpdateRoutinePageState();
}

class _UpdateRoutinePageState extends State<UpdateRoutinePage> {
  final AssignRoutineController controller = Get.find<AssignRoutineController>();
  bool _hasPrefilled = false;

  @override
  void initState() {
    super.initState();
    // Prefill data only once when the page is first created
    _prefillData();
    _hasPrefilled = true;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: buttonColor),
          onPressed: () {
            Get.back(closeOverlays: false);
          },
        ),
        title: Text(
          "Update Routine",
          style: TextStyle(
            color: containerColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: ResponsiveHelper.getMaxContentWidth(context),
            ),
            child: Padding(
              padding: ResponsiveHelper.getResponsivePadding(context),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    _buildTextField("Name", controller.nameController),
                    const SizedBox(height: 16),
                    _buildTextField(
                        "Description", controller.descriptionController,
                        maxLines: 3),
                    const SizedBox(height: 16),

                    // Frequency Dropdown
                    Obx(() => _buildDropdownContainer(
                          child: DropdownButtonFormField<String>(
                            value: controller.selectedFrequency.value,
                            onChanged: (val) {
                              if (val != null) {
                                controller.selectedFrequency.value = val;
                              }
                            },
                            items: ["DAILY", "WEEKLY", "MONTHLY"]
                                .map((f) => DropdownMenuItem(
                                      value: f,
                                      child: Text(
                                        f,
                                        style: TextStyle(color: containerColor),
                                      ),
                                    ))
                                .toList(),
                            decoration: _inputDecoration("Frequency"),
                            style: TextStyle(color: containerColor),
                            dropdownColor: backgroundColor,
                            icon:
                                Icon(Icons.arrow_drop_down, color: buttonColor),
                          ),
                        )),

                    const SizedBox(height: 16),

                    // Time Picker
                    Obx(() => _buildDropdownContainer(
                          child: InkWell(
                            onTap: () => controller.pickTime(context),
                            child: InputDecorator(
                              decoration: _inputDecoration("Select Time"),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    controller.selectedTime.value.isEmpty
                                        ? "Tap to pick time"
                                        : controller.selectedTime.value,
                                    style: TextStyle(
                                      color:
                                          controller.selectedTime.value.isEmpty
                                              ? subtitleColor
                                              : containerColor,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Icon(Icons.access_time,
                                      color: buttonColor, size: 20),
                                ],
                              ),
                            ),
                          ),
                        )),

                    const SizedBox(height: 16),

                    // Day of Week
                    Obx(() => controller.selectedFrequency.value == "WEEKLY"
                        ? Column(
                            children: [
                              _buildDropdownContainer(
                                child: DropdownButtonFormField<int>(
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
                                        value: i,
                                        child: Text(
                                          days[i],
                                          style:
                                              TextStyle(color: containerColor),
                                        ));
                                  }),
                                  decoration: _inputDecoration("Day of Week"),
                                  style: TextStyle(color: containerColor),
                                  dropdownColor: backgroundColor,
                                  icon: Icon(Icons.arrow_drop_down,
                                      color: buttonColor),
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          )
                        : const SizedBox()),

                    // Day of Month
                    Obx(() => controller.selectedFrequency.value == "MONTHLY"
                        ? Column(
                            children: [
                              _buildDropdownContainer(
                                child: DropdownButtonFormField<int>(
                                  value: controller.selectedDayOfMonth.value,
                                  onChanged: (val) {
                                    if (val != null) {
                                      controller.selectedDayOfMonth.value = val;
                                    }
                                  },
                                  items: List.generate(31, (i) {
                                    return DropdownMenuItem(
                                        value: i + 1,
                                        child: Text(
                                          (i + 1).toString(),
                                          style:
                                              TextStyle(color: containerColor),
                                        ));
                                  }),
                                  decoration: _inputDecoration("Day of Month"),
                                  style: TextStyle(color: containerColor),
                                  dropdownColor: backgroundColor,
                                  icon: Icon(Icons.arrow_drop_down,
                                      color: buttonColor),
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          )
                        : const SizedBox()),

                    // Worker Selector
                    Obx(() => _buildSelectorButton(
                          label: controller.selectedWorkerName.value.isEmpty
                              ? "Select Worker"
                              : controller.selectedWorkerName.value,
                          icon: Icons.person_outline,
                          onPressed: () => _showWorkerDialog(context),
                        )),
                    const SizedBox(height: 16),
                    // Equipment Readings Section
                    _buildReadingsSection(),
                    const SizedBox(height: 32),
                    // Submit Button
                    Obx(() {
                      if (controller.isSubmitting.value) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(buttonColor),
                                  strokeWidth: 2,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                "Updating Routine...",
                                style: TextStyle(
                                  color: buttonColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  buttonColor,
                                  buttonColor.withOpacity(0.8),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: buttonColor.withOpacity(0.4),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                // Form validation
                                final name = controller.nameController.text.trim();
                                final timeSlot = controller.selectedTime.value;
                                final workerId = controller.selectedWorkerId;

                                if (name.isEmpty) {
                                  Get.snackbar("Validation Error", "Please enter a routine name",
                                      backgroundColor: Colors.redAccent, colorText: Colors.white);
                                  return;
                                }

                                if (timeSlot.isEmpty) {
                                  Get.snackbar("Validation Error", "Please select a time",
                                      backgroundColor: Colors.redAccent, colorText: Colors.white);
                                  return;
                                }

                                // Validate time format (HH:MM)
                                final timeRegex = RegExp(r'^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$');
                                if (!timeRegex.hasMatch(timeSlot)) {
                                  Get.snackbar("Validation Error", "Please select a valid time",
                                      backgroundColor: Colors.redAccent, colorText: Colors.white);
                                  return;
                                }

                                if (workerId.isEmpty) {
                                  Get.snackbar("Validation Error", "Please select a worker",
                                      backgroundColor: Colors.redAccent, colorText: Colors.white);
                                  return;
                                }

                                final data = {
                                  "name": name,
                                  "description": controller.descriptionController.text.trim(),
                                  "frequency": controller.selectedFrequency.value,
                                  "timeSlot": timeSlot,
                                  "assignedWorkerId": workerId,
                                  "readings": controller.readings.toList(),
                                };

                                print("DEBUG: Update button pressed");
                                print("DEBUG: Form data: $data");
                                // Conditionally add fields
                                if (controller.selectedFrequency.value == "WEEKLY") {
                                  data["dayOfWeek"] = controller.selectedDayOfWeek.value;
                                }

                                if (controller.selectedFrequency.value == "MONTHLY") {
                                  data["dayOfMonth"] = controller.selectedDayOfMonth.value;
                                }

                                controller.updateRoutine(widget.routineDetail.id!, data);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                minimumSize: const Size.fromHeight(56),
                              ),
                              child: Text(
                                "Update Routine",
                                style: TextStyle(
                                  color: backgroundColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          );
                        }),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _prefillData() {
    // Only prefill if we haven't already done so
    if (_hasPrefilled) return;
    
    controller.nameController.text = widget.routineDetail.name ?? '';
    controller.descriptionController.text = widget.routineDetail.description ?? '';
    controller.selectedFrequency.value = widget.routineDetail.frequency ?? 'DAILY';
    controller.selectedTime.value = widget.routineDetail.timeSlot ?? '';
    controller.selectedDayOfWeek.value = widget.routineDetail.dayOfWeek ?? 0;
    controller.selectedDayOfMonth.value = widget.routineDetail.dayOfMonth ?? 1;
    controller.selectedWorkerId = widget.routineDetail.assignedWorkerId ?? '';
    controller.selectedWorkerName.value =
        "${widget.routineDetail.assignedWorker?.firstName ?? ''} ${widget.routineDetail.assignedWorker?.lastName ?? ''}";
    // Prefill equipment if available
    if (widget.routineDetail.equipment != null) {
      controller.selectedEquipmentName.value = widget.routineDetail.equipment!.name ?? '';
      controller.selectedEquipmentId.value = widget.routineDetail.equipmentId ?? '';
    }
    // Prefill client if available (client is associated with equipment)
    if (widget.routineDetail.equipment?.client != null) {
      controller.selectedClientName.value = widget.routineDetail.equipment!.client!.hotelName ?? '';
      // Client ID is not available in routine model, but client is linked via equipment
    }
    // Prefill readings from routineDetail if they exist
    controller.readings.clear();
    if (widget.routineDetail.readings != null && widget.routineDetail.readings!.isNotEmpty) {
      print("DEBUG: Prefilling readings: ${widget.routineDetail.readings}");
      controller.readings.addAll(widget.routineDetail.readings!);
      print("DEBUG: Controller readings after prefill: ${controller.readings}");
    } else {
      print("DEBUG: No readings to prefill or readings is null/empty");
    }
  }

  Widget _buildDropdownContainer({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: cardShadowColor.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSelectorButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: cardShadowColor.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: dividerColor,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: buttonColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: buttonColor, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: label.contains("Select")
                          ? subtitleColor
                          : containerColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right, color: subtitleColor, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: cardShadowColor.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: TextStyle(
          color: containerColor,
          fontSize: 15,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: subtitleColor,
            fontSize: 14,
          ),
          hintStyle: TextStyle(
            color: subtitleColor,
            fontSize: 15,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          filled: true,
          fillColor: backgroundColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: dividerColor,
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: dividerColor,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: buttonColor,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReadingsSection() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
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
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: buttonColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:
                      Icon(Icons.speed_outlined, color: buttonColor, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  "Equipment Readings",
                  style: TextStyle(
                    color: containerColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: dividerColor,
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller.readingController,
                          style: TextStyle(
                            color: containerColor,
                            fontSize: 15,
                          ),
                          decoration: InputDecoration(
                            hintText: "Enter reading name",
                            hintStyle: TextStyle(
                              color: subtitleColor,
                              fontSize: 15,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
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
                          ),
                          onSubmitted: (value) {
                            if (value.trim().isNotEmpty) {
                              controller.readings.add(value.trim());
                              controller.readingController.clear();
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              buttonColor,
                              buttonColor.withOpacity(0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              if (controller.readingController.text
                                  .trim()
                                  .isNotEmpty) {
                                controller.readings.add(
                                    controller.readingController.text.trim());
                                controller.readingController.clear();
                              }
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              child: Icon(
                                Icons.add,
                                color: backgroundColor,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Obx(() {
                  print("DEBUG: Building readings UI - readings count: ${controller.readings.length}, readings: ${controller.readings}");
                  return controller.readings.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Center(
                          child: Text(
                            "No readings added yet",
                            style: TextStyle(
                              color: subtitleColor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: controller.readings.asMap().entries.map((entry) {
                            final index = entry.key;
                            final reading = entry.value;
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: buttonColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: buttonColor.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.speed,
                                    size: 16,
                                    color: buttonColor,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    reading,
                                    style: TextStyle(
                                      color: containerColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  GestureDetector(
                                    onTap: () {
                                      controller.readings.removeAt(index);
                                    },
                                    child: Icon(
                                      Icons.close,
                                      size: 16,
                                      color: notWorkingTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      );
                })
        ],
            ))]));
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: subtitleColor,
        fontSize: 14,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      filled: true,
      fillColor: backgroundColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: dividerColor,
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: dividerColor,
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: buttonColor,
          width: 2,
        ),
      ),
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
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: cardShadowColor.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          constraints: const BoxConstraints(maxHeight: 500, maxWidth: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      color: buttonColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Select Worker",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: containerColor,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: subtitleColor),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Flexible(
                child: Obx(() {
                  if (isLoading.value) {
                    return const Padding(
                      padding: EdgeInsets.all(40.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (isError.value) {
                    return Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.error_outline,
                              size: 48, color: notWorkingTextColor),
                          const SizedBox(height: 16),
                          Text(
                            "Failed to load workers.",
                            style: TextStyle(color: containerColor),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              isLoading.value = true;
                              isError.value = false;
                              assignController.getWorkers().then((_) {
                                isLoading.value = false;
                                filteredList
                                    .assignAll(assignController.workerList);
                              }).catchError((error) {
                                isLoading.value = false;
                                isError.value = true;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: buttonColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              "Retry",
                              style: TextStyle(color: backgroundColor),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: cardShadowColor.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: searchController,
                            style: TextStyle(color: containerColor),
                            decoration: InputDecoration(
                              labelText: 'Search Worker',
                              labelStyle: TextStyle(color: subtitleColor),
                              hintText: 'Type to search...',
                              hintStyle: TextStyle(color: subtitleColor),
                              prefixIcon:
                                  Icon(Icons.search, color: buttonColor),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              filled: true,
                              fillColor: backgroundColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: dividerColor,
                                  width: 1,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: dividerColor,
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: buttonColor,
                                  width: 2,
                                ),
                              ),
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
                        ),
                        const SizedBox(height: 16),
                        Flexible(
                          child: Container(
                            decoration: BoxDecoration(
                              color: searchBackgroundColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: dividerColor,
                                width: 1,
                              ),
                            ),
                            child: Obx(() => filteredList.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(40.0),
                                    child: Center(
                                      child: Text(
                                        "No workers found",
                                        style: TextStyle(color: subtitleColor),
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: filteredList.length,
                                    itemBuilder: (context, index) {
                                      final worker = filteredList[index];
                                      return Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () {
                                            assignController
                                                    .selectedWorkerName.value =
                                                '${worker.firstName} ${worker.lastName}';
                                            assignController.selectedWorkerId =
                                                worker.id ?? '';
                                            Navigator.pop(context);
                                          },
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 12),
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: backgroundColor,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: dividerColor,
                                                width: 1,
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 40,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    color: buttonColor
                                                        .withOpacity(0.1),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Icon(
                                                    Icons.person,
                                                    color: buttonColor,
                                                    size: 20,
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Text(
                                                    '${worker.firstName} ${worker.lastName}',
                                                    style: TextStyle(
                                                      color: containerColor,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  )),
                          ),
                        ),
                      ],
                    );
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
