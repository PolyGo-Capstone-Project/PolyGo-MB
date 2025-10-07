class LoginRequest {
  final String mail;
  final String password;

  LoginRequest({
    required this.mail,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'mail': mail,
      'password': password,
    };
  }
}
