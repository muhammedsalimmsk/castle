class Equipment {
  int? total;
  int? active;

  Equipment({this.total, this.active});

  factory Equipment.fromJson(Map<String, dynamic> json) => Equipment(
        total: json['total'] as int?,
        active: json['active'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'total': total,
        'active': active,
      };
}
