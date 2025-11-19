class PostReactionResponse {
  final String message;

  PostReactionResponse({required this.message});

  factory PostReactionResponse.fromJson(Map<String, dynamic> json) {
    return PostReactionResponse(
      message: json['message'] ?? '',
    );
  }
}

class PostReactionRequest {
  final String reactionType;

  PostReactionRequest({required this.reactionType});

  Map<String, dynamic> toJson() {
    return {
      'reactionType': reactionType,
    };
  }
}
