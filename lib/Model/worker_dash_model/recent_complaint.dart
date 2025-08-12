import 'assigned_worker.dart';
import 'client.dart';
import 'equipment.dart';
import 'status_update.dart';
import 'team_lead.dart';

class RecentComplaint {
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
  String? clientId;
  String? equipmentId;
  String? teamLeadId;
  Client? client;
  Equipment? equipment;
  TeamLead? teamLead;
  List<AssignedWorker>? assignedWorkers;
  List<StatusUpdates>? statusUpdates;

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
    this.statusUpdates,
  });

  factory RecentComplaint.fromJson(Map<String, dynamic> json) {
    return RecentComplaint(
      id: json['id']?.toString(),
      title: json['title']?.toString(),
      description: json['description']?.toString(),
      priority: json['priority']?.toString(),
      status: json['status']?.toString(),
      reportedAt: json['reportedAt'] == null
          ? null
          : DateTime.tryParse(json['reportedAt'].toString()),
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.tryParse(json['dueDate'].toString()),
      assignedAt: json['assignedAt'] == null
          ? null
          : DateTime.tryParse(json['assignedAt'].toString()),
      resolvedAt: json['resolvedAt'],
      notes: json['notes'],
      feedback: json['feedback'],
      rating: json['rating'],
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.tryParse(json['createdAt'].toString()),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.tryParse(json['updatedAt'].toString()),
      clientId: json['clientId']?.toString(),
      equipmentId: json['equipmentId']?.toString(),
      teamLeadId: json['teamLeadId']?.toString(),
      client: json['client'] == null
          ? null
          : Client.fromJson(Map<String, dynamic>.from(json['client'])),
      equipment: json['equipment'] == null
          ? null
          : Equipment.fromJson(Map<String, dynamic>.from(json['equipment'])),
      teamLead: json['teamLead'] == null
          ? null
          : TeamLead.fromJson(Map<String, dynamic>.from(json['teamLead'])),
      assignedWorkers: (json['assignedWorkers'] as List<dynamic>?)
          ?.map((e) => AssignedWorker.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      statusUpdates: (json['statusUpdates'] as List<dynamic>?)
          ?.map((e) => StatusUpdates.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        if (title != null) 'title': title,
        if (description != null) 'description': description,
        if (priority != null) 'priority': priority,
        if (status != null) 'status': status,
        if (reportedAt != null) 'reportedAt': reportedAt?.toIso8601String(),
        if (dueDate != null) 'dueDate': dueDate?.toIso8601String(),
        if (assignedAt != null) 'assignedAt': assignedAt?.toIso8601String(),
        if (resolvedAt != null) 'resolvedAt': resolvedAt,
        if (notes != null) 'notes': notes,
        if (feedback != null) 'feedback': feedback,
        if (rating != null) 'rating': rating,
        if (createdAt != null) 'createdAt': createdAt?.toIso8601String(),
        if (updatedAt != null) 'updatedAt': updatedAt?.toIso8601String(),
        if (clientId != null) 'clientId': clientId,
        if (equipmentId != null) 'equipmentId': equipmentId,
        if (teamLeadId != null) 'teamLeadId': teamLeadId,
        if (client != null) 'client': client?.toJson(),
        if (equipment != null) 'equipment': equipment?.toJson(),
        if (teamLead != null) 'teamLead': teamLead?.toJson(),
        if (assignedWorkers != null)
          'assignedWorkers': assignedWorkers?.map((e) => e.toJson()).toList(),
        if (statusUpdates != null)
          'statusUpdates': statusUpdates?.map((e) => e.toJson()).toList(),
      };
}
