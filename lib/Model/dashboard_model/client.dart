class Client {
  String? firstName;
  String? lastName;
  String? clientName;

  Client({this.firstName, this.lastName, this.clientName});

  factory Client.fromJson(Map<String, dynamic> json) => Client(
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
        clientName: json['clientName'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'clientName': clientName,
      };
}
