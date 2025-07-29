import 'part.dart';
import 'worker.dart';

class PartRequest {
  String? id;
  String? type;
  String? status;
  Part? part;
  int? quantity;
  dynamic adminNotes;
  dynamic clientNotes;
  Worker? worker;

  PartRequest({
    this.id,
    this.type,
    this.status,
    this.part,
    this.quantity,
    this.adminNotes,
    this.clientNotes,
    this.worker,
  });

  factory PartRequest.fromJson(Map<String, dynamic> json) => PartRequest(
        id: json['id'] as String?,
        type: json['type'] as String?,
        status: json['status'] as String?,
        part: json['part'] == null
            ? null
            : Part.fromJson(json['part'] as Map<String, dynamic>),
        quantity: json['quantity'] as int?,
        adminNotes: json['adminNotes'] as dynamic,
        clientNotes: json['clientNotes'] as dynamic,
        worker: json['worker'] == null
            ? null
            : Worker.fromJson(json['worker'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'status': status,
        'part': part?.toJson(),
        'quantity': quantity,
        'adminNotes': adminNotes,
        'clientNotes': clientNotes,
        'worker': worker?.toJson(),
      };
}
