class Count {
  int? createdComplaints;
  int? equipment;

  Count({this.createdComplaints, this.equipment});

  factory Count.fromJson(Map<String, dynamic> json) => Count(
        createdComplaints: json['createdComplaints'] as int?,
        equipment: json['equipment'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'createdComplaints': createdComplaints,
        'equipment': equipment,
      };
}
