class Part {
  String? id;
  String? partName;
  String? partNumber;
  String? description;
  String? category;
  String? unit;
  int? currentStock;
  int? minStockLevel;
  int? maxStockLevel;
  int? unitPrice;
  String? supplier;
  String? location;
  bool? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;

  Part({
    this.id,
    this.partName,
    this.partNumber,
    this.description,
    this.category,
    this.unit,
    this.currentStock,
    this.minStockLevel,
    this.maxStockLevel,
    this.unitPrice,
    this.supplier,
    this.location,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory Part.fromJson(Map<String, dynamic> json) => Part(
        id: json['id'] as String?,
        partName: json['partName'] as String?,
        partNumber: json['partNumber'] as String?,
        description: json['description'] as String?,
        category: json['category'] as String?,
        unit: json['unit'] as String?,
        currentStock: json['currentStock'] as int?,
        minStockLevel: json['minStockLevel'] as int?,
        maxStockLevel: json['maxStockLevel'] as int?,
        unitPrice: json['unitPrice'] as int?,
        supplier: json['supplier'] as String?,
        location: json['location'] as String?,
        isActive: json['isActive'] as bool?,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'partName': partName,
        'partNumber': partNumber,
        'description': description,
        'category': category,
        'unit': unit,
        'currentStock': currentStock,
        'minStockLevel': minStockLevel,
        'maxStockLevel': maxStockLevel,
        'unitPrice': unitPrice,
        'supplier': supplier,
        'location': location,
        'isActive': isActive,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}
