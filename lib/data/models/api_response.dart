// lib/data/models/api_response.dart
class ApiResponse<T> {
  final T? data;
  final String? message;
  final int? statusCode;

  ApiResponse({this.data, this.message, this.statusCode});

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(Object? json) fromData) {
    return ApiResponse<T>(
      data: json['data'] != null ? fromData(json['data']) : null,
      message: json['message'] as String?,
      statusCode: json['statusCode'] as int?,
    );
  }
}
