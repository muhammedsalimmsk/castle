import 'clients.dart';
import 'workers.dart';

class Users {
  Clients? clients;
  Workers? workers;

  Users({this.clients, this.workers});

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        clients: json['clients'] == null
            ? null
            : Clients.fromJson(json['clients'] as Map<String, dynamic>),
        workers: json['workers'] == null
            ? null
            : Workers.fromJson(json['workers'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'clients': clients?.toJson(),
        'workers': workers?.toJson(),
      };
}
