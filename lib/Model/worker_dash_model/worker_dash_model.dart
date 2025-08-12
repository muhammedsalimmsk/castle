import 'data.dart';

class WorkerDashModel {
  bool? success;
  WorkerDashData? data;

  WorkerDashModel({this.success, this.data});

  factory WorkerDashModel.fromJson(Map<String, dynamic> json) {
    return WorkerDashModel(
      success: json['success']?.toString().contains("true"),
      data: json['data'] == null
          ? null
          :WorkerDashData.fromJson(Map<String, dynamic>.from(json['data'])),
    );
  }

  Map<String, dynamic> toJson() => {
        if (success != null) 'success': success,
        if (data != null) 'data': data?.toJson(),
      };
}
