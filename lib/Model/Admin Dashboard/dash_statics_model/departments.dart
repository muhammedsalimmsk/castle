class Departments {
  int? total;
  int? active;

  Departments({this.total, this.active});

  factory Departments.fromJson(Map<String, dynamic> json) => Departments(
        total: json['total'] as int?,
        active: json['active'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'total': total,
        'active': active,
      };
}
