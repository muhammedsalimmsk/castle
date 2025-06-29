import 'data.dart';

class UserDetailModel {
  bool? success;
  Data? data;
  String? message;

  UserDetailModel({this.success, this.data, this.message});

  factory UserDetailModel.fromJson(Map<String, dynamic> json) {
    return UserDetailModel(
      success: json['success'] as bool?,
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': data?.toJson(),
        'message': message,
      };
}
