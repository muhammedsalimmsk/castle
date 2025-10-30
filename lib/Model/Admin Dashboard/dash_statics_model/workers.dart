import 'by_department.dart';

class Workers {
  int? total;
  int? active;
  List<ByDepartment>? byDepartment;

  Workers({this.total, this.active, this.byDepartment});

  factory Workers.fromJson(Map<String, dynamic> json) => Workers(
        total: json['total'] as int?,
        active: json['active'] as int?,
        byDepartment: (json['byDepartment'] as List<dynamic>?)
            ?.map((e) => ByDepartment.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'total': total,
        'active': active,
        'byDepartment': byDepartment?.map((e) => e.toJson()).toList(),
      };
}
