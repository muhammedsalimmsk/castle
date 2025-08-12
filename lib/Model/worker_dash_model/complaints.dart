class Complaints {
  int? total;
  int? open;
  int? assigned;
  int? inProgress;
  int? resolved;
  int? closed;
  int? pending;
  int? completed;
  int? completionRate;

  Complaints(
      {this.total,
        this.open,
        this.assigned,
        this.inProgress,
        this.resolved,
        this.closed,
        this.pending,
        this.completed,
        this.completionRate});

  Complaints.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    open = json['open'];
    assigned = json['assigned'];
    inProgress = json['inProgress'];
    resolved = json['resolved'];
    closed = json['closed'];
    pending = json['pending'];
    completed = json['completed'];
    completionRate = json['completionRate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['open'] = this.open;
    data['assigned'] = this.assigned;
    data['inProgress'] = this.inProgress;
    data['resolved'] = this.resolved;
    data['closed'] = this.closed;
    data['pending'] = this.pending;
    data['completed'] = this.completed;
    data['completionRate'] = this.completionRate;
    return data;
  }
}