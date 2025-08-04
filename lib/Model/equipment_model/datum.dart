import 'category.dart';
import 'client.dart';
import 'count.dart';

class EquipmentDetailData {
  String? id;
  String? name;
  String? modelNumber;
  String? serialNumber;
  DateTime? installationDate;
  DateTime? warrantyExpiry;
  String? locationType;
  String? locationRemarks;
  bool? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? categoryId;
  String? subCategoryId;
  String? equipmentTypeId;
  String? clientId;
  Category? category;
  Client? client;
  Count? count;

  EquipmentDetailData({
    this.id,
    this.name,
    this.modelNumber,
    this.serialNumber,
    this.installationDate,
    this.warrantyExpiry,
    this.locationType,
    this.locationRemarks,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.categoryId,
    this.subCategoryId,
    this.equipmentTypeId,
    this.clientId,
    this.category,
    this.client,
    this.count,
  });

  factory EquipmentDetailData.fromJson(Map<String, dynamic> json) =>
      EquipmentDetailData(
        id: json['id'] as String?,
        name: json['name'] as String?,
        modelNumber: json['modelNumber'] as String?,
        serialNumber: json['serialNumber'] as String?,
        installationDate: json['installationDate'] == null
            ? null
            : DateTime.parse(json['installationDate'] as String),
        warrantyExpiry: json['warrantyExpiry'] == null
            ? null
            : DateTime.parse(json['warrantyExpiry'] as String),
        locationType: json['locationType'] as String?,
        locationRemarks: json['locationRemarks'] as String?,
        isActive: json['isActive'] as bool?,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt'] as String),
        categoryId: json['categoryId'] as String?,
        subCategoryId: json['subCategoryId'] as String?,
        equipmentTypeId: json['equipmentTypeId'] as String?,
        clientId: json['clientId'] as String?,
        category: json['category'] == null
            ? null
            : Category.fromJson(json['category'] as Map<String, dynamic>),
        client: json['client'] == null
            ? null
            : Client.fromJson(json['client'] as Map<String, dynamic>),
        count: json['_count'] == null
            ? null
            : Count.fromJson(json['_count'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'modelNumber': modelNumber,
        'serialNumber': serialNumber,
        'installationDate': installationDate?.toIso8601String(),
        'warrantyExpiry': warrantyExpiry?.toIso8601String(),
        'locationType': locationType,
        'locationRemarks': locationRemarks,
        'isActive': isActive,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'categoryId': categoryId,
        'subCategoryId': subCategoryId,
        'equipmentTypeId': equipmentTypeId,
        'clientId': clientId,
        'category': category?.toJson(),
        'client': client?.toJson(),
        '_count': count?.toJson(),
      };
}
