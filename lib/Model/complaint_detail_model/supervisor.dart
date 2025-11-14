class Supervisor {
  String? id;
  String? firstName;
  String? lastName;
  String? phone;
  String? email;

  Supervisor({
    this.id,
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
  });

  factory Supervisor.fromJson(Map<String, dynamic> json) => Supervisor(
        id: json['id'] as String?,
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
        phone: json['phone'] as String?,
        email: json['email'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
        'email': email,
      };
}
