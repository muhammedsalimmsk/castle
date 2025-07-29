class Count {
  int? routineTasks;

  Count({this.routineTasks});

  factory Count.fromJson(Map<String, dynamic> json) => Count(
        routineTasks: json['routineTasks'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'routineTasks': routineTasks,
      };
}
