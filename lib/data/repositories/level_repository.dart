import '../models/levels/level_item.dart';
import '../services/apis/level_service.dart';

class LevelRepository {
  final LevelService _service;

  LevelRepository(this._service);

  Future<List<LevelItem>> getLevels(
      String token, {
        String lang = 'en',
        int pageNumber = -1,
        int pageSize = -1,
      }) async {
    final res = await _service.getLevels(
      token: token,
      lang: lang,
      pageNumber: pageNumber,
      pageSize: pageSize,
    );

    if (res.data == null) return [];
    return res.data!.items;
  }

  Future<ClaimLevelResponse> claimLevel(String token, String id) async {
    return await _service.claimLevel(token: token, id: id);
  }
}
