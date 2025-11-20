class Device {
  String? deviceType;
  String? deviceModel;
  String? deviceOS;
  String? appVersion;
  bool? enabled;
  int? sessionCount;

  Device({
    this.deviceType,
    this.deviceModel,
    this.deviceOS,
    this.appVersion,
    this.enabled,
    this.sessionCount,
  });

  factory Device.fromJson(Map<String, dynamic> json) => Device(
        deviceType: json['deviceType'] as String?,
        deviceModel: json['deviceModel'] as String?,
        deviceOS: json['deviceOS'] as String?,
        appVersion: json['appVersion'] as String?,
        enabled: json['enabled'] as bool?,
        sessionCount: json['sessionCount'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'deviceType': deviceType,
        'deviceModel': deviceModel,
        'deviceOS': deviceOS,
        'appVersion': appVersion,
        'enabled': enabled,
        'sessionCount': sessionCount,
      };
}

