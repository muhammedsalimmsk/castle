import 'department.dart';

class WorkerDepartment {
  Department? department;
  bool? isPrimary;

  WorkerDepartment({this.department, this.isPrimary});

  factory WorkerDepartment.fromJson(Map<String, dynamic> json) {
    return WorkerDepartment(
      department: json['department'] == null
          ? null
          : Department.fromJson(json['department'] as Map<String, dynamic>),
      isPrimary: json['isPrimary'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
        'department': department?.toJson(),
        'isPrimary': isPrimary,
      };
}
