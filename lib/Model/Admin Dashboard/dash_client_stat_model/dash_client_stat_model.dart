import 'datum.dart';

class DashClientStatModel {
  bool? success;
  List<ClientStatModel>? data;

  DashClientStatModel({this.success, this.data});

  factory DashClientStatModel.fromJson(Map<String, dynamic> json) {
    return DashClientStatModel(
      success: json['success'] as bool?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ClientStatModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': data?.map((e) => e.toJson()).toList(),
      };
}
