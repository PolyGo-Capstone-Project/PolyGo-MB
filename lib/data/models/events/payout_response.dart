class HostPayoutResponse {
  final String message;

  HostPayoutResponse({required this.message});

  factory HostPayoutResponse.fromJson(Map<String, dynamic> json) {
    return HostPayoutResponse(
      message: json['message'],
    );
  }
}
