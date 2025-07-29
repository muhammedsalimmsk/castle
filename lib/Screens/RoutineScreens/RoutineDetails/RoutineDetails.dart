import 'package:castle/Model/routine_model/datum.dart';
import 'package:castle/Model/routine_task_model/datum.dart';
import 'package:castle/Screens/RoutineScreens/RoutineDetails/RoutineUpdatePage.dart';
import 'package:castle/Screens/RoutineScreens/RoutineTaskPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:castle/Colors/Colors.dart';

class RoutineDetailsPage extends StatelessWidget {
  final RoutineDetail detail;
  const RoutineDetailsPage({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    print(detail.id);
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("Routine Details"),
        backgroundColor: backgroundColor,
        foregroundColor: containerColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: containerColor),
            onPressed: () {
              Get.to(UpdateRoutinePage(routineDetail: detail));
              // Navigate to edit routine page
              // Get.to(UpdateRoutinePage(routineId: '...'));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _sectionCard(
              title: "Routine Info",
              children: [
                _infoTile("Name", detail.name!),
                _infoTile("Description", detail.description ?? "N/A"),
                _infoTile("Frequency", detail.frequency!),
                if (detail.timeSlot != null)
                  _infoTile("Time Slot", detail.timeSlot!),
              ],
            ),
            const SizedBox(height: 16),
            _sectionCard(
              title: "Equipment",
              children: [
                _infoTile("Name", detail.equipment!.name ?? "-"),
                _infoTile("Model", detail.equipment!.model ?? "-"),
                _infoTile("Location", detail.equipment!.location ?? "-"),
                _infoTile("Client", detail.equipment!.client!.hotelName ?? "-"),
              ],
            ),
            const SizedBox(height: 16),
            _sectionCard(
              title: "Assigned Worker",
              children: [
                _infoTile("Name",
                    "${detail.assignedWorker!.firstName ?? ''} ${detail.assignedWorker!.lastName ?? ''}"),
                _infoTile("Phone", detail.assignedWorker!.phone ?? "-"),
              ],
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                Get.to(TaskListPage(routineId: detail.id!));
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), color: shadeColor),
                child: Center(
                  child: Text(
                    "Routine Task",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _sectionCard({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: containerColor.withOpacity(0.3)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: containerColor)),
          const Divider(thickness: 1.2),
          const SizedBox(height: 6),
          ...children
        ],
      ),
    );
  }

  Widget _infoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              "$label:",
              style: const TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.black87),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
