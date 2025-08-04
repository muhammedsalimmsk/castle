class Client {
  String? clientName;
  String? clientAddress;

  Client({this.clientName, this.clientAddress});

  factory Client.fromJson(Map<String, dynamic> json) => Client(
        clientName: json['clientName'] as String?,
        clientAddress: json['clientAddress'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'clientName': clientName,
        'clientAddress': clientAddress,
      };
}
