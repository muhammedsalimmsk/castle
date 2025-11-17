class InvoiceComplaint {
  String? id;
  String? title;
  String? description;
  InvoiceComplaintEquipment? equipment;

  InvoiceComplaint({
    this.id,
    this.title,
    this.description,
    this.equipment,
  });

  factory InvoiceComplaint.fromJson(Map<String, dynamic> json) =>
      InvoiceComplaint(
        id: json['id'] as String?,
        title: json['title'] as String?,
        description: json['description'] as String?,
        equipment: json['equipment'] == null
            ? null
            : InvoiceComplaintEquipment.fromJson(
                json['equipment'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'equipment': equipment?.toJson(),
      };
}

class InvoiceComplaintEquipment {
  String? id;
  String? name;
  String? modelNumber;
  InvoiceEquipmentCategory? category;
  InvoiceEquipmentSubCategory? subCategory;
  InvoiceEquipmentType? equipmentType;

  InvoiceComplaintEquipment({
    this.id,
    this.name,
    this.modelNumber,
    this.category,
    this.subCategory,
    this.equipmentType,
  });

  factory InvoiceComplaintEquipment.fromJson(Map<String, dynamic> json) =>
      InvoiceComplaintEquipment(
        id: json['id'] as String?,
        name: json['name'] as String?,
        modelNumber: json['modelNumber'] as String?,
        category: json['category'] == null
            ? null
            : InvoiceEquipmentCategory.fromJson(
                json['category'] as Map<String, dynamic>),
        subCategory: json['subCategory'] == null
            ? null
            : InvoiceEquipmentSubCategory.fromJson(
                json['subCategory'] as Map<String, dynamic>),
        equipmentType: json['equipmentType'] == null
            ? null
            : InvoiceEquipmentType.fromJson(
                json['equipmentType'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'modelNumber': modelNumber,
        'category': category?.toJson(),
        'subCategory': subCategory?.toJson(),
        'equipmentType': equipmentType?.toJson(),
      };
}

class InvoiceEquipmentCategory {
  String? name;

  InvoiceEquipmentCategory({this.name});

  factory InvoiceEquipmentCategory.fromJson(Map<String, dynamic> json) =>
      InvoiceEquipmentCategory(
        name: json['name'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
      };
}

class InvoiceEquipmentSubCategory {
  String? name;

  InvoiceEquipmentSubCategory({this.name});

  factory InvoiceEquipmentSubCategory.fromJson(Map<String, dynamic> json) =>
      InvoiceEquipmentSubCategory(
        name: json['name'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
      };
}

class InvoiceEquipmentType {
  String? name;

  InvoiceEquipmentType({this.name});

  factory InvoiceEquipmentType.fromJson(Map<String, dynamic> json) =>
      InvoiceEquipmentType(
        name: json['name'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
      };
}

