import 'equipment.dart';

class Routine {
  String? name;
  String? description;
  String? frequency;
  String? timeSlot;
  List<String>? readings;
  Equipment? equipment;

  Routine({
    this.name,
    this.description,
    this.frequency,
    this.timeSlot,
    this.readings,
    this.equipment,
  });

  factory Routine.fromJson(Map<String, dynamic> json) => Routine(
        name: json['name'] as String?,
        description: json['description'] as String?,
        frequency: json['frequency'] as String?,
        timeSlot: json['timeSlot'] as String?,
        readings: (json['readings'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
        equipment: json['equipment'] == null
            ? null
            : Equipment.fromJson(json['equipment'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'frequency': frequency,
        'timeSlot': timeSlot,
        'readings': readings,
        'equipment': equipment?.toJson(),
      };
}
