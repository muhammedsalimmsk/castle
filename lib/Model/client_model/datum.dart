import 'count.dart';

class ClientData {
  String? id;
  String? email;
  String? firstName;
  String? lastName;
  String? phone;
  String? clientName;
  String? clientAddress;
  String? clientPhone;
  String? clientEmail;
  String? contactPerson;
  bool? isActive;
  DateTime? createdAt;
  Count? count;

  ClientData({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.phone,
    this.clientName,
    this.clientAddress,
    this.clientPhone,
    this.clientEmail,
    this.contactPerson,
    this.isActive,
    this.createdAt,
    this.count,
  });

  factory ClientData.fromJson(Map<String, dynamic> json) => ClientData(
        id: json['id'] as String?,
        email: json['email'] as String?,
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
        phone: json['phone'] as String?,
        clientName: json['clientName'] as String?,
        clientAddress: json['clientAddress'] as String?,
        clientPhone: json['clientPhone'] as String?,
        clientEmail: json['clientEmail'] as String?,
        contactPerson: json['contactPerson'] as String?,
        isActive: json['isActive'] as bool?,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        count: json['_count'] == null
            ? null
            : Count.fromJson(json['_count'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
        'clientName': clientName,
        'clientAddress': clientAddress,
        'clientPhone': clientPhone,
        'clientEmail': clientEmail,
        'contactPerson': contactPerson,
        'isActive': isActive,
        'createdAt': createdAt?.toIso8601String(),
        '_count': count?.toJson(),
      };
}
