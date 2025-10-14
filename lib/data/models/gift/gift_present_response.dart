class GiftPresentResponse {
  final String presentationId;
  final String receiverName;
  final String giftName;
  final int quantity;
  final String createdAt;
  final bool isAnonymous;
  final String? message;

  GiftPresentResponse({
    required this.presentationId,
    required this.receiverName,
    required this.giftName,
    required this.quantity,
    required this.createdAt,
    required this.isAnonymous,
    this.message,
  });

  factory GiftPresentResponse.fromJson(Map<String, dynamic> json) {
    return GiftPresentResponse(
      presentationId: json['presentationId'] ?? '',
      receiverName: json['receiverName'] ?? '',
      giftName: json['giftName'] ?? '',
      quantity: json['quantity'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      isAnonymous: json['isAnonymous'] ?? false,
      message: json['message'],
    );
  }
}
