import 'AssignedWorker.dart';
import 'equipment.dart';
import 'status_update.dart';
import 'client.dart';
import 'team_lead.dart';
import 'part_request.dart';
import 'comment.dart';

class ComplaintDetails {
  String? id;
  String? title;
  String? description;
  String? priority;
  String? status;
  DateTime? reportedAt;
  DateTime? dueDate;
  DateTime? assignedAt;
  dynamic resolvedAt;
  String? notes;
  dynamic feedback;
  dynamic rating;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? clientId;
  String? equipmentId;
  String? teamLeadId;
  Client? client;
  Equipment? equipment;
  TeamLead? teamLead;
  List<AssignedWorker>? assignedWorkers;
  List<StatusUpdate>? statusUpdates;
  List<Comment>? comments;
  List<PartRequest>? partRequests;

  ComplaintDetails({
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
    this.statusUpdates,
    this.comments,
    this.partRequests,
  });

  factory ComplaintDetails.fromJson(Map<String, dynamic> json) =>
      ComplaintDetails(
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
        teamLeadId: json['teamLeadId'] as String?,
        client: json['client'] == null
            ? null
            : Client.fromJson(json['client'] as Map<String, dynamic>),
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
        'dueDate': dueDate?.toIso8601String(),
        'assignedAt': assignedAt?.toIso8601String(),
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
        'assignedWorkers': assignedWorkers?.map((e) => e.toJson()).toList(),
        'statusUpdates': statusUpdates?.map((e) => e.toJson()).toList(),
        'comments': comments?.map((e) => e.toJson()).toList(),
        'partRequests': partRequests?.map((e) => e.toJson()).toList(),
      };
}
