import 'worker.dart';

class AssignedWorker {
  Worker? worker;
  DateTime? assignedAt;

  AssignedWorker({this.worker, this.assignedAt});

  factory AssignedWorker.fromJson(Map<String, dynamic> json) {
    return AssignedWorker(
      worker: json['worker'] == null
          ? null
          : Worker.fromJson(json['worker'] as Map<String, dynamic>),
      assignedAt: json['assignedAt'] == null
          ? null
          : DateTime.parse(json['assignedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'worker': worker?.toJson(),
        'assignedAt': assignedAt?.toIso8601String(),
      };
}
