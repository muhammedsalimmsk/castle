class EquipmentType {
  String? name;

  EquipmentType({this.name});

  factory EquipmentType.fromJson(Map<String, dynamic> json) => EquipmentType(
        name: json['name'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
      };
}
