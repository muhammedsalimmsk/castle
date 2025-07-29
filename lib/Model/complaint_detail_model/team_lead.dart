class TeamLead {
  String? firstName;
  String? lastName;
  String? phone;

  TeamLead({this.firstName, this.lastName, this.phone});

  factory TeamLead.fromJson(Map<String, dynamic> json) => TeamLead(
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
        phone: json['phone'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
      };
}
