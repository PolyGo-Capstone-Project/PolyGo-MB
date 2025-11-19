class PostUser {
  final String id;
  final String name;
  final String avatarUrl;

  PostUser({
    required this.id,
    required this.name,
    required this.avatarUrl,
  });

  factory PostUser.fromJson(Map<String, dynamic> json) {
    return PostUser(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
    );
  }
}

class PostComment {
  final String id;
  final String content;
  final DateTime createdAt;
  final PostUser user;
  final bool isMyComment;

  PostComment({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.user,
    required this.isMyComment,
  });

  factory PostComment.fromJson(Map<String, dynamic> json) {
    return PostComment(
      id: json['id'] ?? '',
      content: json['content'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      isMyComment: json['isMyComment'] ?? false,
      user: PostUser.fromJson(json['user']),
    );
  }
}

class PostReaction {
  final String reactionType;
  final int count;
  final List<PostUser> users;

  PostReaction({
    required this.reactionType,
    required this.count,
    required this.users,
  });

  factory PostReaction.fromJson(Map<String, dynamic> json) {
    return PostReaction(
      reactionType: json['reactionType'] ?? '',
      count: json['count'] ?? 0,
      users: (json['users'] as List<dynamic>?)
          ?.map((e) => PostUser.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class PostModel {
  final String id;
  final String content;
  final List<String> imageUrls;
  final DateTime createdAt;
  final PostUser creator;
  final int commentsCount;
  final int reactionsCount;
  final bool isMyPost;
  final List<PostComment> comments;
  final List<PostReaction> reactions;
  final String? myReaction;

  PostModel({
    required this.id,
    required this.content,
    required this.imageUrls,
    required this.createdAt,
    required this.creator,
    required this.isMyPost,
    required this.commentsCount,
    required this.reactionsCount,
    required this.comments,
    required this.reactions,
    this.myReaction,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] ?? '',
      content: json['content'] ?? '',
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      creator: PostUser.fromJson(json['creator']),
      isMyPost: json['isMyPost'] ?? false,
      commentsCount: json['commentsCount'] ?? 0,
      reactionsCount: json['reactionsCount'] ?? 0,
      comments: (json['comments'] as List<dynamic>?)
          ?.map((e) => PostComment.fromJson(e))
          .toList() ??
          [],
      reactions: (json['reactions'] as List<dynamic>?)
          ?.map((e) => PostReaction.fromJson(e))
          .toList() ??
          [],
      myReaction: json['myReaction'],
    );
  }
}
class PostPaginationResponse {
  final List<PostModel> items;
  final int totalItems;
  final int currentPage;
  final int totalPages;
  final int pageSize;
  final bool hasPreviousPage;
  final bool hasNextPage;

  PostPaginationResponse({
    required this.items,
    required this.totalItems,
    required this.currentPage,
    required this.totalPages,
    required this.pageSize,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  factory PostPaginationResponse.fromJson(Map<String, dynamic> json) {
    return PostPaginationResponse(
      items: (json['items'] as List<dynamic>)
          .map((e) => PostModel.fromJson(e))
          .toList(),
      totalItems: json['totalItems'] ?? 0,
      currentPage: json['currentPage'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      pageSize: json['pageSize'] ?? 10,
      hasPreviousPage: json['hasPreviousPage'] ?? false,
      hasNextPage: json['hasNextPage'] ?? false,
    );
  }
}

class PostListResponse {
  final PostPaginationResponse data;
  final String? message;

  PostListResponse({required this.data, this.message});

  factory PostListResponse.fromJson(Map<String, dynamic> json) {
    return PostListResponse(
      data: PostPaginationResponse.fromJson(json['data']),
      message: json['message'],
    );
  }
}

extension PostModelCopy on PostModel {
  PostModel copyWith({
    String? content,
    List<String>? imageUrls,
    DateTime? createdAt,
    PostUser? creator,
    int? commentsCount,
    int? reactionsCount,
    bool? isMyPost,
    List<PostComment>? comments,
    List<PostReaction>? reactions,
    String? myReaction,
  }) {
    return PostModel(
      id: id,
      content: content ?? this.content,
      imageUrls: imageUrls ?? this.imageUrls,
      createdAt: createdAt ?? this.createdAt,
      creator: creator ?? this.creator,
      commentsCount: commentsCount ?? this.commentsCount,
      reactionsCount: reactionsCount ?? this.reactionsCount,
      isMyPost: isMyPost ?? this.isMyPost,
      comments: comments ?? this.comments,
      reactions: reactions ?? this.reactions,
      myReaction: myReaction ?? this.myReaction,
    );
  }
}
