import 'datum.dart';

class EquipmentCategoryModel {
  bool? success;
  List<EquipCat>? data;

  EquipmentCategoryModel({this.success, this.data});

  factory EquipmentCategoryModel.fromJson(Map<String, dynamic> json) {
    return EquipmentCategoryModel(
      success: json['success'] as bool?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => EquipCat.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': data?.map((e) => e.toJson()).toList(),
      };
}
