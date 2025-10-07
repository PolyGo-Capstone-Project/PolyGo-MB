import 'package:dio/dio.dart';
import '../../core/api/api_client.dart';
import '../../core/config/api_constants.dart';
import '../models/auth/register_request.dart';
import '../models/auth/login_request.dart';
import '../models/api_response.dart';

class AuthService {
  final ApiClient apiClient;

  AuthService(this.apiClient);

  /// Gửi OTP
  Future<ApiResponse<void>> sendOtp({required String mail, int? verificationType}) async {
    final query = <String, dynamic>{'mail': mail};
    if (verificationType != null) query['verificationType'] = verificationType;
    try {
      final response = await apiClient.get(ApiConstants.sendOtp, queryParameters: query);
      return ApiResponse.fromJson(response.data as Map<String, dynamic>, (_) => null);
    } on DioError catch (e) {
      rethrow;
    }
  }

  /// Đăng ký
  Future<ApiResponse<void>> register(RegisterRequest req) async {
    try {
      final response = await apiClient.post(ApiConstants.register, data: req.toJson());
      return ApiResponse.fromJson(response.data as Map<String, dynamic>, (_) => null);
    } on DioError catch (e) {
      rethrow;
    }
  }

  /// 🔐 Đăng nhập
  Future<ApiResponse<String>> login(LoginRequest req) async {
    try {
      final response = await apiClient.post(ApiConstants.login, data: req.toJson());
      return ApiResponse.fromJson(response.data as Map<String, dynamic>, (data) => data as String);
    } on DioError catch (e) {
      rethrow;
    }
  }
}
