class Author {
  String? firstName;
  String? lastName;
  String? role;

  Author({this.firstName, this.lastName, this.role});

  factory Author.fromJson(Map<String, dynamic> json) => Author(
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
        role: json['role'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'role': role,
      };
}
