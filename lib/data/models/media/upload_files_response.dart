class UploadFilesResponse {
  final List<String> urls;
  final String message;

  UploadFilesResponse({
    required this.urls,
    required this.message,
  });

  factory UploadFilesResponse.fromJson(Map<String, dynamic> json) {
    return UploadFilesResponse(
      urls: (json['data'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      message: json['message'] ?? 'Success',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': urls,
      'message': message,
    };
  }
}
