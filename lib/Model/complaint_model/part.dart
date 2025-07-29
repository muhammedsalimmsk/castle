class Part {
  String? partName;

  Part({this.partName});

  factory Part.fromJson(Map<String, dynamic> json) => Part(
        partName: json['partName'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'partName': partName,
      };
}
