import 'assigned_worker.dart';
import 'count.dart';
import 'equipment.dart';

class RoutineDetail {
  String? id;
  String? name;
  String? description;
  String? frequency;
  String? timeSlot;
  int? dayOfWeek;
  int? dayOfMonth;
  bool? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? equipmentId;
  String? assignedWorkerId;
  Equipment? equipment;
  AssignedWorker? assignedWorker;
  Count? count;

  RoutineDetail({
    this.id,
    this.name,
    this.description,
    this.frequency,
    this.timeSlot,
    this.dayOfWeek,
    this.dayOfMonth,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.equipmentId,
    this.assignedWorkerId,
    this.equipment,
    this.assignedWorker,
    this.count,
  });

  factory RoutineDetail.fromJson(Map<String, dynamic> json) => RoutineDetail(
        id: json['id'] as String?,
        name: json['name'] as String?,
        description: json['description'] as String?,
        frequency: json['frequency'] as String?,
        timeSlot: json['timeSlot'] as String?,
        dayOfWeek: json['dayOfWeek'] as int?,
        dayOfMonth: json['dayOfMonth'] as int?,
        isActive: json['isActive'] as bool?,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt'] as String),
        equipmentId: json['equipmentId'] as String?,
        assignedWorkerId: json['assignedWorkerId'] as String?,
        equipment: json['equipment'] == null
            ? null
            : Equipment.fromJson(json['equipment'] as Map<String, dynamic>),
        assignedWorker: json['assignedWorker'] == null
            ? null
            : AssignedWorker.fromJson(
                json['assignedWorker'] as Map<String, dynamic>),
        count: json['_count'] == null
            ? null
            : Count.fromJson(json['_count'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'frequency': frequency,
        'timeSlot': timeSlot,
        'dayOfWeek': dayOfWeek,
        'dayOfMonth': dayOfMonth,
        'isActive': isActive,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'equipmentId': equipmentId,
        'assignedWorkerId': assignedWorkerId,
        'equipment': equipment?.toJson(),
        'assignedWorker': assignedWorker?.toJson(),
        '_count': count?.toJson(),
      };
}
