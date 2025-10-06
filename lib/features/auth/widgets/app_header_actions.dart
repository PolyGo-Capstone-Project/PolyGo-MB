import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../main.dart';

class AppHeaderActions extends StatelessWidget {
  final VoidCallback onThemeToggle;

  const AppHeaderActions({
    super.key,
    required this.onThemeToggle,
  });

  @override
  Widget build(BuildContext context) {
    final inherited = InheritedLocale.of(context);
    final lang = inherited.locale.languageCode;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final loc = AppLocalizations.of(context);

    Widget buildPopupItem(String value, String label, bool selected) {
      return Row(
        children: [
          if (selected)
            Icon(Icons.check, size: 18 * MediaQuery.of(context).textScaleFactor)
          else
            SizedBox(width: 18),
          SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: selected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        PopupMenuButton<String>(
          tooltip: loc.translate('login_title'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          position: PopupMenuPosition.under,
          color: Theme.of(context).colorScheme.surface,
          offset: const Offset(0, 8),
          icon: const Icon(Icons.language),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'en',
              child: buildPopupItem('en', 'English', lang == 'en'),
            ),
            PopupMenuItem(
              value: 'vi',
              child: buildPopupItem('vi', 'Tiếng Việt', lang == 'vi'),
            ),
          ],
          onSelected: (value) {
            inherited.setLocale(Locale(value));
          },
        ),
        const SizedBox(width: 12),
        PopupMenuButton<String>(
          tooltip: loc.translate('login_title'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          position: PopupMenuPosition.under,
          color: Theme.of(context).colorScheme.surface,
          offset: const Offset(0, 8),
          icon: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'light',
              child: buildPopupItem('light', loc.translate('light_mode'), !isDark),
            ),
            PopupMenuItem(
              value: 'dark',
              child: buildPopupItem('dark', loc.translate('dark_mode'), isDark),
            ),
          ],
          onSelected: (value) {
            final inheritedTheme = InheritedThemeMode.of(context);
            if (value == 'dark') {
              inheritedTheme.setThemeMode(ThemeMode.dark);
            } else {
              inheritedTheme.setThemeMode(ThemeMode.light);
            }
          },
        ),
      ],
    );
  }
}
