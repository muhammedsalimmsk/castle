class Count {
  int? complaints;

  Count({this.complaints});

  factory Count.fromJson(Map<String, dynamic> json) => Count(
        complaints: json['complaints'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'complaints': complaints,
      };
}
