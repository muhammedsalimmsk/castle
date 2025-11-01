class ComplaintCount {
  int? urgent;
  int? medium;
  int? high;

  ComplaintCount({this.urgent, this.medium, this.high});

  factory ComplaintCount.fromJson(Map<String, dynamic> json) => ComplaintCount(
        urgent: json['urgent'] as int?,
        medium: json['medium'] as int?,
        high: json['high'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'urgent': urgent,
        'medium': medium,
        'high': high,
      };
}
