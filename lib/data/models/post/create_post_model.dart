import 'package:polygo_mobile/data/models/post/post_model.dart';

class CreatePostRequest {
  final String content;
  final List<String> imageUrls;

  CreatePostRequest({
    required this.content,
    required this.imageUrls,
  });

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'imageUrls': imageUrls,
    };
  }
}

class CreatePostResponse {
  final PostModel post;

  CreatePostResponse({required this.post});

  factory CreatePostResponse.fromJson(Map<String, dynamic> json) {
    return CreatePostResponse(
      post: PostModel.fromJson(json['data']),
    );
  }
}
