class Complaints {
  int? total;
  int? open;
  int? assigned;
  int? inProgress;
  int? resolved;
  int? closed;

  Complaints({
    this.total,
    this.open,
    this.assigned,
    this.inProgress,
    this.resolved,
    this.closed,
  });

  factory Complaints.fromJson(Map<String, dynamic> json) => Complaints(
        total: json['total'] as int?,
        open: json['open'] as int?,
        assigned: json['assigned'] as int?,
        inProgress: json['inProgress'] as int?,
        resolved: json['resolved'] as int?,
        closed: json['closed'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'total': total,
        'open': open,
        'assigned': assigned,
        'inProgress': inProgress,
        'resolved': resolved,
        'closed': closed,
      };
}
