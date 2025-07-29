class Client {
  String? hotelName;
  String? firstName;
  String? lastName;

  Client({this.hotelName, this.firstName, this.lastName});

  factory Client.fromJson(Map<String, dynamic> json) => Client(
        hotelName: json['hotelName'] as String?,
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'hotelName': hotelName,
        'firstName': firstName,
        'lastName': lastName,
      };
}
