import '../models/user/profile_setup_request.dart';
import '../models/user/update_profile_request.dart';
import '../models/user/update_userinfo_request.dart';
import '../models/user/user_list_response.dart';
import '../services/user_service.dart';

class UserRepository {
  final UserService _service;

  UserRepository(this._service);

  /// profile setup
  Future<void> profileSetup(String token, ProfileSetupRequest req) async {
    try {
      await _service.profileSetup(token, req);
    } catch (e) {
      // throw Exception('Profile setup failed: $e');
    }
  }

  Future<void> updateProfile(String token, UpdateProfileRequest req) async {
    try {
      await _service.updateProfile(token: token, req: req);
    } catch (e) {
      // throw Exception('Update profile failed: $e');
    }
  }

  Future<void> updateUserInfo(String token, UpdateInfoRequest req) async {
    try {
      await _service.updateUserInfo(token: token, req: req);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserListResponse> getUsers(String token, {int page = 1, int size = 10}) async {
    try {
      return await _service.getUsers(
        token: token,
        pageNumber: page,
        pageSize: size,
      );
    } catch (e) {
      rethrow;
    }
  }
}
