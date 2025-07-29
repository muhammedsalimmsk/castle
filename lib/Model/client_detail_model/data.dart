import 'created_complaint.dart';
import 'equipment.dart';

class ClientDetailsData {
  String? id;
  String? email;
  String? firstName;
  String? lastName;
  dynamic phone;
  String? clientName;
  String? clientAddress;
  String? clientEmail;
  String? contactPerson;
  bool? isActive;
  DateTime? createdAt;
  List<Equipment>? equipment;
  List<CreatedComplaint>? createdComplaints;

  ClientDetailsData({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.phone,
    this.clientName,
    this.clientAddress,
    this.clientEmail,
    this.contactPerson,
    this.isActive,
    this.createdAt,
    this.equipment,
    this.createdComplaints,
  });

  factory ClientDetailsData.fromJson(Map<String, dynamic> json) =>
      ClientDetailsData(
        id: json['id'] as String?,
        email: json['email'] as String?,
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
        phone: json['phone'] as dynamic,
        clientName: json['clientName'] as String?,
        clientEmail: json['clientEmail'] as String?,
        contactPerson: json['contactPerson'] as String?,
        clientAddress: json['clientAddress'] as String?,
        isActive: json['isActive'] as bool?,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        equipment: (json['equipment'] as List<dynamic>?)
            ?.map((e) => Equipment.fromJson(e as Map<String, dynamic>))
            .toList(),
        createdComplaints: (json['createdComplaints'] as List<dynamic>?)
            ?.map((e) => CreatedComplaint.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
        'clientName': clientName,
        'clientAddress': clientAddress,
        'isActive': isActive,
        'createdAt': createdAt?.toIso8601String(),
        'equipment': equipment?.map((e) => e.toJson()).toList(),
        'createdComplaints': createdComplaints?.map((e) => e.toJson()).toList(),
      };
}
