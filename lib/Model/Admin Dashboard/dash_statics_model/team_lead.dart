class TeamLead {
  String? firstName;
  String? lastName;

  TeamLead({this.firstName, this.lastName});

  factory TeamLead.fromJson(Map<String, dynamic> json) => TeamLead(
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
      };
}
