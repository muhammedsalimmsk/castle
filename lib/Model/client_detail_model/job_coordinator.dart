class JobCoordinator {
  String? firstName;
  String? lastName;
  String? email;
  String? phone;

  JobCoordinator({
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
  });

  factory JobCoordinator.fromJson(Map<String, dynamic> json) {
    return JobCoordinator(
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phone': phone,
      };
}
