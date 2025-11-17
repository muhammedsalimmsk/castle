class InvoiceCreatedBy {
  String? id;
  String? firstName;
  String? lastName;
  String? email;

  InvoiceCreatedBy({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
  });

  factory InvoiceCreatedBy.fromJson(Map<String, dynamic> json) =>
      InvoiceCreatedBy(
        id: json['id'] as String?,
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
        email: json['email'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
      };
}

