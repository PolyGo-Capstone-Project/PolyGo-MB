class GiftPresentRequest {
  final String receiverId;
  final String giftId;
  final int quantity;
  final String? message;
  final bool isAnonymous;

  GiftPresentRequest({
    required this.receiverId,
    required this.giftId,
    required this.quantity,
    this.message,
    required this.isAnonymous,
  });

  Map<String, dynamic> toJson() => {
    'receiverId': receiverId,
    'giftId': giftId,
    'quantity': quantity,
    'message': message,
    'isAnonymous': isAnonymous,
  };
}
