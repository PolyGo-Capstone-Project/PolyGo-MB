class GiftAcceptResponse {
  final String presentationId;
  final String giftName;
  final int quantity;
  final int giftValue;
  final int cashReceived;
  final int cashPercentage;
  final DateTime acceptedAt;
  final int newWalletBalance;

  GiftAcceptResponse({
    required this.presentationId,
    required this.giftName,
    required this.quantity,
    required this.giftValue,
    required this.cashReceived,
    required this.cashPercentage,
    required this.acceptedAt,
    required this.newWalletBalance,
  });

  factory GiftAcceptResponse.fromJson(Map<String, dynamic> json) {
    return GiftAcceptResponse(
      presentationId: json['presentationId'] as String,
      giftName: json['giftName'] as String,
      quantity: _toInt(json['quantity']),
      giftValue: _toInt(json['giftValue']),
      cashReceived: _toInt(json['cashReceived']),
      cashPercentage: _toInt(json['cashPercentage']),
      acceptedAt: DateTime.parse(json['acceptedAt'] as String),
      newWalletBalance: _toInt(json['newWalletBalance']),
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}