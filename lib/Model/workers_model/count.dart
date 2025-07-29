class Count {
  int? assignedComplaints;
  int? routines;

  Count({this.assignedComplaints, this.routines});

  factory Count.fromJson(Map<String, dynamic> json) => Count(
      assignedComplaints: json['assignedComplaints'] as int?,
      routines: json['routines'] as int?);

  Map<String, dynamic> toJson() =>
      {'assignedComplaints': assignedComplaints, 'routines': routines};
}
