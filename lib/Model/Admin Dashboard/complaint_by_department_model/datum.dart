class ComplaintWithDepartment {
  String? department;
  int? count;

  ComplaintWithDepartment({this.department, this.count});

  factory ComplaintWithDepartment.fromJson(Map<String, dynamic> json) =>
      ComplaintWithDepartment(
        department: json['department'] as String?,
        count: json['count'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'department': department,
        'count': count,
      };
}
