class ActiveCount {
  String? department;
  int? count;

  ActiveCount({this.department, this.count});

  factory ActiveCount.fromJson(Map<String, dynamic> json) => ActiveCount(
        department: json['department'] as String?,
        count: json['count'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'department': department,
        'count': count,
      };
}
