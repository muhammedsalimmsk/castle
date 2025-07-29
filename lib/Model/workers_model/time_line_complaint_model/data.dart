import 'assigned_worker.dart';
import 'equipment.dart';
import 'part_request.dart';
import 'status_update.dart';

class ComplaintTimeLineData {
  String? id;
  String? title;
  String? description;
  String? priority;
  String? status;
  DateTime? reportedAt;
  DateTime? assignedAt;
  DateTime? resolvedAt;
  String? notes;
  dynamic feedback;
  dynamic rating;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? clientId;
  String? equipmentId;
  String? assignedWorkerId;
  Equipment? equipment;
  AssignedWorker? assignedWorker;
  List<StatusUpdate>? statusUpdates;
  List<PartRequest>? partRequests;

  ComplaintTimeLineData({
    this.id,
    this.title,
    this.description,
    this.priority,
    this.status,
    this.reportedAt,
    this.assignedAt,
    this.resolvedAt,
    this.notes,
    this.feedback,
    this.rating,
    this.createdAt,
    this.updatedAt,
    this.clientId,
    this.equipmentId,
    this.assignedWorkerId,
    this.equipment,
    this.assignedWorker,
    this.statusUpdates,
    this.partRequests,
  });

  factory ComplaintTimeLineData.fromJson(Map<String, dynamic> json) =>
      ComplaintTimeLineData(
        id: json['id'] as String?,
        title: json['title'] as String?,
        description: json['description'] as String?,
        priority: json['priority'] as String?,
        status: json['status'] as String?,
        reportedAt: json['reportedAt'] == null
            ? null
            : DateTime.parse(json['reportedAt'] as String),
        assignedAt: json['assignedAt'] == null
            ? null
            : DateTime.parse(json['assignedAt'] as String),
        resolvedAt: json['resolvedAt'] == null
            ? null
            : DateTime.parse(json['resolvedAt'] as String),
        notes: json['notes'] as String?,
        feedback: json['feedback'] as dynamic,
        rating: json['rating'] as dynamic,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt'] as String),
        clientId: json['clientId'] as String?,
        equipmentId: json['equipmentId'] as String?,
        assignedWorkerId: json['assignedWorkerId'] as String?,
        equipment: json['equipment'] == null
            ? null
            : Equipment.fromJson(json['equipment'] as Map<String, dynamic>),
        assignedWorker: json['assignedWorker'] == null
            ? null
            : AssignedWorker.fromJson(
                json['assignedWorker'] as Map<String, dynamic>),
        statusUpdates: (json['statusUpdates'] as List<dynamic>?)
            ?.map((e) => StatusUpdate.fromJson(e as Map<String, dynamic>))
            .toList(),
        partRequests: (json['partRequests'] as List<dynamic>?)
            ?.map((e) => PartRequest.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'priority': priority,
        'status': status,
        'reportedAt': reportedAt?.toIso8601String(),
        'assignedAt': assignedAt?.toIso8601String(),
        'resolvedAt': resolvedAt?.toIso8601String(),
        'notes': notes,
        'feedback': feedback,
        'rating': rating,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'clientId': clientId,
        'equipmentId': equipmentId,
        'assignedWorkerId': assignedWorkerId,
        'equipment': equipment?.toJson(),
        'assignedWorker': assignedWorker?.toJson(),
        'statusUpdates': statusUpdates?.map((e) => e.toJson()).toList(),
        'partRequests': partRequests?.map((e) => e.toJson()).toList(),
      };
}
