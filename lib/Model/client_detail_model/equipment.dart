import 'category.dart';

class Equipment {
  String? id;
  String? name;
  String? model;
  String? serialNumber;
  String? location;
  Category? category;

  Equipment({
    this.id,
    this.name,
    this.model,
    this.serialNumber,
    this.location,
    this.category,
  });

  factory Equipment.fromJson(Map<String, dynamic> json) => Equipment(
        id: json['id'] as String?,
        name: json['name'] as String?,
        model: json['model'] as String?,
        serialNumber: json['serialNumber'] as String?,
        location: json['location'] as String?,
        category: json['category'] == null
            ? null
            : Category.fromJson(json['category'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'model': model,
        'serialNumber': serialNumber,
        'location': location,
        'category': category?.toJson(),
      };
}
