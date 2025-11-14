import '../department_model/department_info.dart';
import 'worker.dart';

class DepartWorkersData {
  DepartmentInfo? department;
  List<WorkerList>? workersList;

  DepartWorkersData({this.department, this.workersList});

  factory DepartWorkersData.fromJson(Map<String, dynamic> json) =>
      DepartWorkersData(
        department: json['department'] == null
            ? null
            : DepartmentInfo.fromJson(json['department']),
        workersList: (json['workers'] as List<dynamic>?)
            ?.map((e) => WorkerList.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'department': department?.toJson(),
        'workers': workersList?.map((e) => e.toJson()).toList(),
      };
}
