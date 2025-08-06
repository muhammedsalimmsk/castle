class PartRequests {
  int? total;
  int? pending;
  int? approved;

  PartRequests({this.total, this.pending, this.approved});

  factory PartRequests.fromJson(Map<String, dynamic> json) => PartRequests(
        total: json['total'] as int?,
        pending: json['pending'] as int?,
        approved: json['approved'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'total': total,
        'pending': pending,
        'approved': approved,
      };
}
