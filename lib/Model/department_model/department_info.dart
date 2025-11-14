class DepartmentInfo {
  String? id;
  String? name;
  String? description;

  DepartmentInfo({this.id, this.name, this.description});

  factory DepartmentInfo.fromJson(Map<String, dynamic> json) {
    return DepartmentInfo(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
      };
}
