import 'count.dart';

class EquipCat {
  String? id;
  String? name;
  String? description;
  dynamic iconUrl;
  DateTime? createdAt;
  DateTime? updatedAt;
  Count? count;

  EquipCat({
    this.id,
    this.name,
    this.description,
    this.iconUrl,
    this.createdAt,
    this.updatedAt,
    this.count,
  });

  factory EquipCat.fromJson(Map<String, dynamic> json) => EquipCat(
        id: json['id'] as String?,
        name: json['name'] as String?,
        description: json['description'] as String?,
        iconUrl: json['iconUrl'] as dynamic,
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
        'iconUrl': iconUrl,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        '_count': count?.toJson(),
      };
}
