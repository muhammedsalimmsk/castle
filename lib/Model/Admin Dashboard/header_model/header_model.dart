import 'data.dart';

class HeaderModel {
  bool? success;
  ComplaintCount? data;

  HeaderModel({this.success, this.data});

  factory HeaderModel.fromJson(Map<String, dynamic> json) => HeaderModel(
        success: json['success'] as bool?,
        data: json['data'] == null
            ? null
            : ComplaintCount.fromJson(json['data'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': data?.toJson(),
      };
}
