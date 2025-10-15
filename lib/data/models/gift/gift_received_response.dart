class GiftReceivedResponse {
  final List<GiftItem> items;
  final int totalItems;
  final int currentPage;
  final int totalPages;
  final int pageSize;
  final bool hasPreviousPage;
  final bool hasNextPage;

  GiftReceivedResponse({
    required this.items,
    required this.totalItems,
    required this.currentPage,
    required this.totalPages,
    required this.pageSize,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  factory GiftReceivedResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return GiftReceivedResponse(
      items: (data['items'] as List)
          .map((e) => GiftItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalItems: _toInt(data['totalItems']),
      currentPage: _toInt(data['currentPage']),
      totalPages: _toInt(data['totalPages']),
      pageSize: _toInt(data['pageSize']),
      hasPreviousPage: data['hasPreviousPage'] ?? false,
      hasNextPage: data['hasNextPage'] ?? false,
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}

class GiftItem {
  final String presentationId;
  final String lang;
  final String senderName;
  final String? senderAvatarUrl;
  final String giftName;
  final String giftIconUrl;
  final int quantity;
  final String? message;
  final bool isAnonymous;
  final bool isRead;
  final DateTime createdAt;
  final DateTime? deliveredAt;

  GiftItem({
    required this.presentationId,
    required this.lang,
    required this.senderName,
    this.senderAvatarUrl,
    required this.giftName,
    required this.giftIconUrl,
    required this.quantity,
    this.message,
    required this.isAnonymous,
    required this.isRead,
    required this.createdAt,
    this.deliveredAt,
  });

  factory GiftItem.fromJson(Map<String, dynamic> json) {
    final deliveredAtStr = json['deliveredAt'] as String?;
    return GiftItem(
      presentationId: json['presentationId'] as String,
      lang: json['lang'] as String,
      senderName: json['senderName'] as String,
      senderAvatarUrl: json['senderAvatarUrl'] as String?,
      giftName: json['giftName'] as String,
      giftIconUrl: json['giftIconUrl'] as String,
      quantity: _toInt(json['quantity']),
      message: json['message'] as String?,
      isAnonymous: json['isAnonymous'] as bool,
      isRead: _toBool(json['isRead']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      deliveredAt: deliveredAtStr != null ? DateTime.parse(deliveredAtStr) : null
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static bool _toBool(dynamic value) {
    if (value is bool) return value;
    if (value is int) return value != 0;
    if (value is String) return value.toLowerCase() == 'true';
    return false;
  }
}
