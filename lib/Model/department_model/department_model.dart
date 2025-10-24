import 'datum.dart';
import 'meta.dart';

class DepartmentModel {
  bool? success;
  List<DepartmentData>? data;
  Meta? meta;

  DepartmentModel({this.success, this.data, this.meta});

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      success: json['success'] as bool?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => DepartmentData.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: json['meta'] == null
          ? null
          : Meta.fromJson(json['meta'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': data?.map((e) => e.toJson()).toList(),
        'meta': meta?.toJson(),
      };
}
