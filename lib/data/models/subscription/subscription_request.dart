class SubscriptionRequest {
  final String subscriptionPlanId;
  final bool autoRenew;

  SubscriptionRequest({
    required this.subscriptionPlanId,
    required this.autoRenew,
  });

  Map<String, dynamic> toJson() => {
    'subscriptionPlanId': subscriptionPlanId,
    'autoRenew': autoRenew,
  };
}
