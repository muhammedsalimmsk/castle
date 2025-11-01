import 'datum.dart';

class ActiveWorkerCount {
  bool? success;
  List<ActiveCount>? data;

  ActiveWorkerCount({this.success, this.data});

  factory ActiveWorkerCount.fromJson(Map<String, dynamic> json) {
    return ActiveWorkerCount(
      success: json['success'] as bool?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ActiveCount.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': data?.map((e) => e.toJson()).toList(),
      };
}
