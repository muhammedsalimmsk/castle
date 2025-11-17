import 'invoice_data.dart';
import 'invoice_meta.dart';

class InvoiceModel {
  bool? success;
  InvoiceData? data;
  List<InvoiceData>? dataList;
  InvoiceMeta? meta;
  String? message;
  String? error;

  InvoiceModel({
    this.success,
    this.data,
    this.dataList,
    this.meta,
    this.message,
    this.error,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    // Check if response has a list (GET all) or single object (GET by ID, POST, PATCH)
    if (json['data'] is List) {
      return InvoiceModel(
        success: json['success'] as bool?,
        dataList: (json['data'] as List<dynamic>?)
            ?.map((e) => InvoiceData.fromJson(e as Map<String, dynamic>))
            .toList(),
        meta: json['meta'] == null
            ? null
            : InvoiceMeta.fromJson(json['meta'] as Map<String, dynamic>),
        message: json['message'] as String?,
        error: json['error'] as String?,
      );
    } else {
      return InvoiceModel(
        success: json['success'] as bool?,
        data: json['data'] == null
            ? null
            : InvoiceData.fromJson(json['data'] as Map<String, dynamic>),
        message: json['message'] as String?,
        error: json['error'] as String?,
      );
    }
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': data?.toJson(),
        'dataList': dataList?.map((e) => e.toJson()).toList(),
        'meta': meta?.toJson(),
        'message': message,
        'error': error,
      };
}

