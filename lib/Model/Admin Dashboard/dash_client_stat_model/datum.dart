import 'complaints.dart';
import 'equipment.dart';

class ClientStatModel {
  String? id;
  String? firstName;
  String? lastName;
  String? clientName;
  Complaints? complaints;
  Equipment? equipment;

  ClientStatModel({
    this.id,
    this.firstName,
    this.lastName,
    this.clientName,
    this.complaints,
    this.equipment,
  });

  factory ClientStatModel.fromJson(Map<String, dynamic> json) =>
      ClientStatModel(
        id: json['id'] as String?,
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
        clientName: json['clientName'] as String?,
        complaints: json['complaints'] == null
            ? null
            : Complaints.fromJson(json['complaints'] as Map<String, dynamic>),
        equipment: json['equipment'] == null
            ? null
            : Equipment.fromJson(json['equipment'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'clientName': clientName,
        'complaints': complaints?.toJson(),
        'equipment': equipment?.toJson(),
      };
}
