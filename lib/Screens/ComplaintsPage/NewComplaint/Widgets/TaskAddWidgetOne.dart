import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

import '../../../../Colors/Colors.dart';
import '../../../../Widget/CustomDatePicker.dart';

class TaskAddWidgetOne extends StatelessWidget {
  const TaskAddWidgetOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Task Details",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 20,
        ),
        _buildDropdownField("Customer", ["Filled", "Half", "Empty"]),
        const SizedBox(
          height: 10,
        ),
        _buildDropdownField("Equipment", ["Filled", "Half", "Empty"]),
        const SizedBox(
          height: 10,
        ),
        _buildDropdownField("Assigned To", ["Filled", "Half", "Empty"]),
        const SizedBox(
          height: 10,
        ),
        _buildDropdownField("Task", ["Filled", "Half", "Empty"]),
        const SizedBox(
          height: 10,
        ),
        _buildDropdownField("Repeat", ["Filled", "Half", "Empty"]),
        const SizedBox(
          height: 10,
        ),
        CustomDatePicker(
          onDateSelected: (date) {
            print("Selected Date: ${date.toString()}");
          },
        ),
        const SizedBox(
          height: 10,
        ),
        _buildTextField("Notes"),
        const SizedBox(
          height: 10,
        ),
        const Text(
          "File Task",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Last Modified",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: buttonShadeColor),
            ),
            Text(
              "1 Jan 2025",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          "File Submission",
          style: TextStyle(color: buttonShadeColor),
        ),
        const SizedBox(
          height: 10,
        ),
        DottedBorder(
          borderType: BorderType.RRect,
          radius: const Radius.circular(8),
          padding: const EdgeInsets.all(6),
          child: SizedBox(
              height: 150,
              width: double.infinity,
              child: Icon(
                Icons.drive_folder_upload,
                size: 50,
              )),
        )
      ],
    );
  }

  Widget _buildTextField(String label) {
    return SizedBox(
      child: TextFormField(
        textAlignVertical: TextAlignVertical.top, // Align text to the top
        maxLines: null, // Allow unlimited lines
        minLines: 4, // Start with 5 lines
        decoration: InputDecoration(
          hintText: label,
          floatingLabelBehavior:
              FloatingLabelBehavior.always, // Keep label on top
          contentPadding: const EdgeInsets.all(16), // Adjust padding
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8), // Rounded corners
            borderSide: const BorderSide(
              color: shadeColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField(String label, List<String> items) {
    return DropdownButtonFormField<String>(
      icon: const Icon(
        Icons.arrow_drop_down,
        size: 18,
      ),
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: shadeColor),
        ),
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: shadeColor),
        ),
      ),
      items: items
          .map((name) => DropdownMenuItem(value: name, child: Text(name)))
          .toList(),
      onChanged: (value) {},
    );
  }
}
