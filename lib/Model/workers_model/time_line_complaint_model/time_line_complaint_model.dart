import 'data.dart';

class TimeLineComplaintModel {
  bool? success;
  ComplaintTimeLineData? data;

  TimeLineComplaintModel({this.success, this.data});

  factory TimeLineComplaintModel.fromJson(Map<String, dynamic> json) {
    return TimeLineComplaintModel(
      success: json['success'] as bool?,
      data: json['data'] == null
          ? null
          : ComplaintTimeLineData.fromJson(
              json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': data?.toJson(),
      };
}
