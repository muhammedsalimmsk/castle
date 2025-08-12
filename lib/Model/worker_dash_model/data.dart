import 'complaints.dart';
import 'complaints_by_priority.dart';
import 'part_requests.dart';
import 'recent_complaint.dart';
import 'routine_tasks.dart';

class WorkerDashData {
  Complaints? complaints;
  ComplaintsByPriority? complaintsByPriority;
  PartRequests? partRequests;
  RoutineTasks? routineTasks;
  List<RecentComplaint>? recentComplaints;
  List<dynamic>? upcomingRoutineTasks;

  WorkerDashData({
    this.complaints,
    this.complaintsByPriority,
    this.partRequests,
    this.routineTasks,
    this.recentComplaints,
    this.upcomingRoutineTasks,
  });

  factory WorkerDashData.fromJson(Map<String, dynamic> json) => WorkerDashData(
        complaints: json['complaints'] == null
            ? null
            : Complaints.fromJson(
                Map<String, dynamic>.from(json['complaints'])),
        complaintsByPriority: json['complaintsByPriority'] == null
            ? null
            : ComplaintsByPriority.fromJson(
                Map<String, dynamic>.from(json['complaintsByPriority'])),
        partRequests: json['partRequests'] == null
            ? null
            : PartRequests.fromJson(
                Map<String, dynamic>.from(json['partRequests'])),
        routineTasks: json['routineTasks'] == null
            ? null
            : RoutineTasks.fromJson(
                Map<String, dynamic>.from(json['routineTasks'])),
        recentComplaints: (json['recentComplaints'] as List<dynamic>?)
            ?.map((e) => RecentComplaint.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
        upcomingRoutineTasks:
            List<dynamic>.from(json['upcomingRoutineTasks'] ?? []),
      );

  Map<String, dynamic> toJson() => {
        if (complaints != null) 'complaints': complaints?.toJson(),
        if (complaintsByPriority != null)
          'complaintsByPriority': complaintsByPriority?.toJson(),
        if (partRequests != null) 'partRequests': partRequests?.toJson(),
        if (routineTasks != null) 'routineTasks': routineTasks?.toJson(),
        if (recentComplaints != null)
          'recentComplaints': recentComplaints?.map((e) => e.toJson()).toList(),
        if (upcomingRoutineTasks != null)
          'upcomingRoutineTasks': upcomingRoutineTasks,
      };
}
