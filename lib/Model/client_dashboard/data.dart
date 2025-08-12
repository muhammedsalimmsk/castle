import 'complaints.dart';
import 'complaints_by_priority.dart';
import 'equipment.dart';
import 'recent_complaint.dart';

class ClientDashData {
  Equipment? equipment;
  Complaints? complaints;
  ComplaintsByPriority? complaintsByPriority;
  List<RecentComplaint>? recentComplaints;

  ClientDashData({
    this.equipment,
    this.complaints,
    this.complaintsByPriority,
    this.recentComplaints,
  });

  factory ClientDashData.fromJson(Map<String, dynamic> json) => ClientDashData(
        equipment: json['equipment'] == null
            ? null
            : Equipment.fromJson(json['equipment'] as Map<String, dynamic>),
        complaints: json['complaints'] == null
            ? null
            : Complaints.fromJson(json['complaints'] as Map<String, dynamic>),
        complaintsByPriority: json['complaintsByPriority'] == null
            ? null
            : ComplaintsByPriority.fromJson(
                json['complaintsByPriority'] as Map<String, dynamic>),
        recentComplaints: (json['recentComplaints'] as List<dynamic>?)
            ?.map((e) => RecentComplaint.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'equipment': equipment?.toJson(),
        'complaints': complaints?.toJson(),
        'complaintsByPriority': complaintsByPriority?.toJson(),
        'recentComplaints': recentComplaints?.map((e) => e.toJson()).toList(),
      };
}
