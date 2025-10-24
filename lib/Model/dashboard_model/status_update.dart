class StatusUpdates {
  String? status;
  String? notes;
  String? updatedAt;

  StatusUpdates({this.status, this.notes, this.updatedAt});

  StatusUpdates.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    notes = json['notes'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['notes'] = notes;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
