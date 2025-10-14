class SubscriptionResponse {
  final String message;

  SubscriptionResponse({required this.message});

  factory SubscriptionResponse.fromJson(Map<String, dynamic> json) {
    return SubscriptionResponse(
      message: json['message'] ?? '',
    );
  }
}
