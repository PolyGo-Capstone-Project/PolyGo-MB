class UpdatePostRequest {
  final String content;
  final List<String> imageUrls;

  UpdatePostRequest({
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

class UpdatePostResponse {
  final String message;

  UpdatePostResponse({required this.message});

  factory UpdatePostResponse.fromJson(Map<String, dynamic> json) {
    return UpdatePostResponse(
      message: json['message'] ?? 'Success.Update',
    );
  }
}
