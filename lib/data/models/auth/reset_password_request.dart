class ResetPasswordRequest {
  final String mail;
  final String password;
  final String otp;

  ResetPasswordRequest({
    required this.mail,
    required this.password,
    required this.otp,
  });

  Map<String, dynamic> toJson() => {
    'mail': mail,
    'password': password,
    'otp': otp,
  };
}
