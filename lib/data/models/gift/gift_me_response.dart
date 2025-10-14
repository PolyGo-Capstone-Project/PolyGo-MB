class GiftMeResponse {
  final List<GiftMeItem> items;
  final int totalItems;
  final int currentPage;
  final int totalPages;
  final int pageSize;
  final bool hasPreviousPage;
  final bool hasNextPage;

  GiftMeResponse({
    required this.items,
    required this.totalItems,
    required this.currentPage,
    required this.totalPages,
    required this.pageSize,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  factory GiftMeResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return GiftMeResponse(
      items: (data['items'] as List<dynamic>)
          .map((x) => GiftMeItem.fromJson(x))
          .toList(),
      totalItems: data['totalItems'] ?? 0,
      currentPage: data['currentPage'] ?? 1,
      totalPages: data['totalPages'] ?? 1,
      pageSize: data['pageSize'] ?? 10,
      hasPreviousPage: data['hasPreviousPage'] ?? false,
      hasNextPage: data['hasNextPage'] ?? false,
    );
  }
}

class GiftMeItem {
  final String id;
  final String name;
  final String description;
  final String iconUrl;
  final int price;
  final int quantity;
  final String createdAt;
  final String lastUpdatedAt;

  GiftMeItem({
    required this.id,
    required this.name,
    required this.description,
    required this.iconUrl,
    required this.price,
    required this.quantity,
    required this.createdAt,
    required this.lastUpdatedAt,
  });

  factory GiftMeItem.fromJson(Map<String, dynamic> json) {
    return GiftMeItem(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      iconUrl: json['iconUrl'] ?? '',
      price: json['price'] ?? 0,
      quantity: json['quantity'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      lastUpdatedAt: json['lastUpdatedAt'] ?? '',
    );
  }
}
