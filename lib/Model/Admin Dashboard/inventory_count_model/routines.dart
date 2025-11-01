class Routines {
  int? total;
  int? active;

  Routines({this.total, this.active});

  factory Routines.fromJson(Map<String, dynamic> json) => Routines(
        total: json['total'] as int?,
        active: json['active'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'total': total,
        'active': active,
      };
}
