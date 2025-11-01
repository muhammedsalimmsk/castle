import '../../client_dashboard/status_update.dart';
import 'client.dart';
import 'department.dart';
import 'equipment.dart';

import 'team_lead.dart';

class Datum {
  String? id;
  String? title;
  String? description;
  String? priority;
  String? status;
  DateTime? reportedAt;
  DateTime? dueDate;
  DateTime? assignedAt;
  DateTime? resolvedAt;
  String? notes;
  String? feedback;
  dynamic rating;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? clientId;
  String? equipmentId;
  String? teamLeadId;
  String? departmentId;
  Client? client;
  Equipment? equipment;
  Department? department;
  TeamLead? teamLead;
  List<StatusUpdate>? statusUpdates;

  Datum({
    this.id,
    this.title,
    this.description,
    this.priority,
    this.status,
    this.reportedAt,
    this.dueDate,
    this.assignedAt,
    this.resolvedAt,
    this.notes,
    this.feedback,
    this.rating,
    this.createdAt,
    this.updatedAt,
    this.clientId,
    this.equipmentId,
    this.teamLeadId,
    this.departmentId,
    this.client,
    this.equipment,
    this.department,
    this.teamLead,
    this.statusUpdates,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json['id'] as String?,
        title: json['title'] as String?,
        description: json['description'] as String?,
        priority: json['priority'] as String?,
        status: json['status'] as String?,
        reportedAt: json['reportedAt'] == null
            ? null
            : DateTime.parse(json['reportedAt'] as String),
        dueDate: json['dueDate'] == null
            ? null
            : DateTime.parse(json['dueDate'] as String),
        assignedAt: json['assignedAt'] == null
            ? null
            : DateTime.parse(json['assignedAt'] as String),
        resolvedAt: json['resolvedAt'] == null
            ? null
            : DateTime.parse(json['resolvedAt'] as String),
        notes: json['notes'] as String?,
        feedback: json['feedback'] as String?,
        rating: json['rating'] as dynamic,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt'] as String),
        clientId: json['clientId'] as String?,
        equipmentId: json['equipmentId'] as String?,
        teamLeadId: json['teamLeadId'] as String?,
        departmentId: json['departmentId'] as String?,
        client: json['client'] == null
            ? null
            : Client.fromJson(json['client'] as Map<String, dynamic>),
        equipment: json['equipment'] == null
            ? null
            : Equipment.fromJson(json['equipment'] as Map<String, dynamic>),
        department: json['department'] == null
            ? null
            : Department.fromJson(json['department'] as Map<String, dynamic>),
        teamLead: json['teamLead'] == null
            ? null
            : TeamLead.fromJson(json['teamLead'] as Map<String, dynamic>),
        statusUpdates: (json['statusUpdates'] as List<dynamic>?)
            ?.map((e) => StatusUpdate.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'priority': priority,
        'status': status,
        'reportedAt': reportedAt?.toIso8601String(),
        'dueDate': dueDate?.toIso8601String(),
        'assignedAt': assignedAt?.toIso8601String(),
        'resolvedAt': resolvedAt?.toIso8601String(),
        'notes': notes,
        'feedback': feedback,
        'rating': rating,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'clientId': clientId,
        'equipmentId': equipmentId,
        'teamLeadId': teamLeadId,
        'departmentId': departmentId,
        'client': client?.toJson(),
        'equipment': equipment?.toJson(),
        'department': department?.toJson(),
        'teamLead': teamLead?.toJson(),
        'statusUpdates': statusUpdates?.map((e) => e.toJson()).toList(),
      };
}
