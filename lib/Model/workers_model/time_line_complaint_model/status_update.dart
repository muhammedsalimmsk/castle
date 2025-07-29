class StatusUpdate {
  String? id;
  String? status;
  String? notes;
  String? updatedBy;
  DateTime? updatedAt;
  String? complaintId;

  StatusUpdate({
    this.id,
    this.status,
    this.notes,
    this.updatedBy,
    this.updatedAt,
    this.complaintId,
  });

  factory StatusUpdate.fromJson(Map<String, dynamic> json) => StatusUpdate(
        id: json['id'] as String?,
        status: json['status'] as String?,
        notes: json['notes'] as String?,
        updatedBy: json['updatedBy'] as String?,
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt'] as String),
        complaintId: json['complaintId'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'status': status,
        'notes': notes,
        'updatedBy': updatedBy,
        'updatedAt': updatedAt?.toIso8601String(),
        'complaintId': complaintId,
      };
}
