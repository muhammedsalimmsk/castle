class ComplaintsByPriority {
  int? urgent;
  int? high;
  int? medium;
  int? low;

  ComplaintsByPriority({this.urgent, this.high, this.medium, this.low});

  factory ComplaintsByPriority.fromJson(Map<String, dynamic> json) {
    return ComplaintsByPriority(
      urgent: json['urgent'] as int?,
      high: json['high'] as int?,
      medium: json['medium'] as int?,
      low: json['low'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'urgent': urgent,
        'high': high,
        'medium': medium,
        'low': low,
      };
}
