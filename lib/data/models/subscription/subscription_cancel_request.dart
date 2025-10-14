class SubscriptionCancelRequest {
  final String reason;

  SubscriptionCancelRequest({required this.reason});

  Map<String, dynamic> toJson() => {
    'reason': reason,
  };
}
