class LoginUser {
  String? id;
  String? email;
  String? name;
  String? role;

  LoginUser({
    this.id,
    this.email,
    this.name,
    this.role,
  });

  factory LoginUser.fromJson(Map<String, dynamic> json) => LoginUser(
        id: json['id'] as String?,
        email: json['email'] as String?,
        name: json['name'] as String?,
        role: json['role'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'name': name,
        'role': role,
      };
}

