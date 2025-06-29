import 'data.dart';

class AuthModel {
  bool? success;
  UserData? data;
  String? message;

  AuthModel({this.success, this.data, this.message});

  factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(
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
