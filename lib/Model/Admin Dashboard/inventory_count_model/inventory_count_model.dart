import 'data.dart';

class InventoryCountModel {
  bool? success;
  Data? data;

  InventoryCountModel({this.success, this.data});

  factory InventoryCountModel.fromJson(Map<String, dynamic> json) {
    return InventoryCountModel(
      success: json['success'] as bool?,
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': data?.toJson(),
      };
}
