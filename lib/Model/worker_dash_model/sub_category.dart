class SubCategory {
  String? name;

  SubCategory({this.name});

  factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
        name: json['name']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        if (name != null) 'name': name,
      };
}
