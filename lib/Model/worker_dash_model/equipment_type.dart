class EquipmentType {
  String? name;

  EquipmentType({this.name});

  factory EquipmentType.fromJson(Map<String, dynamic> json) => EquipmentType(
        name: json['name']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        if (name != null) 'name': name,
      };
}
