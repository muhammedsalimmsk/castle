import 'device.dart';
import 'user.dart';

class LoginDetailsData {
  LoginUser? user;
  DateTime? lastLogin;
  DateTime? firstLogin;
  List<Device>? devices;
  int? totalDevices;
  String? language;
  String? timezone;
  String? country;
  Map<String, dynamic>? tags;

  LoginDetailsData({
    this.user,
    this.lastLogin,
    this.firstLogin,
    this.devices,
    this.totalDevices,
    this.language,
    this.timezone,
    this.country,
    this.tags,
  });

  factory LoginDetailsData.fromJson(Map<String, dynamic> json) =>
      LoginDetailsData(
        user: json['user'] == null
            ? null
            : LoginUser.fromJson(json['user'] as Map<String, dynamic>),
        lastLogin: json['lastLogin'] == null
            ? null
            : DateTime.parse(json['lastLogin'] as String),
        firstLogin: json['firstLogin'] == null
            ? null
            : DateTime.parse(json['firstLogin'] as String),
        devices: (json['devices'] as List<dynamic>?)
            ?.map((e) => Device.fromJson(e as Map<String, dynamic>))
            .toList(),
        totalDevices: json['totalDevices'] as int?,
        language: json['language'] as String?,
        timezone: json['timezone'] as String?,
        country: json['country'] as String?,
        tags: json['tags'] as Map<String, dynamic>?,
      );

  Map<String, dynamic> toJson() => {
        'user': user?.toJson(),
        'lastLogin': lastLogin?.toIso8601String(),
        'firstLogin': firstLogin?.toIso8601String(),
        'devices': devices?.map((e) => e.toJson()).toList(),
        'totalDevices': totalDevices,
        'language': language,
        'timezone': timezone,
        'country': country,
        'tags': tags,
      };
}

