import 'category.dart';
import 'client.dart';
import 'specifications.dart';

class Equipment {
  String? name;
  String? model;
  String? serialNumber;
  String? manufacturer;
  String? location;
  Specifications? specifications;
  Client? client;
  Category? category;

  Equipment({
    this.name,
    this.model,
    this.serialNumber,
    this.manufacturer,
    this.location,
    this.specifications,
    this.client,
    this.category,
  });

  factory Equipment.fromJson(Map<String, dynamic> json) => Equipment(
        name: json['name'] as String?,
        model: json['model'] as String?,
        serialNumber: json['serialNumber'] as String?,
        manufacturer: json['manufacturer'] as String?,
        location: json['location'] as String?,
        specifications: json['specifications'] == null
            ? null
            : Specifications.fromJson(
                json['specifications'] as Map<String, dynamic>),
        client: json['client'] == null
            ? null
            : Client.fromJson(json['client'] as Map<String, dynamic>),
        category: json['category'] == null
            ? null
            : Category.fromJson(json['category'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'model': model,
        'serialNumber': serialNumber,
        'manufacturer': manufacturer,
        'location': location,
        'specifications': specifications?.toJson(),
        'client': client?.toJson(),
        'category': category?.toJson(),
      };
}
