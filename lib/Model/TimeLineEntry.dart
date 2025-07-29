class TimelineEntry {
  final String type; // 'STATUS' or 'COMMENT'
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
