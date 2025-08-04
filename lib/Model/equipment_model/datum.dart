import 'category.dart';
import 'client.dart';
import 'count.dart';
import 'specifications.dart';

class EquipmentDetails {
  String? id;
  String? name;
  String? modelNumber;
  String? serialNumber;
  String? manufacturer;
  DateTime? installationDate;
  DateTime? warrantyExpiry;
  Specifications? specifications;
  String? location;
  bool? isActive;
  List<dynamic>? photos;
  dynamic manualUrl;
  dynamic warrantyDocUrl;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? categoryId;
  String? clientId;
  Category? category;
  Client? client;
  Count? count;

  EquipmentDetails({
    this.id,
    this.name,
    this.modelNumber,
    this.serialNumber,
    this.manufacturer,
    this.installationDate,
    this.warrantyExpiry,
    this.specifications,
    this.location,
    this.isActive,
    this.photos,
    this.manualUrl,
    this.warrantyDocUrl,
    this.createdAt,
    this.updatedAt,
    this.categoryId,
    this.clientId,
    this.category,
    this.client,
    this.count,
  });

  factory EquipmentDetails.fromJson(Map<String, dynamic> json) =>
      EquipmentDetails(
        id: json['id'] as String?,
        name: json['name'] as String?,
        modelNumber: json['modelNumberNumber'] as String?,
        serialNumber: json['serialNumber'] as String?,
        manufacturer: json['manufacturer'] as String?,
        installationDate: json['installationDate'] == null
            ? null
            : DateTime.parse(json['installationDate'] as String),
        warrantyExpiry: json['warrantyExpiry'] == null
            ? null
            : DateTime.parse(json['warrantyExpiry'] as String),
        specifications: json['specifications'] == null
            ? null
            : Specifications.fromJson(
                json['specifications'] as Map<String, dynamic>),
        location: json['location'] as String?,
        isActive: json['isActive'] as bool?,
        photos: json['photos'] as List<dynamic>?,
        manualUrl: json['manualUrl'] as dynamic,
        warrantyDocUrl: json['warrantyDocUrl'] as dynamic,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt'] as String),
        categoryId: json['categoryId'] as String?,
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
        'modelNumberNumber': modelNumber,
        'serialNumber': serialNumber,
        'manufacturer': manufacturer,
        'installationDate': installationDate?.toIso8601String(),
        'warrantyExpiry': warrantyExpiry?.toIso8601String(),
        'specifications': specifications?.toJson(),
        'location': location,
        'isActive': isActive,
        'photos': photos,
        'manualUrl': manualUrl,
        'warrantyDocUrl': warrantyDocUrl,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'categoryId': categoryId,
        'clientId': clientId,
        'category': category?.toJson(),
        'client': client?.toJson(),
        '_count': count?.toJson(),
      };
}
