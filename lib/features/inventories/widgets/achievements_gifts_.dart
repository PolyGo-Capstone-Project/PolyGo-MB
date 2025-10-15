import 'package:flutter/material.dart';
import '../../../../core/utils/responsive.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../routes/app_routes.dart';

class AchievementsAndGiftsSection extends StatelessWidget {
  const AchievementsAndGiftsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth = screenWidth < 500
        ? screenWidth * 0.9
        : screenWidth < 900
        ? screenWidth * 0.75
        : screenWidth < 1400
        ? screenWidth * 0.6
        : 900.0;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final sectionDecoration = BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDark
            ? [const Color(0xFF1E1E1E), const Color(0xFF2C2C2C)]
            : [const Color(0xFFFFFFFF), const Color(0xFFFFFFFF)],
      ),
      borderRadius: BorderRadius.circular(sw(context, 16)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ],
    );

    final spacing = sw(context, 12);
    final sectionWidth = (containerWidth - spacing) / 2;

    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: containerWidth,
        padding: EdgeInsets.symmetric(
          horizontal: 0,
          vertical: sh(context, 12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, AppRoutes.allBadges),
              child: Container(
                width: sectionWidth,
                padding: EdgeInsets.all(sw(context, 16)),
                decoration: sectionDecoration,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      "https://img.icons8.com/fluency/120/trophy.png",
                      width: sw(context, 80),
                      height: sw(context, 80),
                    ),
                    SizedBox(height: sh(context, 12)),
                    Text(AppLocalizations.of(context).translate("my_badges"),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            GestureDetector(
              onTap: () => Navigator.pushNamed(context, AppRoutes.allGifts),
              child: Container(
                width: sectionWidth,
                padding: EdgeInsets.all(sw(context, 16)),
                decoration: sectionDecoration,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      "https://img.icons8.com/fluency/120/gift.png",
                      width: sw(context, 80),
                      height: sw(context, 80),
                    ),
                    SizedBox(height: sh(context, 12)),
                    Text(AppLocalizations.of(context).translate("my_gifts"),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
