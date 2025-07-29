class Count {
  int? equipment;
  int? createdComplaints;

  Count({this.equipment, this.createdComplaints});

  factory Count.fromJson(Map<String, dynamic> json) => Count(
        equipment: json['equipment'] as int?,
        createdComplaints: json['createdComplaints'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'equipment': equipment,
        'createdComplaints': createdComplaints,
      };
}
