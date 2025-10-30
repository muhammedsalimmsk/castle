import 'category.dart';

class Equipment {
  String? name;
  Category? category;

  Equipment({this.name, this.category});

  factory Equipment.fromJson(Map<String, dynamic> json) => Equipment(
        name: json['name'] as String?,
        category: json['category'] == null
            ? null
            : Category.fromJson(json['category'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'category': category?.toJson(),
      };
}
