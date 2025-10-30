import 'datum.dart';

class DashRecentComplaintModel {
  bool? success;
  List<Datum>? data;

  DashRecentComplaintModel({this.success, this.data});

  factory DashRecentComplaintModel.fromJson(Map<String, dynamic> json) {
    return DashRecentComplaintModel(
      success: json['success'] as bool?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': data?.map((e) => e.toJson()).toList(),
      };
}
