import 'datum.dart';
import 'meta.dart';

class PartsListModel {
  bool? success;
  List<PartsDetail>? data;
  Meta? meta;

  PartsListModel({this.success, this.data, this.meta});

  factory PartsListModel.fromJson(Map<String, dynamic> json) {
    return PartsListModel(
      success: json['success'] as bool?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => PartsDetail.fromJson(e as Map<String, dynamic>))
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
