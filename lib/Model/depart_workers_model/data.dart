import 'worker.dart';

class DepartWorkersData {
  String? department;
  List<WorkerList>? workersList;

  DepartWorkersData({this.department, this.workersList});

  factory DepartWorkersData.fromJson(Map<String, dynamic> json) =>
      DepartWorkersData(
        department: json['department'] as String?,
        workersList: (json['workers'] as List<dynamic>?)
            ?.map((e) => WorkerList.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'department': department,
        'workers': workersList?.map((e) => e.toJson()).toList(),
      };
}
