import 'datum.dart';
import 'meta.dart';

class RequestedPartsModel {
  bool? success;
  List<RequestedParts>? data;
  Meta? meta;

  RequestedPartsModel({this.success, this.data, this.meta});

  factory RequestedPartsModel.fromJson(Map<String, dynamic> json) {
    return RequestedPartsModel(
      success: json['success'] as bool?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => RequestedParts.fromJson(e as Map<String, dynamic>))
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
