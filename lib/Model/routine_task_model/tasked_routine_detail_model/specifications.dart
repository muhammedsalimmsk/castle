class Specifications {
  String? type;
  String? voltage;
  String? capacity;
  String? refrigerant;

  Specifications({
    this.type,
    this.voltage,
    this.capacity,
    this.refrigerant,
  });

  factory Specifications.fromJson(Map<String, dynamic> json) {
    return Specifications(
      type: json['type'] as String?,
      voltage: json['voltage'] as String?,
      capacity: json['capacity'] as String?,
      refrigerant: json['refrigerant'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'voltage': voltage,
        'capacity': capacity,
        'refrigerant': refrigerant,
      };
}
