import 'datum.dart';

class ComplaintByDepartmentModel {
  bool? success;
  List<ComplaintWithDepartment>? data;

  ComplaintByDepartmentModel({this.success, this.data});

  factory ComplaintByDepartmentModel.fromJson(Map<String, dynamic> json) {
    return ComplaintByDepartmentModel(
      success: json['success'] as bool?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) =>
              ComplaintWithDepartment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': data?.map((e) => e.toJson()).toList(),
      };
}
