class Part {
  String? partName;
  String? partNumber;

  Part({this.partName, this.partNumber});

  factory Part.fromJson(Map<String, dynamic> json) => Part(
        partName: json['partName'] as String?,
        partNumber: json['partNumber'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'partName': partName,
        'partNumber': partNumber,
      };
}
