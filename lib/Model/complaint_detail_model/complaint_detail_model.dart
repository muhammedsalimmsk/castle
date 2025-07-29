import 'data.dart';

class ComplaintDetailModel {
  bool? success;
  ComplaintDetailsData? data;

  ComplaintDetailModel({this.success, this.data});

  factory ComplaintDetailModel.fromJson(Map<String, dynamic> json) {
    return ComplaintDetailModel(
      success: json['success'] as bool?,
      data: json['data'] == null
          ? null
          : ComplaintDetailsData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': data?.toJson(),
      };
}
