class SendOtpParams {
  final String mail;
  final int verificationType; // bắt buộc

  SendOtpParams({required this.mail, required this.verificationType});

  Map<String, dynamic> toQueryParams() => {
    'mail': mail,
    'verificationType': verificationType,
  };
}
