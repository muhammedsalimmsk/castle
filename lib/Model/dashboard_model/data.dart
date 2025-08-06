import 'client_stat.dart';
import 'complaints_by_priority.dart';
import 'overview.dart';
import 'recent_complaint.dart';

class DashboardData {
  Overview? overview;
  ComplaintsByPriority? complaintsByPriority;
  List<RecentComplaint>? recentComplaints;
  List<ClientStat>? clientStats;

  DashboardData({
    this.overview,
    this.complaintsByPriority,
    this.recentComplaints,
    this.clientStats,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) => DashboardData(
        overview: json['overview'] == null
            ? null
            : Overview.fromJson(json['overview'] as Map<String, dynamic>),
        complaintsByPriority: json['complaintsByPriority'] == null
            ? null
            : ComplaintsByPriority.fromJson(
                json['complaintsByPriority'] as Map<String, dynamic>),
        recentComplaints: (json['recentComplaints'] as List<dynamic>?)
            ?.map((e) => RecentComplaint.fromJson(e as Map<String, dynamic>))
            .toList(),
        clientStats: (json['clientStats'] as List<dynamic>?)
            ?.map((e) => ClientStat.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'overview': overview?.toJson(),
        'complaintsByPriority': complaintsByPriority?.toJson(),
        'recentComplaints': recentComplaints?.map((e) => e.toJson()).toList(),
        'clientStats': clientStats?.map((e) => e.toJson()).toList(),
      };
}
