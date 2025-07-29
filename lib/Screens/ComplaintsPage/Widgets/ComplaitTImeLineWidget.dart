import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:intl/intl.dart';

class TimelineEntry {
  final String type; // "STATUS" or "COMMENT"
  final String title;
  final String subtitle;
  final DateTime time;

  TimelineEntry({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.time,
  });
}

class ComplaintTimelineWidget extends StatelessWidget {
  final List entries;

  const ComplaintTimelineWidget({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: entries.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final item = entries[index];

        return TimelineTile(
          alignment: TimelineAlign.manual,
          lineXY: 0.1,
          isFirst: index == 0,
          isLast: index == entries.length - 1,
          indicatorStyle: IndicatorStyle(
            width: 30,
            color: item.type == "STATUS" ? Colors.blue : Colors.green,
            iconStyle: IconStyle(
              iconData: item.type == "STATUS"
                  ? Icons.sync
                  : Icons.comment_bank_outlined,
              color: Colors.white,
            ),
          ),
          beforeLineStyle: const LineStyle(
            color: Colors.grey,
            thickness: 2,
          ),
          endChild: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(item.subtitle),
                const SizedBox(height: 4),
                Text(
                  DateFormat('dd MMM yyyy, hh:mm a').format(item.time),
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
