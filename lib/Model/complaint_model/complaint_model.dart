import 'datum.dart';
import 'meta.dart';

class ComplaintModel {
  bool? success;
  List<ComplaintDetails>? data;
  Meta? meta;

  ComplaintModel({this.success, this.data, this.meta});

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    return ComplaintModel(
      success: json['success'] as bool?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ComplaintDetails.fromJson(e as Map<String, dynamic>))
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
