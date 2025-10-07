import '../models/auth/register_request.dart';
import '../models/auth/login_request.dart';
import '../services/auth_service.dart';
import '../models/auth/reset_password_request.dart';

class AuthRepository {
  final AuthService _service;

  AuthRepository(this._service);

  Future<void> sendOtp({required String mail, int? verificationType}) async {
    final res = await _service.sendOtp(mail: mail, verificationType: verificationType);
    if (res.statusCode != 200) {
      throw Exception(res.message ?? 'Send OTP failed');
    }
  }

  Future<void> register(RegisterRequest req) async {
    final res = await _service.register(req);
    if (res.statusCode != 200) {
      throw Exception(res.message ?? 'Register failed');
    }
  }

  /// Login → trả về JWT token
  Future<String> login(LoginRequest req) async {
    final res = await _service.login(req);
    if (res.statusCode != 200 || res.data == null) {
      throw Exception(res.message ?? 'Login failed');
    }
    return res.data!; // JWT token
  }

  /// Reset password
  Future<void> resetPassword(ResetPasswordRequest req) async {
    final res = await _service.resetPassword(req);
    if (res.statusCode != 200) {
      throw Exception(res.message ?? 'Reset password failed');
    }
  }
}
