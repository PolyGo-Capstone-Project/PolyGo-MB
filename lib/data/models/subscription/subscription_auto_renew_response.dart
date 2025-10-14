class SubscriptionAutoRenewResponse {
  final bool autoRenew;

  SubscriptionAutoRenewResponse({required this.autoRenew});

  factory SubscriptionAutoRenewResponse.fromJson(Map<String, dynamic> json) {
    return SubscriptionAutoRenewResponse(
      autoRenew: json['autoRenew'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'autoRenew': autoRenew,
    };
  }
}
