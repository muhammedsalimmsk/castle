class Clients {
  int? total;
  int? active;

  Clients({this.total, this.active});

  factory Clients.fromJson(Map<String, dynamic> json) => Clients(
        total: json['total'] as int?,
        active: json['active'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'total': total,
        'active': active,
      };
}
