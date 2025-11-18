class CommentUser {
  final String id;
  final String name;
  final String avatarUrl;

  CommentUser({
    required this.id,
    required this.name,
    required this.avatarUrl,
  });

  factory CommentUser.fromJson(Map<String, dynamic> json) {
    return CommentUser(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
    );
  }
}

class CommentModel {
  final String id;
  final String content;
  final DateTime createdAt;
  final CommentUser user;

  CommentModel({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.user,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] ?? '',
      content: json['content'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      user: CommentUser.fromJson(json['user'] ?? {}),
    );
  }
}

class CreateCommentRequest {
  final String content;

  CreateCommentRequest({required this.content});

  Map<String, dynamic> toJson() => {
    'content': content,
  };
}
