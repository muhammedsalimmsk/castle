import 'package:castle/Model/complaint_detail_model/assigned_worker.dart';
import 'package:castle/Model/complaint_detail_model/team_lead.dart';

import 'client.dart';
import 'equipment.dart';

class RecentComplaint {
  String? id;
  String? title;
  String? description;
  String? priority;
  String? status;
  DateTime? reportedAt;
  dynamic dueDate;
  dynamic assignedAt;
  dynamic resolvedAt;
  dynamic notes;
  dynamic feedback;
  dynamic rating;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? clientId;
  String? equipmentId;
  dynamic teamLeadId;
  Client? client;
  Equipment? equipment;
  TeamLead? teamLead;
  List<dynamic>? assignedWorkers;

  RecentComplaint({
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
    this.client,
    this.equipment,
    this.teamLead,
    this.assignedWorkers,
  });

  factory RecentComplaint.fromJson(Map<String, dynamic> json) {
    return RecentComplaint(
      id: json['id'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      priority: json['priority'] as String?,
      status: json['status'] as String?,
      reportedAt: json['reportedAt'] == null
          ? null
          : DateTime.parse(json['reportedAt'] as String),
      dueDate: json['dueDate'] as dynamic,
      assignedAt: json['assignedAt'] as dynamic,
      resolvedAt: json['resolvedAt'] as dynamic,
      notes: json['notes'] as dynamic,
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
      teamLeadId: json['teamLeadId'] as dynamic,
      client: json['client'] == null
          ? null
          : Client.fromJson(json['client'] as Map<String, dynamic>),
      equipment: json['equipment'] == null
          ? null
          : Equipment.fromJson(json['equipment'] as Map<String, dynamic>),
      teamLead: json['teamLead']==null?null:TeamLead.fromJson(json['teamLead'] as Map<String, dynamic>),
      assignedWorkers: json['assignedWorkers'] as List<dynamic>?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'priority': priority,
        'status': status,
        'reportedAt': reportedAt?.toIso8601String(),
        'dueDate': dueDate,
        'assignedAt': assignedAt,
        'resolvedAt': resolvedAt,
        'notes': notes,
        'feedback': feedback,
        'rating': rating,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'clientId': clientId,
        'equipmentId': equipmentId,
        'teamLeadId': teamLeadId,
        'client': client?.toJson(),
        'equipment': equipment?.toJson(),
        'teamLead': teamLead?.toJson(),
        'assignedWorkers': assignedWorkers,
      };
}
