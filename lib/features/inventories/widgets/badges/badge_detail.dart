import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../data/models/badges/badge_detail_data.dart';
import '../../../../data/models/badges/badge_model.dart';
import '../../../../data/repositories/badge_repository.dart';
import '../../../../data/services/apis/badge_service.dart';
import '../../../../core/api/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BadgeDetailDialog extends StatefulWidget {
  final String badgeId;

  const BadgeDetailDialog({super.key, required this.badgeId});

  @override
  State<BadgeDetailDialog> createState() => _BadgeDetailDialogState();
}

class _BadgeDetailDialogState extends State<BadgeDetailDialog> {
  bool _loading = true;
  BadgeDetailData? _badgeDetail;
  Locale? _currentLocale;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final loc = AppLocalizations.of(context);
      final lang = loc.locale.languageCode;
      _loadBadgeDetail(lang: lang);
    });
  }

  Future<void> _loadBadgeDetail({String? lang}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      if (!mounted) return;
      Navigator.pop(context);
      return;
    }

    try {
      final repo = BadgeRepository(BadgeService(ApiClient()));
      final badgeDetail = await repo.getBadgeById(token, widget.badgeId, lang: lang ?? 'vi');

      if (!mounted) return;
      setState(() {
        _badgeDetail = badgeDetail;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      final loc = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.translate("load_badges_error")),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: _loading
          ? SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      )
          : _badgeDetail == null
          ? SizedBox(
        height: 200,
        child: Center(child: Text("Badge not found", style: t.bodyMedium)),
      )
          : Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [const Color(0xFF1E1E1E), const Color(0xFF2C2C2C)]
                : [Colors.white, Colors.white],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                _badgeDetail!.iconUrl.isNotEmpty
                    ? _badgeDetail!.iconUrl
                    : 'https://img.icons8.com/color/96/medal.png',
                height: 100,
                width: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 100,
                  width: 100,
                  color: Colors.grey[300],
                  child: const Icon(Icons.shield, size: 40),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _badgeDetail!.name,
              style: t.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: isDark ? Colors.white : Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _badgeDetail!.description.isNotEmpty
                  ? _badgeDetail!.description
                  : "No description",
              style: t.bodyMedium?.copyWith(
                fontSize: 14,
                color: isDark ? Colors.white70 : Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ).animate().fadeIn(duration: 350.ms),
    );
  }
}
