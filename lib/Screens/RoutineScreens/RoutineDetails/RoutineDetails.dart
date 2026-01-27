import 'package:castle/Model/routine_model/datum.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:castle/Colors/Colors.dart';
import '../../../Utils/ResponsiveHelper.dart';
import '../../../Controlls/AssignRoutineController/RoutineController.dart';
import '../../ComplaintsPage/NewComplaint/CreateComplaintPage.dart';

class RoutineDetailsPage extends StatefulWidget {
  final RoutineDetail detail;
  const RoutineDetailsPage({super.key, required this.detail});

  @override
  State<RoutineDetailsPage> createState() => _RoutineDetailsPageState();
}

class _RoutineDetailsPageState extends State<RoutineDetailsPage> {
  late final AssignRoutineController controller;
  bool isLoadingTasks = false;

  @override
  void initState() {
    super.initState();
    controller = Get.put(AssignRoutineController());
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    if (widget.detail.id == null) return;

    setState(() {
      isLoadingTasks = true;
    });

    try {
      controller.taskIsRefresh = true;
      await controller.getRoutinetask('', widget.detail.id!);
    } catch (e) {
      // Handle error silently or show snackbar
      print("Error fetching tasks: $e");
    } finally {
      if (mounted) {
        setState(() {
          isLoadingTasks = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text(
          "Routine Details",
          style: TextStyle(
            color: containerColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: buttonColor),
          onPressed: () {
            // Use Navigator.pop to avoid GetX snackbar controller issues
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: ResponsiveHelper.getMaxContentWidth(context),
            ),
            child: SingleChildScrollView(
              padding: ResponsiveHelper.getResponsivePadding(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 4,
                              height: 24,
                              decoration: BoxDecoration(
                                color: buttonColor,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              "Routine Details",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: containerColor,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: buttonColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: buttonColor.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Get.toNamed('/routineUpdate', arguments: {
                                  'routineDetail': widget.detail
                                });
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.edit,
                                        color: buttonColor, size: 18),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Edit",
                                      style: TextStyle(
                                        color: buttonColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _sectionCard(
                    title: "Routine Info",
                    icon: Icons.schedule_rounded,
                    children: [
                      _infoTile("Name", widget.detail.name!),
                      _infoTile(
                          "Description", widget.detail.description ?? "N/A"),
                      _infoTile("Frequency", widget.detail.frequency!),
                      if (widget.detail.timeSlot != null)
                        _infoTile("Time Slot", widget.detail.timeSlot!),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _sectionCard(
                    title: "Equipment",
                    icon: Icons.precision_manufacturing_outlined,
                    children: [
                      _infoTile("Name", widget.detail.equipment!.name ?? "-"),
                      _infoTile("Model", widget.detail.equipment!.model ?? "-"),
                      _infoTile(
                          "Location", widget.detail.equipment!.location ?? "-"),
                      _infoTile("Client",
                          widget.detail.equipment!.client!.hotelName ?? "-"),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _sectionCard(
                    title: "Assigned Worker",
                    icon: Icons.person_outline,
                    children: [
                      _infoTile("Name",
                          "${widget.detail.assignedWorker!.firstName ?? ''} ${widget.detail.assignedWorker!.lastName ?? ''}"),
                      _infoTile(
                          "Phone", widget.detail.assignedWorker!.phone ?? "-"),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildReadingsSection(),
                  const SizedBox(height: 24),
                  Container(
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
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Get.toNamed('/routineTask',
                              arguments: {'routineId': widget.detail.id!});
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 18),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.task_alt,
                                  color: backgroundColor, size: 24),
                              const SizedBox(width: 12),
                              Text(
                                "Routine Task",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: backgroundColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionCard(
      {required String title,
      required IconData icon,
      required List<Widget> children}) {
    return Container(
      width: double.infinity,
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
            color: cardShadowColor.withOpacity(0.3),
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
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      buttonColor,
                      buttonColor.withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: buttonColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(icon, color: backgroundColor, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: containerColor,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(
            thickness: 1,
            color: dividerColor,
          ),
          const SizedBox(height: 12),
          ...children
        ],
      ),
    );
  }

  Widget _infoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              "$label:",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: subtitleColor,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: containerColor,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadingsSection() {
    // Get readings from routine detail
    final readings = widget.detail.readings;

    if (readings == null || readings.isEmpty) {
      return _sectionCard(
        title: "Readings",
        icon: Icons.speed_rounded,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Text(
                "No readings configured",
                style: TextStyle(
                  color: subtitleColor,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      );
    }

    // Display readings as a list of reading types
    return _sectionCard(
      title: "Readings",
      icon: Icons.speed_rounded,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: readings.map((reading) {
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
                ],
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        // Create Complaint Button - Small style
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.red.shade600,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  // Navigate to CreateComplaintPage with pre-filled data
                  Get.to(() => CreateComplaintPage(
                    equipmentId: widget.detail.equipmentId,
                    readings: widget.detail.readings,
                    routineName: widget.detail.name,
                  ));
                },
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.report_problem,
                          color: backgroundColor, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        "Create Complaint",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: backgroundColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
