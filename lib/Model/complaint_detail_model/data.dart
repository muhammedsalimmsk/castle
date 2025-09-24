import 'package:castle/Model/client_detail_model/client_detail_model.dart';
import 'package:castle/Model/client_detail_model/data.dart';

import 'assigned_worker.dart';
import 'comment.dart';
import 'equipment.dart';
import 'status_update.dart';
import 'team_lead.dart';

class ComplaintDetailsData {
  String? id;
  String? title;
  String? description;
  String? priority;
  String? status;
  DateTime? reportedAt;
  DateTime? dueDate;
  DateTime? assignedAt;
  dynamic resolvedAt;
  dynamic notes;
  dynamic feedback;
  dynamic rating;
  DateTime? createdAt;
  DateTime? updatedAt;
  ClientDetailsData? clientData;
  String? equipmentId;
  String? teamLeadId;
  Equipment? equipment;
  TeamLead? teamLead;
  List<AssignedWorker>? assignedWorkers;
  List<StatusUpdate>? statusUpdates;
  List<Comment>? comments;
  List<dynamic>? partRequests;

  ComplaintDetailsData({
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
    this.clientData,
    this.equipmentId,
    this.teamLeadId,
    this.equipment,
    this.teamLead,
    this.assignedWorkers,
    this.statusUpdates,
    this.comments,
    this.partRequests,
  });

  factory ComplaintDetailsData.fromJson(Map<String, dynamic> json) =>
      ComplaintDetailsData(
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
        clientData: json['client'] != null
            ? ClientDetailsData.fromJson(json['client'])
            : null,
        equipmentId: json['equipmentId'] as String?,
        teamLeadId: json['teamLeadId'] as String?,
        equipment: json['equipment'] == null
            ? null
            : Equipment.fromJson(json['equipment'] as Map<String, dynamic>),
        teamLead: json['teamLead'] == null
            ? null
            : TeamLead.fromJson(json['teamLead'] as Map<String, dynamic>),
        assignedWorkers: (json['assignedWorkers'] as List<dynamic>?)
            ?.map((e) => AssignedWorker.fromJson(e as Map<String, dynamic>))
            .toList(),
        statusUpdates: (json['statusUpdates'] as List<dynamic>?)
            ?.map((e) => StatusUpdate.fromJson(e as Map<String, dynamic>))
            .toList(),
        comments: (json['comments'] as List<dynamic>?)
            ?.map((e) => Comment.fromJson(e as Map<String, dynamic>))
            .toList(),
        partRequests: json['partRequests'] as List<dynamic>?,
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
        'resolvedAt': resolvedAt,
        'notes': notes,
        'feedback': feedback,
        'rating': rating,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'client': clientData?.toJson(),
        'equipmentId': equipmentId,
        'teamLeadId': teamLeadId,
        'equipment': equipment?.toJson(),
        'teamLead': teamLead?.toJson(),
        'assignedWorkers': assignedWorkers?.map((e) => e.toJson()).toList(),
        'statusUpdates': statusUpdates?.map((e) => e.toJson()).toList(),
        'comments': comments?.map((e) => e.toJson()).toList(),
        'partRequests': partRequests,
      };
}
