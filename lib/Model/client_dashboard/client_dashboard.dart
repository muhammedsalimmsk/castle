import 'data.dart';

class ClientDashboard {
  bool? success;
  ClientDashData? data;

  ClientDashboard({this.success, this.data});

  factory ClientDashboard.fromJson(Map<String, dynamic> json) {
    return ClientDashboard(
      success: json['success'] as bool?,
      data: json['data'] == null
          ? null
          : ClientDashData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': data?.toJson(),
      };
}
