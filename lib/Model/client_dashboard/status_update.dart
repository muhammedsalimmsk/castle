class StatusUpdate {
  String? status;
  String? notes;
  DateTime? updatedAt;

  StatusUpdate({this.status, this.notes, this.updatedAt});

  factory StatusUpdate.fromJson(Map<String, dynamic> json) => StatusUpdate(
        status: json['status'] as String?,
        notes: json['notes'] as String?,
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt'] as String),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'notes': notes,
        'updatedAt': updatedAt?.toIso8601String(),
      };
}
