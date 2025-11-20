import 'data.dart';

class LoginDetailsModel {
  bool? success;
  LoginDetailsData? data;

  LoginDetailsModel({
    this.success,
    this.data,
  });

  factory LoginDetailsModel.fromJson(Map<String, dynamic> json) =>
      LoginDetailsModel(
        success: json['success'] as bool?,
        data: json['data'] == null
            ? null
            : LoginDetailsData.fromJson(json['data'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': data?.toJson(),
      };
}

