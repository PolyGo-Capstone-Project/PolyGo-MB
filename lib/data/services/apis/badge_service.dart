import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';
import '../../../core/config/api_constants.dart';
import '../../models/api_response.dart';
import '../../models/badges/badge_detail_data.dart';
import '../../models/badges/badge_list_response.dart';
import '../../models/badges/badge_model.dart';

class BadgeService {
  final ApiClient apiClient;

  BadgeService(this.apiClient);

  /// Get all badges (me-all)
  Future<ApiResponse<BadgeListResponse>> getMyBadgesAll({
    required String token,
    String lang = 'en',
    int pageNumber = -1,
    int pageSize = -1,
  }) async {
    try {
      final response = await apiClient.get(
        '${ApiConstants.badgesMeAll}?lang=$lang&pageNumber=$pageNumber&pageSize=$pageSize',
        headers: {ApiConstants.headerAuthorization: 'Bearer $token'},
      );

      final json = response.data as Map<String, dynamic>;
      return ApiResponse.fromJson(
        json,
            (data) => BadgeListResponse.fromJson(json),
      );
    } on DioError catch (e) {
      rethrow;
    }
  }

  /// Get badges that user already owns (me)
  Future<ApiResponse<BadgeListResponse>> getMyBadges({
    required String token,
    String lang = 'en',
    int pageNumber = -1,
    int pageSize = -1,
  }) async {
    try {
      final response = await apiClient.get(
        '${ApiConstants.badgesMe}?lang=$lang&pageNumber=$pageNumber&pageSize=$pageSize',
        headers: {ApiConstants.headerAuthorization: 'Bearer $token'},
      );

      final json = response.data as Map<String, dynamic>;
      return ApiResponse.fromJson(
        json,
            (data) => BadgeListResponse.fromJson(json),
      );
    } on DioError catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse<BadgeDetailResponse>> getBadgeById({
    required String token,
    required String id,
    String lang = 'en',
  }) async {
    try {
      final response = await apiClient.get(
        '${ApiConstants.badgeById.replaceFirst('{id}', id)}?lang=$lang',
        headers: {ApiConstants.headerAuthorization: 'Bearer $token'},
      );

      final json = response.data as Map<String, dynamic>;
      return ApiResponse.fromJson(
        json,
            (data) => BadgeDetailResponse.fromJson(json),
      );
    } on DioError catch (e) {
      rethrow;
    }
  }

  /// Claim badge
  Future<ApiResponse<ClaimBadgeResponse>> claimBadge({
    required String token,
    required String id,
  }) async {
    try {
      final response = await apiClient.put(
        ApiConstants.claimBadge.replaceFirst("{id}", id),
        headers: {ApiConstants.headerAuthorization: "Bearer $token"},
      );

      final json = response.data as Map<String, dynamic>;
      return ApiResponse.fromJson(
        json,
            (data) => ClaimBadgeResponse.fromJson(json),
      );
    } on DioError catch (e) {
      rethrow;
    }
  }
}
