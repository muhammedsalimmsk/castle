import 'equipment.dart';

class Routine {
  String? name;
  String? frequency;
  Equipment? equipment;

  Routine({this.name, this.frequency, this.equipment});

  factory Routine.fromJson(Map<String, dynamic> json) => Routine(
        name: json['name'] as String?,
        frequency: json['frequency'] as String?,
        equipment: json['equipment'] == null
            ? null
            : Equipment.fromJson(json['equipment'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'frequency': frequency,
        'equipment': equipment?.toJson(),
      };
}
