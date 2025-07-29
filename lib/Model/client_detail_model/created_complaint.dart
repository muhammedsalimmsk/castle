class CreatedComplaint {
  String? id;
  String? title;
  String? status;
  DateTime? createdAt;

  CreatedComplaint({this.id, this.title, this.status, this.createdAt});

  factory CreatedComplaint.fromJson(Map<String, dynamic> json) {
    return CreatedComplaint(
      id: json['id'] as String?,
      title: json['title'] as String?,
      status: json['status'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'status': status,
        'createdAt': createdAt?.toIso8601String(),
      };
}
