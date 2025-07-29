class Client {
  String? hotelName;
  String? hotelAddress;
  String? hotelCity;
  String? hotelPhone;
  String? contactPerson;

  Client({
    this.hotelName,
    this.hotelAddress,
    this.hotelCity,
    this.hotelPhone,
    this.contactPerson,
  });

  factory Client.fromJson(Map<String, dynamic> json) => Client(
        hotelName: json['hotelName'] as String?,
        hotelAddress: json['hotelAddress'] as String?,
        hotelCity: json['hotelCity'] as String?,
        hotelPhone: json['hotelPhone'] as String?,
        contactPerson: json['contactPerson'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'hotelName': hotelName,
        'hotelAddress': hotelAddress,
        'hotelCity': hotelCity,
        'hotelPhone': hotelPhone,
        'contactPerson': contactPerson,
      };
}
