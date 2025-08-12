import 'by_category.dart';

class Equipment {
  int? total;
  int? active;
  List<ByCategory>? byCategory;

  Equipment({this.total, this.active, this.byCategory});

  factory Equipment.fromJson(Map<String, dynamic> json) => Equipment(
        total: json['total'] as int?,
        active: json['active'] as int?,
        byCategory: (json['byCategory'] as List<dynamic>?)
            ?.map((e) => ByCategory.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'total': total,
        'active': active,
        'byCategory': byCategory?.map((e) => e.toJson()).toList(),
      };
}
