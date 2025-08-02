import 'equipment.dart';

class Complaint {
  String? title;
  Equipment? equipment;

  Complaint({this.title, this.equipment});

  factory Complaint.fromJson(Map<String, dynamic> json) => Complaint(
        title: json['title'] as String?,
        equipment: json['equipment'] == null
            ? null
            : Equipment.fromJson(json['equipment'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'equipment': equipment?.toJson(),
      };
}
