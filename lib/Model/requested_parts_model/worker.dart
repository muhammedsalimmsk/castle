class Worker {
  String? firstName;
  String? lastName;

  Worker({this.firstName, this.lastName});

  factory Worker.fromJson(Map<String, dynamic> json) => Worker(
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
      };
}
