class Client {
  String? clientName;

  Client({this.clientName});

  factory Client.fromJson(Map<String, dynamic> json) => Client(
        clientName: json['clientName'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'clientName': clientName,
      };
}
