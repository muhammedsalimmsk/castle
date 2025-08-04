import 'count.dart';

class EquipmentType {
  String? id;
  String? name;
  dynamic description;
  DateTime? createdAt;
  DateTime? updatedAt;
  Count? count;

  EquipmentType({
    this.id,
    this.name,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.count,
  });

  factory EquipmentType.fromJson(Map<String, dynamic> json) => EquipmentType(
        id: json['id'] as String?,
        name: json['name'] as String?,
        description: json['description'] as dynamic,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt'] as String),
        count: json['_count'] == null
            ? null
            : Count.fromJson(json['_count'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        '_count': count?.toJson(),
      };
}
