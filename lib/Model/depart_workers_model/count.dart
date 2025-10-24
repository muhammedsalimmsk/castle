class Count {
  int? teamLeadComplaints;
  int? complaintAssignments;
  int? routines;

  Count({
    this.teamLeadComplaints,
    this.complaintAssignments,
    this.routines,
  });

  factory Count.fromJson(Map<String, dynamic> json) => Count(
        teamLeadComplaints: json['teamLeadComplaints'] as int?,
        complaintAssignments: json['complaintAssignments'] as int?,
        routines: json['routines'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'teamLeadComplaints': teamLeadComplaints,
        'complaintAssignments': complaintAssignments,
        'routines': routines,
      };
}
