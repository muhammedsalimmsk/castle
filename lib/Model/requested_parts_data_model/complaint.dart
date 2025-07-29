import 'client.dart';
import 'equipment.dart';

class Complaint {
  String? title;
  Client? client;
  Equipment? equipment;

  Complaint({this.title, this.client, this.equipment});

  factory Complaint.fromJson(Map<String, dynamic> json) => Complaint(
        title: json['title'] as String?,
        client: json['client'] == null
            ? null
            : Client.fromJson(json['client'] as Map<String, dynamic>),
        equipment: json['equipment'] == null
            ? null
            : Equipment.fromJson(json['equipment'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'client': client?.toJson(),
        'equipment': equipment?.toJson(),
      };
}
