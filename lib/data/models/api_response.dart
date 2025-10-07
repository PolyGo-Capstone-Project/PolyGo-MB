class ApiResponse<T> {
  final T? data;
  final String? message;
  final int? statusCode;

  ApiResponse({this.data, this.message, this.statusCode});

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(dynamic) fromData) {
    final dataValue = json['data'];
    return ApiResponse<T>(
      data: dataValue != null ? fromData(dataValue) : null,
      message: json['message'] as String?,
      statusCode: json['statusCode'] as int?,
    );
  }
}
