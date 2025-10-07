
class RegisterRequest {
  final String name;
  final String mail;
  final String password;
  final String otp;

  RegisterRequest({
    required this.name,
    required this.mail,
    required this.password,
    required this.otp,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'mail': mail,
    'password': password,
    'otp': otp,
  };
}
