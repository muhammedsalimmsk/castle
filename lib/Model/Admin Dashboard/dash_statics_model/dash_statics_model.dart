import 'data.dart';

class DashStaticsModel {
  bool? success;
  DashStatic? data;

  DashStaticsModel({this.success, this.data});

  factory DashStaticsModel.fromJson(Map<String, dynamic> json) {
    return DashStaticsModel(
      success: json['success'] as bool?,
      data: json['data'] == null
          ? null
          : DashStatic.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': data?.toJson(),
      };
}
