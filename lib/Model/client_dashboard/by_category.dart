class ByCategory {
  String? category;
  int? count;

  ByCategory({this.category, this.count});

  factory ByCategory.fromJson(Map<String, dynamic> json) => ByCategory(
        category: json['category'] as String?,
        count: json['count'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'category': category,
        'count': count,
      };
}
