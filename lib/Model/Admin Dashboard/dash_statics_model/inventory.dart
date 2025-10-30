class Inventory {
  int? totalParts;
  int? lowStockParts;
  int? pendingRequests;
  int? approvedRequests;

  Inventory({
    this.totalParts,
    this.lowStockParts,
    this.pendingRequests,
    this.approvedRequests,
  });

  factory Inventory.fromJson(Map<String, dynamic> json) => Inventory(
        totalParts: json['totalParts'] as int?,
        lowStockParts: json['lowStockParts'] as int?,
        pendingRequests: json['pendingRequests'] as int?,
        approvedRequests: json['approvedRequests'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'totalParts': totalParts,
        'lowStockParts': lowStockParts,
        'pendingRequests': pendingRequests,
        'approvedRequests': approvedRequests,
      };
}
