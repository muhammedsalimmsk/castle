class Complaints {
  int? total;
  int? open;
  int? assigned;
  int? inProgress;
  int? resolved;
  int? closed;
  int? pending;
  int? completed;
  int? completionRate;

  Complaints({
    this.total,
    this.open,
    this.assigned,
    this.inProgress,
    this.resolved,
    this.closed,
    this.pending,
    this.completed,
    this.completionRate,
  });

  factory Complaints.fromJson(Map<String, dynamic> json) => Complaints(
        total: json['total'] as int?,
        open: json['open'] as int?,
        assigned: json['assigned'] as int?,
        inProgress: json['inProgress'] as int?,
        resolved: json['resolved'] as int?,
        closed: json['closed'] as int?,
        pending: json['pending'] as int?,
        completed: json['completed'] as int?,
        completionRate: json['completionRate'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'total': total,
        'open': open,
        'assigned': assigned,
        'inProgress': inProgress,
        'resolved': resolved,
        'closed': closed,
        'pending': pending,
        'completed': completed,
        'completionRate': completionRate,
      };
}
