class SubCategory {
  String? name;

  SubCategory({this.name});

  factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
        name: json['name'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
      };
}
