class Equipment {
  String? name;

  Equipment({this.name});

  factory Equipment.fromJson(Map<String, dynamic> json) => Equipment(
        name: json['name'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
      };
}
