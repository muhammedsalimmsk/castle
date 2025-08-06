import 'complaints.dart';
import 'count.dart';
import 'equipment.dart';

class ClientStat {
  String? id;
  String? firstName;
  String? lastName;
  String? clientName;
  Count? count;
  Complaints? complaints;
  Equipment? equipment;

  ClientStat({
    this.id,
    this.firstName,
    this.lastName,
    this.clientName,
    this.count,
    this.complaints,
    this.equipment,
  });

  factory ClientStat.fromJson(Map<String, dynamic> json) => ClientStat(
        id: json['id'] as String?,
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
        clientName: json['clientName'] as String?,
        count: json['_count'] == null
            ? null
            : Count.fromJson(json['_count'] as Map<String, dynamic>),
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
        '_count': count?.toJson(),
        'complaints': complaints?.toJson(),
        'equipment': equipment?.toJson(),
      };
}
