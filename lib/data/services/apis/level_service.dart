import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';
import '../../../core/config/api_constants.dart';
import '../../models/api_response.dart';
import '../../models/levels/level_item.dart';

class LevelService {
  final ApiClient apiClient;

  LevelService(this.apiClient);

  Future<ApiResponse<LevelListResponse>> getLevels({
    required String token,
    String lang = 'en',
    int pageNumber = -1,
    int pageSize = -1,
  }) async {
    try {
      final response = await apiClient.get(
        '${ApiConstants.levels}?lang=$lang&pageNumber=$pageNumber&pageSize=$pageSize',
        headers: {
          ApiConstants.headerAuthorization: 'Bearer $token',
        },
      );

      final json = response.data as Map<String, dynamic>;

      return ApiResponse.fromJson(
        json,
            (data) => LevelListResponse.fromJson(json),
      );
    } on DioError {
      rethrow;
    }
  }

  /// Claim level
  Future<ClaimLevelResponse> claimLevel({
    required String token,
    required String id,
  }) async {
    try {
      final url = ApiConstants.claimLevel.replaceFirst('{id}', id);
      final response = await apiClient.put(
        url,
        headers: {ApiConstants.headerAuthorization: 'Bearer $token'},
      );

      final json = response.data as Map<String, dynamic>;
      return ClaimLevelResponse.fromJson(json);
    } on DioError {
      rethrow;
    }
  }
}
