import 'datum.dart';
import 'meta.dart';

class RoutineModel {
  bool? success;
  List<RoutineDetail>? data;
  Meta? meta;

  RoutineModel({this.success, this.data, this.meta});

  factory RoutineModel.fromJson(Map<String, dynamic> json) => RoutineModel(
        success: json['success'] as bool?,
        data: (json['data'] as List<dynamic>?)
            ?.map((e) => RoutineDetail.fromJson(e as Map<String, dynamic>))
            .toList(),
        meta: json['meta'] == null
            ? null
            : Meta.fromJson(json['meta'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': data?.map((e) => e.toJson()).toList(),
        'meta': meta?.toJson(),
      };
}
