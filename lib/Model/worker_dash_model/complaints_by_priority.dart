class ComplaintsByPriority {
  int? urgent;
  int? high;
  int? medium;
  int? low;

  ComplaintsByPriority({this.urgent, this.high, this.medium, this.low});

  ComplaintsByPriority.fromJson(Map<String, dynamic> json) {
    urgent = json['urgent'];
    high = json['high'];
    medium = json['medium'];
    low = json['low'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['urgent'] = this.urgent;
    data['high'] = this.high;
    data['medium'] = this.medium;
    data['low'] = this.low;
    return data;
  }
}
