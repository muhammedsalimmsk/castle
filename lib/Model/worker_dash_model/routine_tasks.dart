class RoutineTasks {
  num? total;
  num? pending;
  num? inProgress;
  num? completed;
  num? skipped;
  num? completionRate;

  RoutineTasks({
    this.total,
    this.pending,
    this.inProgress,
    this.completed,
    this.skipped,
    this.completionRate,
  });

  factory RoutineTasks.fromJson(Map<String, dynamic> json) => RoutineTasks(
        total: num.tryParse(json['total'].toString()),
        pending: num.tryParse(json['pending'].toString()),
        inProgress: num.tryParse(json['inProgress'].toString()),
        completed: num.tryParse(json['completed'].toString()),
        skipped: num.tryParse(json['skipped'].toString()),
        completionRate: num.tryParse(json['completionRate'].toString()),
      );

  Map<String, dynamic> toJson() => {
        if (total != null) 'total': total,
        if (pending != null) 'pending': pending,
        if (inProgress != null) 'inProgress': inProgress,
        if (completed != null) 'completed': completed,
        if (skipped != null) 'skipped': skipped,
        if (completionRate != null) 'completionRate': completionRate,
      };
}
