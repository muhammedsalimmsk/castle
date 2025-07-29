import 'datum.dart';
import 'meta.dart';

class RoutineTaskModel {
  bool? success;
  List<TaskDetail>? data;
  Meta? meta;

  RoutineTaskModel({this.success, this.data, this.meta});

  factory RoutineTaskModel.fromJson(Map<String, dynamic> json) {
    return RoutineTaskModel(
      success: json['success'] as bool?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => TaskDetail.fromJson(e as Map<String, dynamic>))
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
