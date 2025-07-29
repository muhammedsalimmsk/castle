import 'client.dart';

class Equipment {
  String? name;
  String? model;
  String? location;
  Client? client;

  Equipment({this.name, this.model, this.location, this.client});

  factory Equipment.fromJson(Map<String, dynamic> json) => Equipment(
        name: json['name'] as String?,
        model: json['model'] as String?,
        location: json['location'] as String?,
        client: json['client'] == null
            ? null
            : Client.fromJson(json['client'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'model': model,
        'location': location,
        'client': client?.toJson(),
      };
}
