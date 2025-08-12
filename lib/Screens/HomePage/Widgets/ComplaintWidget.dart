import 'package:flutter/material.dart';
import '../../../Colors/Colors.dart';

class ComplaintWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String paragraph;
  final String date;
  final String location;

  const ComplaintWidget({
    super.key,
    required this.title,
    required this.paragraph,
    required this.subtitle,
    required this.location,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double containerWidth = screenWidth < 600 ? screenWidth * 0.9 : 350;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Container(
          width: containerWidth,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
            border: Border.all(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title & Subtitle
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: shadeColor,
                ),
              ),
              const SizedBox(height: 10),

              // Paragraph
              Text(
                paragraph,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 14),
              Divider(color: Colors.grey.shade300, height: 1),

              const SizedBox(height: 10),
              // Location & Date Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 16, color: Colors.redAccent),
                      const SizedBox(width: 4),
                      Text(
                        location,
                        style: const TextStyle(
                            fontSize: 13, color: Colors.black54),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 14, color: Colors.blueAccent),
                      const SizedBox(width: 4),
                      Text(
                        date,
                        style: const TextStyle(
                            fontSize: 13, color: Colors.black54),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
