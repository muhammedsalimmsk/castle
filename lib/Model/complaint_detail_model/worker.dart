class Worker {
  String? firstName;
  String? lastName;
  String? phone;

  Worker({this.firstName, this.lastName, this.phone});

  factory Worker.fromJson(Map<String, dynamic> json) => Worker(
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
        phone: json['phone'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
      };
}
