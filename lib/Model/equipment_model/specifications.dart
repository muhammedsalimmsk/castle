class Specifications {
  String? machine;
  String? electric;

  Specifications({this.machine, this.electric});

  factory Specifications.fromJson(Map<String, dynamic> json) {
    return Specifications(
      machine: json['machine'] as String?,
      electric: json['electric'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'machine': machine,
        'electric': electric,
      };
}
