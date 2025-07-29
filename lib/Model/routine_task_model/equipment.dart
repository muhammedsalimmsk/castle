import 'client.dart';

class Equipment {
  String? name;
  String? location;
  Client? client;

  Equipment({this.name, this.location, this.client});

  factory Equipment.fromJson(Map<String, dynamic> json) => Equipment(
        name: json['name'] as String?,
        location: json['location'] as String?,
        client: json['client'] == null
            ? null
            : Client.fromJson(json['client'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'location': location,
        'client': client?.toJson(),
      };
}
