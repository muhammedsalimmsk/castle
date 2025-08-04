import 'category.dart';
import 'count.dart';

class SubCategoryData {
  String? id;
  String? name;
  dynamic description;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? categoryId;
  Category? category;
  Count? count;

  SubCategoryData({
    this.id,
    this.name,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.categoryId,
    this.category,
    this.count,
  });

  factory SubCategoryData.fromJson(Map<String, dynamic> json) =>
      SubCategoryData(
        id: json['id'] as String?,
        name: json['name'] as String?,
        description: json['description'] as dynamic,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt'] as String),
        categoryId: json['categoryId'] as String?,
        category: json['category'] == null
            ? null
            : Category.fromJson(json['category'] as Map<String, dynamic>),
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
        'categoryId': categoryId,
        'category': category?.toJson(),
        '_count': count?.toJson(),
      };
}
