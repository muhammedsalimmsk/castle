class InvoiceMeta {
  int? page;
  int? limit;
  int? total;
  int? totalPages;

  InvoiceMeta({
    this.page,
    this.limit,
    this.total,
    this.totalPages,
  });

  factory InvoiceMeta.fromJson(Map<String, dynamic> json) => InvoiceMeta(
        page: json['page'] as int?,
        limit: json['limit'] as int?,
        total: json['total'] as int?,
        totalPages: json['totalPages'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'page': page,
        'limit': limit,
        'total': total,
        'totalPages': totalPages,
      };
}

