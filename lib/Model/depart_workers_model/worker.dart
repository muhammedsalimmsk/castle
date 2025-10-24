import 'count.dart';

class WorkerList {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? role;
  DateTime? createdAt;
  Count? count;

  WorkerList({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.role,
    this.createdAt,
    this.count,
  });

  factory WorkerList.fromJson(Map<String, dynamic> json) => WorkerList(
        id: json['id'] as String?,
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
        email: json['email'] as String?,
        phone: json['phone'] as String?,
        role: json['role'] as String?,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        count: json['_count'] == null
            ? null
            : Count.fromJson(json['_count'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phone': phone,
        'role': role,
        'createdAt': createdAt?.toIso8601String(),
        '_count': count?.toJson(),
      };
}
