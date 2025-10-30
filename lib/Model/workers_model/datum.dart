import 'worker_department.dart';
import 'count.dart';

class WorkerData {
  String? id;
  String? email;
  String? firstName;
  String? lastName;
  String? phone;
  bool? isActive;
  DateTime? createdAt;
  List<WorkerDepartment>? workerDepartments;
  Count? count;

  WorkerData(
      {this.id,
      this.email,
      this.firstName,
      this.lastName,
      this.phone,
      this.isActive,
      this.createdAt,
      this.count,
      this.workerDepartments});

  factory WorkerData.fromJson(Map<String, dynamic> json) => WorkerData(
        id: json['id'] as String?,
        email: json['email'] as String?,
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
        phone: json['phone'] as String?,
        isActive: json['isActive'] as bool?,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        count: json['_count'] == null
            ? null
            : Count.fromJson(json['_count'] as Map<String, dynamic>),
        workerDepartments: (json['workerDepartments'] as List<dynamic>?)
            ?.map((e) => WorkerDepartment.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
        'isActive': isActive,
        'createdAt': createdAt?.toIso8601String(),
        '_count': count?.toJson(),
        'workerDepartments': workerDepartments?.map((e) => e.toJson()).toList(),
      };
}
