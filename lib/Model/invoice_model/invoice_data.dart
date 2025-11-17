import 'invoice_item.dart';
import 'invoice_client.dart';
import 'invoice_complaint.dart';
import 'invoice_created_by.dart';

class InvoiceData {
  String? id;
  String? invoiceNumber;
  String? reportType;
  String? status;
  DateTime? issueDate;
  DateTime? dueDate;
  DateTime? paidDate;
  double? subtotal;
  double? taxRate;
  double? taxAmount;
  double? discount;
  double? total;
  String? notes;
  String? terms;
  String? pdfUrl;
  String? pdfKey;
  Map<String, dynamic>? metadata;
  DateTime? createdAt;
  DateTime? updatedAt;
  InvoiceClient? client;
  InvoiceComplaint? complaint;
  List<InvoiceItem>? items;
  InvoiceCreatedBy? createdBy;

  InvoiceData({
    this.id,
    this.invoiceNumber,
    this.reportType,
    this.status,
    this.issueDate,
    this.dueDate,
    this.paidDate,
    this.subtotal,
    this.taxRate,
    this.taxAmount,
    this.discount,
    this.total,
    this.notes,
    this.terms,
    this.pdfUrl,
    this.pdfKey,
    this.metadata,
    this.createdAt,
    this.updatedAt,
    this.client,
    this.complaint,
    this.items,
    this.createdBy,
  });

  factory InvoiceData.fromJson(Map<String, dynamic> json) => InvoiceData(
        id: json['id'] as String?,
        invoiceNumber: json['invoiceNumber'] as String?,
        reportType: json['reportType'] as String?,
        status: json['status'] as String?,
        issueDate: json['issueDate'] == null
            ? null
            : DateTime.parse(json['issueDate'] as String),
        dueDate: json['dueDate'] == null
            ? null
            : DateTime.parse(json['dueDate'] as String),
        paidDate: json['paidDate'] == null
            ? null
            : DateTime.parse(json['paidDate'] as String),
        subtotal: json['subtotal'] != null
            ? (json['subtotal'] as num).toDouble()
            : null,
        taxRate: json['taxRate'] != null
            ? (json['taxRate'] as num).toDouble()
            : null,
        taxAmount: json['taxAmount'] != null
            ? (json['taxAmount'] as num).toDouble()
            : null,
        discount: json['discount'] != null
            ? (json['discount'] as num).toDouble()
            : null,
        total: json['total'] != null ? (json['total'] as num).toDouble() : null,
        notes: json['notes'] as String?,
        terms: json['terms'] as String?,
        pdfUrl: json['pdfUrl'] as String?,
        pdfKey: json['pdfKey'] as String?,
        metadata: json['metadata'] as Map<String, dynamic>?,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt'] as String),
        client: json['client'] == null
            ? null
            : InvoiceClient.fromJson(json['client'] as Map<String, dynamic>),
        complaint: json['complaint'] == null
            ? null
            : InvoiceComplaint.fromJson(
                json['complaint'] as Map<String, dynamic>),
        items: (json['items'] as List<dynamic>?)
            ?.map((e) => InvoiceItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        createdBy: json['createdBy'] == null
            ? null
            : InvoiceCreatedBy.fromJson(
                json['createdBy'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'invoiceNumber': invoiceNumber,
        'reportType': reportType,
        'status': status,
        'issueDate': issueDate?.toIso8601String(),
        'dueDate': dueDate?.toIso8601String(),
        'paidDate': paidDate?.toIso8601String(),
        'subtotal': subtotal,
        'taxRate': taxRate,
        'taxAmount': taxAmount,
        'discount': discount,
        'total': total,
        'notes': notes,
        'terms': terms,
        'pdfUrl': pdfUrl,
        'pdfKey': pdfKey,
        'metadata': metadata,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'client': client?.toJson(),
        'complaint': complaint?.toJson(),
        'items': items?.map((e) => e.toJson()).toList(),
        'createdBy': createdBy?.toJson(),
      };
}

