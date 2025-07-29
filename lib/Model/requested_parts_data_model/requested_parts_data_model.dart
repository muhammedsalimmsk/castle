import 'datum.dart';
import 'meta.dart';

class RequestedPartsDataModel {
  bool? success;
  List<RequestedPartsData>? data;
  Meta? meta;

  RequestedPartsDataModel({this.success, this.data, this.meta});

  factory RequestedPartsDataModel.fromJson(Map<String, dynamic> json) {
    return RequestedPartsDataModel(
      success: json['success'] as bool?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => RequestedPartsData.fromJson(e as Map<String, dynamic>))
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
