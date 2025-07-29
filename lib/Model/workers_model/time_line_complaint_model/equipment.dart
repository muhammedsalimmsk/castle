import 'category.dart';

class Equipment {
  String? name;
  String? model;
  String? location;
  String? serialNumber;
  Category? category;

  Equipment({
    this.name,
    this.model,
    this.location,
    this.serialNumber,
    this.category,
  });

  factory Equipment.fromJson(Map<String, dynamic> json) => Equipment(
        name: json['name'] as String?,
        model: json['model'] as String?,
        location: json['location'] as String?,
        serialNumber: json['serialNumber'] as String?,
        category: json['category'] == null
            ? null
            : Category.fromJson(json['category'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'model': model,
        'location': location,
        'serialNumber': serialNumber,
        'category': category?.toJson(),
      };
}
