class Client {
  String? firstName;
  String? lastName;
  String? clientName;
  String? clientPhone;

  Client({
    this.firstName,
    this.lastName,
    this.clientName,
    this.clientPhone,
  });

  factory Client.fromJson(Map<String, dynamic> json) => Client(
        firstName: json['firstName']?.toString(),
        lastName: json['lastName']?.toString(),
        clientName: json['clientName']?.toString(),
        clientPhone: json['clientPhone']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        if (firstName != null) 'firstName': firstName,
        if (lastName != null) 'lastName': lastName,
        if (clientName != null) 'clientName': clientName,
        if (clientPhone != null) 'clientPhone': clientPhone,
      };
}
