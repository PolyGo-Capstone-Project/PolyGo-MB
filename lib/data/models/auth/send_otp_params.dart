// lib/data/models/send_otp_params.dart
class SendOtpParams {
  final String mail;
  final int? verificationType;

  SendOtpParams({required this.mail, this.verificationType});

  Map<String, dynamic> toQueryParams() {
    final m = <String, dynamic>{'mail': mail};
    if (verificationType != null) m['verificationType'] = verificationType;
    return m;
  }
}
