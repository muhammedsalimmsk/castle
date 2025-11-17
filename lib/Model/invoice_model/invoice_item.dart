class InvoiceItem {
  String? id;
  String? type;
  String? description;
  double? quantity;
  double? unitPrice;
  double? total;
  DateTime? createdAt;
  DateTime? updatedAt;

  InvoiceItem({
    this.id,
    this.type,
    this.description,
    this.quantity,
    this.unitPrice,
    this.total,
    this.createdAt,
    this.updatedAt,
  });

  factory InvoiceItem.fromJson(Map<String, dynamic> json) => InvoiceItem(
        id: json['id'] as String?,
        type: json['type'] as String?,
        description: json['description'] as String?,
        quantity: json['quantity'] != null
            ? (json['quantity'] as num).toDouble()
            : null,
        unitPrice: json['unitPrice'] != null
            ? (json['unitPrice'] as num).toDouble()
            : null,
        total: json['total'] != null ? (json['total'] as num).toDouble() : null,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'description': description,
        'quantity': quantity,
        'unitPrice': unitPrice,
        'total': total,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}

