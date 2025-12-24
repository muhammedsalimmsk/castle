class Client {
  String? clientName;
  String? clientAddress;
  String? clientPhone;
  String? contactPerson;

  Client({
    this.clientName,
    this.clientAddress,
    this.clientPhone,
    this.contactPerson,
  });

  factory Client.fromJson(Map<String, dynamic> json) => Client(
        clientName: json['clientName'] as String?,
        clientAddress: json['clientAddress'] as String?,
        clientPhone: json['clientPhone'] as String?,
        contactPerson: json['contactPerson'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'clientName': clientName,
        'clientAddress': clientAddress,
        'clientPhone': clientPhone,
        'contactPerson': contactPerson,
      };
}
