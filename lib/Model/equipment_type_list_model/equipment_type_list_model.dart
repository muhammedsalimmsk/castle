import 'datum.dart';
import 'meta.dart';

class EquipmentTypeListModel {
  bool? success;
  List<EquipmentType>? data;
  Meta? meta;

  EquipmentTypeListModel({this.success, this.data, this.meta});

  factory EquipmentTypeListModel.fromJson(Map<String, dynamic> json) {
    return EquipmentTypeListModel(
      success: json['success'] as bool?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => EquipmentType.fromJson(e as Map<String, dynamic>))
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
