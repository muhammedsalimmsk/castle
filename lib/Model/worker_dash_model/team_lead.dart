class TeamLead {
  String? firstName;
  String? lastName;

  TeamLead({this.firstName, this.lastName});

  factory TeamLead.fromJson(Map<String, dynamic> json) => TeamLead(
        firstName: json['firstName']?.toString(),
        lastName: json['lastName']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        if (firstName != null) 'firstName': firstName,
        if (lastName != null) 'lastName': lastName,
      };
}
