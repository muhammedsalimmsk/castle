import 'data.dart';
import 'meta.dart';

class DepartWorkersModel {
  bool? success;
  DepartWorkersData? data;
  Meta? meta;

  DepartWorkersModel({this.success, this.data, this.meta});

  factory DepartWorkersModel.fromJson(Map<String, dynamic> json) {
    return DepartWorkersModel(
      success: json['success'] as bool?,
      data: json['data'] == null
          ? null
          : DepartWorkersData.fromJson(json['data'] as Map<String, dynamic>),
      meta: json['meta'] == null
          ? null
          : Meta.fromJson(json['meta'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': data?.toJson(),
        'meta': meta?.toJson(),
      };
}
