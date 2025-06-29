class UserData {
  String? token;
  String? refreshToken;
  DateTime? expiresAt;

  UserData({this.token, this.refreshToken, this.expiresAt});

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        token: json['token'] as String?,
        refreshToken: json['refreshToken'] as String?,
        expiresAt: json['expiresAt'] == null
            ? null
            : DateTime.parse(json['expiresAt'] as String),
      );

  Map<String, dynamic> toJson() => {
        'token': token,
        'refreshToken': refreshToken,
        'expiresAt': expiresAt?.toIso8601String(),
      };
}
