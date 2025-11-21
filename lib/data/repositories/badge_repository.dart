import '../models/badges/badge_detail_data.dart';
import '../models/badges/badge_model.dart';
import '../services/apis/badge_service.dart';

class BadgeRepository {
  final BadgeService _service;

  BadgeRepository(this._service);

  /// Get all badges (including locked)
  Future<List<BadgeModel>> getMyBadgesAll(String token, {String lang = 'en'}) async {
    final res = await _service.getMyBadgesAll(token: token, lang: lang);
    if (res.data == null) return [];
    return res.data!.items;
  }

  /// Get badges that user currently owns
  Future<List<BadgeModel>> getMyBadges(String token, {String lang = 'en'}) async {
    final res = await _service.getMyBadges(token: token, lang: lang);
    if (res.data == null) return [];
    return res.data!.items;
  }

  Future<BadgeDetailData?> getBadgeById(
      String token,
      String id,
      {String lang = 'en'}
      ) async {
    final res = await _service.getBadgeById(
      token: token,
      id: id,
      lang: lang,
    );

    return res.data?.data;
  }

  Future<ClaimBadgeResponse?> claimBadge(String token, String id) async {
    final res = await _service.claimBadge(token: token, id: id);
    return res.data;
  }
}
