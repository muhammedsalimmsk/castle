class AssignedWorker {
  String? firstName;
  String? lastName;
  String? phone;

  AssignedWorker({this.firstName, this.lastName, this.phone});

  factory AssignedWorker.fromJson(Map<String, dynamic> json) {
    return AssignedWorker(
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      phone: json['phone'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
      };
}
