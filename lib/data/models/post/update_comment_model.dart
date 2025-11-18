class UpdateCommentRequest {
  final String content;

  UpdateCommentRequest({required this.content});

  Map<String, dynamic> toJson() => {
    'content': content,
  };
}
