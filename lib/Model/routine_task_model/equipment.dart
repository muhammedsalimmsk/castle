import 'category.dart';
import 'client.dart';
import 'equipment_type.dart';
import 'sub_category.dart';

class Equipment {
  String? name;
  String? modelNumber;
  String? locationType;
  String? locationRemarks;
  String? serialNumber;
  DateTime? warrantyExpiry;
  Client? client;
  Category? category;
  SubCategory? subCategory;
  EquipmentType? equipmentType;

  Equipment({
    this.name,
    this.modelNumber,
    this.locationType,
    this.locationRemarks,
    this.serialNumber,
    this.warrantyExpiry,
    this.client,
    this.category,
    this.subCategory,
    this.equipmentType,
  });

  factory Equipment.fromJson(Map<String, dynamic> json) => Equipment(
        name: json['name'] as String?,
        modelNumber: json['modelNumber'] as String?,
        locationType: json['locationType'] as String?,
        locationRemarks: json['locationRemarks'] as String?,
        serialNumber: json['serialNumber'] as String?,
        warrantyExpiry: json['warrantyExpiry'] == null
            ? null
            : DateTime.parse(json['warrantyExpiry'] as String),
        client: json['client'] == null
            ? null
            : Client.fromJson(json['client'] as Map<String, dynamic>),
        category: json['category'] == null
            ? null
            : Category.fromJson(json['category'] as Map<String, dynamic>),
        subCategory: json['subCategory'] == null
            ? null
            : SubCategory.fromJson(json['subCategory'] as Map<String, dynamic>),
        equipmentType: json['equipmentType'] == null
            ? null
            : EquipmentType.fromJson(
                json['equipmentType'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'modelNumber': modelNumber,
        'locationType': locationType,
        'locationRemarks': locationRemarks,
        'serialNumber': serialNumber,
        'warrantyExpiry': warrantyExpiry?.toIso8601String(),
        'client': client?.toJson(),
        'category': category?.toJson(),
        'subCategory': subCategory?.toJson(),
        'equipmentType': equipmentType?.toJson(),
      };
}
