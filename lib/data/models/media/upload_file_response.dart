class UploadFileResponse {
  final String fileName;
  final String url;

  UploadFileResponse({
    required this.fileName,
    required this.url,
  });

  factory UploadFileResponse.fromJson(Map<String, dynamic> json) {
    return UploadFileResponse(
      fileName: '',
      url: json['data'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fileName': fileName,
      'url': url,
    };
  }
}
