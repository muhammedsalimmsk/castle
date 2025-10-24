class ByDepartment {
  String? department;
  int? count;

  ByDepartment({this.department, this.count});

  factory ByDepartment.fromJson(Map<String, dynamic> json) => ByDepartment(
        department: json['department'] as String?,
        count: json['count'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'department': department,
        'count': count,
      };
}
