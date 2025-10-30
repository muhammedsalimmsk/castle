import 'client_stat.dart';
import 'complaints.dart';
import 'complaints_by_priority.dart';
import 'departments.dart';
import 'equipment.dart';
import 'inventory.dart';
import 'recent_complaint.dart';
import 'routines.dart';
import 'users.dart';

class DashStatic {
  Users? users;
  Departments? departments;
  Equipment? equipment;
  Complaints? complaints;
  ComplaintsByPriority? complaintsByPriority;
  Inventory? inventory;
  Routines? routines;
  List<RecentComplaint>? recentComplaints;
  List<ClientStat>? clientStats;

  DashStatic({
    this.users,
    this.departments,
    this.equipment,
    this.complaints,
    this.complaintsByPriority,
    this.inventory,
    this.routines,
    this.recentComplaints,
    this.clientStats,
  });

  factory DashStatic.fromJson(Map<String, dynamic> json) => DashStatic(
        users: json['users'] == null
            ? null
            : Users.fromJson(json['users'] as Map<String, dynamic>),
        departments: json['departments'] == null
            ? null
            : Departments.fromJson(json['departments'] as Map<String, dynamic>),
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
        inventory: json['inventory'] == null
            ? null
            : Inventory.fromJson(json['inventory'] as Map<String, dynamic>),
        routines: json['routines'] == null
            ? null
            : Routines.fromJson(json['routines'] as Map<String, dynamic>),
        recentComplaints: (json['recentComplaints'] as List<dynamic>?)
            ?.map((e) => RecentComplaint.fromJson(e as Map<String, dynamic>))
            .toList(),
        clientStats: (json['clientStats'] as List<dynamic>?)
            ?.map((e) => ClientStat.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'users': users?.toJson(),
        'departments': departments?.toJson(),
        'equipment': equipment?.toJson(),
        'complaints': complaints?.toJson(),
        'complaintsByPriority': complaintsByPriority?.toJson(),
        'inventory': inventory?.toJson(),
        'routines': routines?.toJson(),
        'recentComplaints': recentComplaints?.map((e) => e.toJson()).toList(),
        'clientStats': clientStats?.map((e) => e.toJson()).toList(),
      };
}
