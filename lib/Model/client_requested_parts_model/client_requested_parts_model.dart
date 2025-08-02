import 'datum.dart';
import 'meta.dart';

class ClientRequestedPartsModel {
  bool? success;
  List<ClientPartsList>? data;
  Meta? meta;

  ClientRequestedPartsModel({this.success, this.data, this.meta});

  factory ClientRequestedPartsModel.fromJson(Map<String, dynamic> json) {
    return ClientRequestedPartsModel(
      success: json['success'] as bool?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ClientPartsList.fromJson(e as Map<String, dynamic>))
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
