class GiftPurchaseResponse {
  final String transactionId;
  final int totalAmount;
  final String status;
  final String createdAt;
  final String? notes;

  GiftPurchaseResponse({
    required this.transactionId,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    this.notes,
  });

  factory GiftPurchaseResponse.fromJson(Map<String, dynamic> json) {
    return GiftPurchaseResponse(
      transactionId: json['transactionId'],
      totalAmount: json['totalAmount'],
      status: json['status'],
      createdAt: json['createdAt'],
      notes: json['notes'],
    );
  }
}
