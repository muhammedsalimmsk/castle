class Count {
  int? complaints;
  int? routines;

  Count({this.complaints, this.routines});

  factory Count.fromJson(Map<String, dynamic> json) => Count(
        complaints: json['complaints'] as int?,
        routines: json['routines'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'complaints': complaints,
        'routines': routines,
      };
}
