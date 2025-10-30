class Department {
  String? name;
  String? description;

  Department({this.name, this.description});

  factory Department.fromJson(Map<String, dynamic> json) => Department(
        name: json['name'] as String?,
        description: json['description'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
      };
}
