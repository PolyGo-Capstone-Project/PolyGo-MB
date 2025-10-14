class GiftPurchaseRequest {
  final String giftId;
  final int quantity;
  final String paymentMethod;
  final String? notes;

  GiftPurchaseRequest({
    required this.giftId,
    required this.quantity,
    required this.paymentMethod,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
    'giftId': giftId,
    'quantity': quantity,
    'paymentMethod': paymentMethod,
    'notes': notes ?? '',
  };
}
