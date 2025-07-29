class Client {
  String? hotelName;
  String? hotelCity;

  Client({this.hotelName, this.hotelCity});

  factory Client.fromJson(Map<String, dynamic> json) => Client(
        hotelName: json['hotelName'] as String?,
        hotelCity: json['hotelCity'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'hotelName': hotelName,
        'hotelCity': hotelCity,
      };
}
