class Client {
  String? firstName;
  String? lastName;
  String? clientName;
  String? clientAddress;

  Client({
    this.firstName,
    this.lastName,
    this.clientName,
    this.clientAddress,
  });

  factory Client.fromJson(Map<String, dynamic> json) => Client(
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
        clientName: json['clientName'] as String?,
        clientAddress: json['clientAddress'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'clientName': clientName,
        'clientAddress': clientAddress,
      };
}
