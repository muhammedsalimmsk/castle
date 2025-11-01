class Equipment {
  int? total;

  Equipment({this.total});

  factory Equipment.fromJson(Map<String, dynamic> json) => Equipment(
        total: json['total'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'total': total,
      };
}
