class AssignedWorker {
  final String? firstName;
  final String? lastName;

  AssignedWorker({this.firstName, this.lastName});

  factory AssignedWorker.fromJson(Map<String, dynamic> json) {
    return AssignedWorker(
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
    };
  }
}
