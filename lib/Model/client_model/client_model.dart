import 'datum.dart';
import 'meta.dart';

class ClientModel {
  bool? success;
  List<ClientData>? data;
  Meta? meta;

  ClientModel({this.success, this.data, this.meta});

  factory ClientModel.fromJson(Map<String, dynamic> json) => ClientModel(
        success: json['success'] as bool?,
        data: (json['data'] as List<dynamic>?)
            ?.map((e) => ClientData.fromJson(e as Map<String, dynamic>))
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
