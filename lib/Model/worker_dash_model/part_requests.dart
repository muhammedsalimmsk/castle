class PartRequests {
  num? total;
  num? pending;
  num? approved;
  num? collected;
  num? rejected;

  PartRequests({
    this.total,
    this.pending,
    this.approved,
    this.collected,
    this.rejected,
  });

  factory PartRequests.fromJson(Map<String, dynamic> json) => PartRequests(
        total: num.tryParse(json['total'].toString()),
        pending: num.tryParse(json['pending'].toString()),
        approved: num.tryParse(json['approved'].toString()),
        collected: num.tryParse(json['collected'].toString()),
        rejected: num.tryParse(json['rejected'].toString()),
      );

  Map<String, dynamic> toJson() => {
        if (total != null) 'total': total,
        if (pending != null) 'pending': pending,
        if (approved != null) 'approved': approved,
        if (collected != null) 'collected': collected,
        if (rejected != null) 'rejected': rejected,
      };
}
