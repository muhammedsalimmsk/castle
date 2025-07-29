import 'data.dart';

class TaskedRoutineDetailModel {
  bool? success;
  WorkerTaskDetail? data;

  TaskedRoutineDetailModel({this.success, this.data});

  factory TaskedRoutineDetailModel.fromJson(Map<String, dynamic> json) {
    return TaskedRoutineDetailModel(
      success: json['success'] as bool?,
      data: json['data'] == null
          ? null
          : WorkerTaskDetail.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': data?.toJson(),
      };
}
