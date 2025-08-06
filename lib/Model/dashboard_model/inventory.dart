class Inventory {
  int? totalParts;
  int? lowStockParts;

  Inventory({this.totalParts, this.lowStockParts});

  factory Inventory.fromJson(Map<String, dynamic> json) => Inventory(
        totalParts: json['totalParts'] as int?,
        lowStockParts: json['lowStockParts'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'totalParts': totalParts,
        'lowStockParts': lowStockParts,
      };
}
