class Complaints {
  int? total;
  int? pending;
  int? completed;

  Complaints({this.total, this.pending, this.completed});

  factory Complaints.fromJson(Map<String, dynamic> json) => Complaints(
        total: json['total'] as int?,
        pending: json['pending'] as int?,
        completed: json['completed'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'total': total,
        'pending': pending,
        'completed': completed,
      };
}
