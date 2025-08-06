class Workers {
  int? total;
  int? active;

  Workers({this.total, this.active});

  factory Workers.fromJson(Map<String, dynamic> json) => Workers(
        total: json['total'] as int?,
        active: json['active'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'total': total,
        'active': active,
      };
}
