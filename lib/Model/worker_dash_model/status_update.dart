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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['notes'] = this.notes;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}