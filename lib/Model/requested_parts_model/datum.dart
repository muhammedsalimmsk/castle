import 'complaint.dart';
import 'part.dart';
import 'worker.dart';

class RequestedParts {
  String? id;
  int? quantity;
  String? reason;
  String? urgency;
  String? status;
  DateTime? requestedAt;
  dynamic approvedAt;
  dynamic deliveredAt;
  dynamic adminNotes;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? workerId;
  String? partId;
  String? complaintId;
  Worker? worker;
  Part? part;
  Complaint? complaint;

  RequestedParts({
    this.id,
    this.quantity,
    this.reason,
    this.urgency,
    this.status,
    this.requestedAt,
    this.approvedAt,
    this.deliveredAt,
    this.adminNotes,
    this.createdAt,
    this.updatedAt,
    this.workerId,
    this.partId,
    this.complaintId,
    this.worker,
    this.part,
    this.complaint,
  });

  factory RequestedParts.fromJson(Map<String, dynamic> json) => RequestedParts(
        id: json['id'] as String?,
        quantity: json['quantity'] as int?,
        reason: json['reason'] as String?,
        urgency: json['urgency'] as String?,
        status: json['status'] as String?,
        requestedAt: json['requestedAt'] == null
            ? null
            : DateTime.parse(json['requestedAt'] as String),
        approvedAt: json['approvedAt'] as dynamic,
        deliveredAt: json['deliveredAt'] as dynamic,
        adminNotes: json['adminNotes'] as dynamic,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt'] as String),
        workerId: json['workerId'] as String?,
        partId: json['partId'] as String?,
        complaintId: json['complaintId'] as String?,
        worker: json['worker'] == null
            ? null
            : Worker.fromJson(json['worker'] as Map<String, dynamic>),
        part: json['part'] == null
            ? null
            : Part.fromJson(json['part'] as Map<String, dynamic>),
        complaint: json['complaint'] == null
            ? null
            : Complaint.fromJson(json['complaint'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'quantity': quantity,
        'reason': reason,
        'urgency': urgency,
        'status': status,
        'requestedAt': requestedAt?.toIso8601String(),
        'approvedAt': approvedAt,
        'deliveredAt': deliveredAt,
        'adminNotes': adminNotes,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'workerId': workerId,
        'partId': partId,
        'complaintId': complaintId,
        'worker': worker?.toJson(),
        'part': part?.toJson(),
        'complaint': complaint?.toJson(),
      };
}
