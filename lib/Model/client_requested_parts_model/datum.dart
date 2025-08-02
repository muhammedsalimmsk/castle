import 'complaint.dart';
import 'part.dart';
import 'worker.dart';

class ClientPartsList {
  String? id;
  String? type;
  int? quantity;
  String? reason;
  String? urgency;
  String? status;
  DateTime? requestedAt;
  dynamic approvedAt;
  dynamic collectedAt;
  dynamic deliveredAt;
  dynamic adminNotes;
  dynamic clientNotes;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? workerId;
  String? partId;
  String? complaintId;
  Part? part;
  Worker? worker;
  Complaint? complaint;

  ClientPartsList({
    this.id,
    this.type,
    this.quantity,
    this.reason,
    this.urgency,
    this.status,
    this.requestedAt,
    this.approvedAt,
    this.collectedAt,
    this.deliveredAt,
    this.adminNotes,
    this.clientNotes,
    this.createdAt,
    this.updatedAt,
    this.workerId,
    this.partId,
    this.complaintId,
    this.part,
    this.worker,
    this.complaint,
  });

  factory ClientPartsList.fromJson(Map<String, dynamic> json) =>
      ClientPartsList(
        id: json['id'] as String?,
        type: json['type'] as String?,
        quantity: json['quantity'] as int?,
        reason: json['reason'] as String?,
        urgency: json['urgency'] as String?,
        status: json['status'] as String?,
        requestedAt: json['requestedAt'] == null
            ? null
            : DateTime.parse(json['requestedAt'] as String),
        approvedAt: json['approvedAt'] as dynamic,
        collectedAt: json['collectedAt'] as dynamic,
        deliveredAt: json['deliveredAt'] as dynamic,
        adminNotes: json['adminNotes'] as dynamic,
        clientNotes: json['clientNotes'] as dynamic,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt'] as String),
        workerId: json['workerId'] as String?,
        partId: json['partId'] as String?,
        complaintId: json['complaintId'] as String?,
        part: json['part'] == null
            ? null
            : Part.fromJson(json['part'] as Map<String, dynamic>),
        worker: json['worker'] == null
            ? null
            : Worker.fromJson(json['worker'] as Map<String, dynamic>),
        complaint: json['complaint'] == null
            ? null
            : Complaint.fromJson(json['complaint'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'quantity': quantity,
        'reason': reason,
        'urgency': urgency,
        'status': status,
        'requestedAt': requestedAt?.toIso8601String(),
        'approvedAt': approvedAt,
        'collectedAt': collectedAt,
        'deliveredAt': deliveredAt,
        'adminNotes': adminNotes,
        'clientNotes': clientNotes,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'workerId': workerId,
        'partId': partId,
        'complaintId': complaintId,
        'part': part?.toJson(),
        'worker': worker?.toJson(),
        'complaint': complaint?.toJson(),
      };
}
