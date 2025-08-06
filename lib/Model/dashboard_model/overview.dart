import 'clients.dart';
import 'complaints.dart';
import 'equipment.dart';
import 'inventory.dart';
import 'part_requests.dart';
import 'workers.dart';

class Overview {
  Clients? clients;
  Workers? workers;
  Equipment? equipment;
  Complaints? complaints;
  PartRequests? partRequests;
  Inventory? inventory;

  Overview({
    this.clients,
    this.workers,
    this.equipment,
    this.complaints,
    this.partRequests,
    this.inventory,
  });

  factory Overview.fromJson(Map<String, dynamic> json) => Overview(
        clients: json['clients'] == null
            ? null
            : Clients.fromJson(json['clients'] as Map<String, dynamic>),
        workers: json['workers'] == null
            ? null
            : Workers.fromJson(json['workers'] as Map<String, dynamic>),
        equipment: json['equipment'] == null
            ? null
            : Equipment.fromJson(json['equipment'] as Map<String, dynamic>),
        complaints: json['complaints'] == null
            ? null
            : Complaints.fromJson(json['complaints'] as Map<String, dynamic>),
        partRequests: json['partRequests'] == null
            ? null
            : PartRequests.fromJson(
                json['partRequests'] as Map<String, dynamic>),
        inventory: json['inventory'] == null
            ? null
            : Inventory.fromJson(json['inventory'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'clients': clients?.toJson(),
        'workers': workers?.toJson(),
        'equipment': equipment?.toJson(),
        'complaints': complaints?.toJson(),
        'partRequests': partRequests?.toJson(),
        'inventory': inventory?.toJson(),
      };
}
