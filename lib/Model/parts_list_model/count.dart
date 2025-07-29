class Count {
  int? partRequests;

  Count({this.partRequests});

  factory Count.fromJson(Map<String, dynamic> json) => Count(
        partRequests: json['partRequests'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'partRequests': partRequests,
      };
}
