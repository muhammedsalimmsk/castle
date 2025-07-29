class Meta {
  int? page;
  int? limit;
  int? total;
  int? totalPages;

  Meta({this.page, this.limit, this.total, this.totalPages});

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
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
