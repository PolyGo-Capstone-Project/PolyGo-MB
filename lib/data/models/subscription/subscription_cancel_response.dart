class SubscriptionCancelResponse {
  final String message;

  SubscriptionCancelResponse({required this.message});

  factory SubscriptionCancelResponse.fromJson(Map<String, dynamic> json) {
    return SubscriptionCancelResponse(
      message: json['message'] ?? '',
    );
  }
}
