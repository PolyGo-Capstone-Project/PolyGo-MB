// core/api/auth_service.dart
import 'package:dio/dio.dart';
import '../../core/api/api_client.dart';
import '../../core/config/api_constants.dart';

class AuthService {
  final ApiClient apiClient;

  AuthService(this.apiClient);

  /// Login với email + password
  Future<String> login(String mail, String password) async {
    try {
      final response = await apiClient.post(
        ApiConstants.login,
        data: {
          "mail": mail,
          "password": password,
        },
      );

      if (response.statusCode == 200) {
        // trả về body JSON (token hoặc thông tin user)
        return response.data.toString();
      } else {
        throw Exception('Login failed: ${response.statusCode}');
      }
    } on DioError catch (e) {
      // Xử lý lỗi mạng hoặc server
      throw Exception('Login error: ${e.response?.data ?? e.message}');
    }
  }
}
