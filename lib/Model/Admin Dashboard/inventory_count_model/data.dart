import 'inventory.dart';
import 'routines.dart';

class Data {
  Inventory? inventory;
  Routines? routines;

  Data({this.inventory, this.routines});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        inventory: json['inventory'] == null
            ? null
            : Inventory.fromJson(json['inventory'] as Map<String, dynamic>),
        routines: json['routines'] == null
            ? null
            : Routines.fromJson(json['routines'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'inventory': inventory?.toJson(),
        'routines': routines?.toJson(),
      };
}
