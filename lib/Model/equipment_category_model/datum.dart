
import 'count.dart';
import 'sub_category.dart';

class EquipCat {
  String? id;
  String? name;
  String? description;
  Count? count;
  List<SubCategory>? subCategories;

  EquipCat({
    this.id,
    this.name,
    this.description,
    this.count,
    this.subCategories,
  });

  factory EquipCat.fromJson(Map<String, dynamic> json) => EquipCat(
        id: json['id'] as String?,
        name: json['name'] as String?,
        description: json['description'] as String?,
        count: json['_count'] == null
            ? null
            : Count.fromJson(json['_count'] as Map<String, dynamic>),
        subCategories: (json['subCategories'] as List<dynamic>?)
            ?.map((e) => SubCategory.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        '_count': count?.toJson(),
        'subCategories': subCategories?.map((e) => e.toJson()).toList(),
      };
}
