import 'datum.dart';
import 'meta.dart';

class WorkersModel {
  bool? success;
  List<WorkerData>? data;
  Meta? meta;

  WorkersModel({this.success, this.data, this.meta});

  factory WorkersModel.fromJson(Map<String, dynamic> json) => WorkersModel(
        success: json['success'] as bool?,
        data: (json['data'] as List<dynamic>?)
            ?.map((e) => WorkerData.fromJson(e as Map<String, dynamic>))
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
