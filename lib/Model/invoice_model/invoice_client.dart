class InvoiceClient {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? clientName;
  String? clientAddress;
  String? clientPhone;
  String? clientEmail;
  String? contactPerson;

  InvoiceClient({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.clientName,
    this.clientAddress,
    this.clientPhone,
    this.clientEmail,
    this.contactPerson,
  });

  factory InvoiceClient.fromJson(Map<String, dynamic> json) => InvoiceClient(
        id: json['id'] as String?,
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
        email: json['email'] as String?,
        phone: json['phone'] as String?,
        clientName: json['clientName'] as String?,
        clientAddress: json['clientAddress'] as String?,
        clientPhone: json['clientPhone'] as String?,
        clientEmail: json['clientEmail'] as String?,
        contactPerson: json['contactPerson'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phone': phone,
        'clientName': clientName,
        'clientAddress': clientAddress,
        'clientPhone': clientPhone,
        'clientEmail': clientEmail,
        'contactPerson': contactPerson,
      };
}

