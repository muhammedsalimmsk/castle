import 'datum.dart';
import 'meta.dart';

class SubCategoryModel {
  bool? success;
  List<SubCategoryData>? data;
  Meta? meta;

  SubCategoryModel({this.success, this.data, this.meta});

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      success: json['success'] as bool?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => SubCategoryData.fromJson(e as Map<String, dynamic>))
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
