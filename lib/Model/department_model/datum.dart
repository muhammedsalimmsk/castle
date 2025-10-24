import 'count.dart';

class DepartmentData {
  String? id;
  String? name;
  String? description;
  bool? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;
  Count? count;

  DepartmentData({
    this.id,
    this.name,
    this.description,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.count,
  });

  factory DepartmentData.fromJson(Map<String, dynamic> json) => DepartmentData(
        id: json['id'] as String?,
        name: json['name'] as String?,
        description: json['description'] as String?,
        isActive: json['isActive'] as bool?,
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
        'isActive': isActive,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        '_count': count?.toJson(),
      };
}
