class UserListResponse {
  final List<UserItem> items;
  final int totalItems;
  final int currentPage;
  final int totalPages;
  final int pageSize;
  final bool hasPreviousPage;
  final bool hasNextPage;

  UserListResponse({
    required this.items,
    required this.totalItems,
    required this.currentPage,
    required this.totalPages,
    required this.pageSize,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  factory UserListResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final items = (data['items'] as List)
        .map((e) => UserItem.fromJson(e as Map<String, dynamic>))
        .toList();

    return UserListResponse(
      items: items,
      totalItems: data['totalItems'],
      currentPage: data['currentPage'],
      totalPages: data['totalPages'],
      pageSize: data['pageSize'],
      hasPreviousPage: data['hasPreviousPage'],
      hasNextPage: data['hasNextPage'],
    );
  }
}

class UserItem {
  final String id;
  final String name;
  final String mail;
  final String? avatarUrl;
  final String? introduction;
  final String gender;
  final String meritLevel;
  final String role;
  final int experiencePoints;

  UserItem({
    required this.id,
    required this.name,
    required this.mail,
    this.avatarUrl,
    this.introduction,
    required this.gender,
    required this.meritLevel,
    required this.role,
    required this.experiencePoints,
  });

  factory UserItem.fromJson(Map<String, dynamic> json) {
    return UserItem(
      id: json['id'],
      name: json['name'],
      mail: json['mail'],
      avatarUrl: json['avatarUrl'],
      introduction: json['introduction'],
      gender: json['gender'],
      meritLevel: json['meritLevel'],
      role: json['role'],
      experiencePoints: json['experiencePoints'] ?? 0,
    );
  }
}
