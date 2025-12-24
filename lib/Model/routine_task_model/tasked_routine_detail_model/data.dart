import 'routine.dart';

class WorkerTaskDetail {
  String? id;
  DateTime? scheduledDate;
  String? scheduledTime;
  dynamic startedAt;
  dynamic completedAt;
  String? status;
  dynamic notes;
  dynamic readings;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? routineId;
  String? assignedWorkerId;
  Routine? routine;

  WorkerTaskDetail({
    this.id,
    this.scheduledDate,
    this.scheduledTime,
    this.startedAt,
    this.completedAt,
    this.status,
    this.notes,
    this.readings,
    this.createdAt,
    this.updatedAt,
    this.routineId,
    this.assignedWorkerId,
    this.routine,
  });

  factory WorkerTaskDetail.fromJson(Map<String, dynamic> json) =>
      WorkerTaskDetail(
        id: json['id'] as String?,
        scheduledDate: json['scheduledDate'] == null
            ? null
            : DateTime.parse(json['scheduledDate'] as String),
        scheduledTime: json['scheduledTime'] as String?,
        startedAt: json['startedAt'] as dynamic,
        completedAt: json['completedAt'] as dynamic,
        status: json['status'] as String?,
        notes: json['notes'] as dynamic,
        readings: json['readings'] as dynamic,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt'] as String),
        routineId: json['routineId'] as String?,
        assignedWorkerId: json['assignedWorkerId'] as String?,
        routine: json['routine'] == null
            ? null
            : Routine.fromJson(json['routine'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'scheduledDate': scheduledDate?.toIso8601String(),
        'scheduledTime': scheduledTime,
        'startedAt': startedAt,
        'completedAt': completedAt,
        'status': status,
        'notes': notes,
        'readings': readings,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'routineId': routineId,
        'assignedWorkerId': assignedWorkerId,
        'routine': routine?.toJson(),
      };
}
