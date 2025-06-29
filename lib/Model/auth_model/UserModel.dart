import 'data.dart';

class UserModel {
  bool? success;
  UserData? data;
  String? message;

  UserModel({this.success, this.data, this.message});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        success: json['success'] as bool?,
        data: json['data'] == null
            ? null
            : UserData.fromJson(json['data'] as Map<String, dynamic>),
        message: json['message'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': data?.toJson(),
        'message': message,
      };
}
