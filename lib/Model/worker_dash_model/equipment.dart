import 'category.dart';
import 'equipment_type.dart';
import 'sub_category.dart';

class Equipment {
  String? name;
  String? modelNumber;
  String? locationType;
  String? locationRemarks;
  Category? category;
  SubCategory? subCategory;
  EquipmentType? equipmentType;

  Equipment({
    this.name,
    this.modelNumber,
    this.locationType,
    this.locationRemarks,
    this.category,
    this.subCategory,
    this.equipmentType,
  });

  factory Equipment.fromJson(Map<String, dynamic> json) => Equipment(
        name: json['name']?.toString(),
        modelNumber: json['modelNumber']?.toString(),
        locationType: json['locationType']?.toString(),
        locationRemarks: json['locationRemarks']?.toString(),
        category: json['category'] == null
            ? null
            : Category.fromJson(Map<String, dynamic>.from(json['category'])),
        subCategory: json['subCategory'] == null
            ? null
            : SubCategory.fromJson(
                Map<String, dynamic>.from(json['subCategory'])),
        equipmentType: json['equipmentType'] == null
            ? null
            : EquipmentType.fromJson(
                Map<String, dynamic>.from(json['equipmentType'])),
      );

  Map<String, dynamic> toJson() => {
        if (name != null) 'name': name,
        if (modelNumber != null) 'modelNumber': modelNumber,
        if (locationType != null) 'locationType': locationType,
        if (locationRemarks != null) 'locationRemarks': locationRemarks,
        if (category != null) 'category': category?.toJson(),
        if (subCategory != null) 'subCategory': subCategory?.toJson(),
        if (equipmentType != null) 'equipmentType': equipmentType?.toJson(),
      };
}
