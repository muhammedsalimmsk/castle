class Count {
  int? equipment;

  Count({this.equipment});

  factory Count.fromJson(Map<String, dynamic> json) => Count(
        equipment: json['equipment'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'equipment': equipment,
      };
}
