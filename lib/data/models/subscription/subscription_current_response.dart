class CurrentSubscription {
  final String id;
  final String planType;
  final String planName;
  final DateTime startAt;
  final DateTime endAt;
  final bool active;
  final bool autoRenew;
  final int daysRemaining;

  CurrentSubscription({
    required this.id,
    required this.planType,
    required this.planName,
    required this.startAt,
    required this.endAt,
    required this.active,
    required this.autoRenew,
    required this.daysRemaining,
  });

  factory CurrentSubscription.fromJson(Map<String, dynamic> json) {
    return CurrentSubscription(
      id: json['id'] ?? '',
      planType: json['planType'] ?? '',
      planName: json['planName'] ?? '',
      startAt: DateTime.parse(json['startAt']),
      endAt: DateTime.parse(json['endAt']),
      active: json['active'] ?? false,
      autoRenew: json['autoRenew'] ?? false,
      daysRemaining: json['daysRemaining'] ?? 0,
    );
  }
}

class CurrentSubscriptionResponse {
  final CurrentSubscription data;
  final String? message;

  CurrentSubscriptionResponse({required this.data, this.message});

  factory CurrentSubscriptionResponse.fromJson(Map<String, dynamic> json) {
    return CurrentSubscriptionResponse(
      data: CurrentSubscription.fromJson(json['data']),
      message: json['message'] as String?,
    );
  }
}
