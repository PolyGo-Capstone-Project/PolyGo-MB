import '../badges/badge_model.dart';

class BadgeListResponse {
  final List<BadgeModel> items;
  final int totalItems;
  final int currentPage;
  final int totalPages;
  final int pageSize;

  BadgeListResponse({
    required this.items,
    required this.totalItems,
    required this.currentPage,
    required this.totalPages,
    required this.pageSize,
  });

  factory BadgeListResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    final List<dynamic> list = data['items'] ?? [];

    return BadgeListResponse(
      items: list.map((e) => BadgeModel.fromJson(e)).toList(),
      totalItems: data['totalItems'] ?? 0,
      currentPage: data['currentPage'] ?? 1,
      totalPages: data['totalPages'] ?? 1,
      pageSize: data['pageSize'] ?? 0,
    );
  }
}
