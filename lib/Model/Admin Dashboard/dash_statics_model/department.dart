class Department {
  String? name;

  Department({this.name});

  factory Department.fromJson(Map<String, dynamic> json) => Department(
        name: json['name'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
      };
}
