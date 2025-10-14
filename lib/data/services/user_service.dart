import 'package:dio/dio.dart';
import '../../core/api/api_client.dart';
import '../../core/config/api_constants.dart';
import '../models/api_response.dart';
import '../models/user/profile_setup_request.dart';
import '../models/user/update_profile_request.dart';
import '../models/user/update_userinfo_request.dart';
import '../models/user/user_list_response.dart';

class UserService {
  final ApiClient apiClient;

  UserService(this.apiClient);

  /// profile-setup
  Future<ApiResponse<void>> profileSetup(String token, ProfileSetupRequest req) async {
    try {
      final response = await apiClient.put(
        ApiConstants.profileSetup,
        data: req.toJson(),
        headers: {
          ApiConstants.headerAuthorization: 'Bearer $token',
        },
      );

      final json = response.data as Map<String, dynamic>;
      return ApiResponse.fromJson(json, (_) => null);
    } on DioError catch (e) {
      if (e.response != null) {
        // print('Profile setup error: ${e.response?.data}');
      }
      rethrow;
    }
  }

  Future<ApiResponse<void>> updateProfile({
    required String token,
    required UpdateProfileRequest req,
  }) async {
    try {
      final response = await apiClient.put(
        ApiConstants.updateProfile,
        data: req.toJson(),
        headers: {ApiConstants.headerAuthorization: 'Bearer $token'},
      );
      return ApiResponse.fromJson(response.data as Map<String, dynamic>, (_) => null);
    } on DioError catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse<void>> updateUserInfo({
    required String token,
    required UpdateInfoRequest req,
  }) async {
    try {
      final response = await apiClient.put(
        ApiConstants.userInfo,
        data: req.toJson(),
        headers: {
          ApiConstants.headerAuthorization: 'Bearer $token',
          ApiConstants.headerContentType: ApiConstants.contentTypeJson,
        },
      );

      return ApiResponse.fromJson(response.data as Map<String, dynamic>, (_) => null);
    } on DioError catch (e) {
      if (e.response != null) {
        print('Update profile (me) error: ${e.response?.data}');
      }
      rethrow;
    }
  }

  Future<UserListResponse> getUsers({
    required String token,
    int pageNumber = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await apiClient.get(
        ApiConstants.getUsers,
        queryParameters: {
          'pageNumber': pageNumber,
          'pageSize': pageSize,
        },
        headers: {
          ApiConstants.headerAuthorization: 'Bearer $token',
        },
      );

      return UserListResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioError catch (e) {
      if (e.response != null) {
        print('Get users error: ${e.response?.data}');
      }
      rethrow;
    }
  }
}
