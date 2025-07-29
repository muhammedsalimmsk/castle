class Client {
  String? hotelName;

  Client({this.hotelName});

  factory Client.fromJson(Map<String, dynamic> json) => Client(
        hotelName: json['hotelName'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'hotelName': hotelName,
      };
}
