import 'data.dart';

class ClientDetailModel {
  bool? success;
  ClientDetailsData? data;

  ClientDetailModel({this.success, this.data});

  factory ClientDetailModel.fromJson(Map<String, dynamic> json) {
    return ClientDetailModel(
      success: json['success'] as bool?,
      data: json['data'] == null
          ? null
          : ClientDetailsData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': data?.toJson(),
      };
}
