class Data {
  String? id;
  String? email;
  String? firstName;
  String? lastName;
  String? phone;
  String? role;
  List<String>? badges;
  DateTime? createdAt;
  DateTime? updatedAt;

  Data({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.phone,
    this.role,
    this.badges,
    this.createdAt,
    this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json['id'] as String?,
        email: json['email'] as String?,
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
        phone: json['phone'] as String?,
        role: json['role'] as String?,
        badges: json['badges'] == null
            ? null
            : List<String>.from(json['badges'] as List),
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
        'role': role,
        'badges': badges,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}
