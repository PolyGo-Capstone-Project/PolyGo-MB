import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../shared/app_bottom_bar.dart';
import '../widgets/gifts/accepted_gifts.dart';
import '../widgets/gifts/gifts_header_menu.dart';
import '../widgets/gifts/my_gifts.dart';
import '../widgets/gifts/sent_gifts.dart';

class AllGiftsScreen extends StatefulWidget {
  const AllGiftsScreen({super.key});

  @override
  State<AllGiftsScreen> createState() => _AllGiftsScreenState();
}

class _AllGiftsScreenState extends State<AllGiftsScreen> {
  int _selectedTab = 2;

  void _onTabSelected(int index) {
    setState(() => _selectedTab = index);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Widget buildTabContent() {
      switch (_selectedTab) {
        case 0:
          return const SentGifts();
        case 1:
          return const AcceptedGifts();
        case 2:
          return const MyGifts();
        default:
          return const SizedBox.shrink();
      }
    }

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            GiftsHeaderMenu(
              currentIndex: _selectedTab,
              onItemSelected: _onTabSelected,
            ),
            Expanded(child: buildTabContent()),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: const AppBottomBar(currentIndex: 5),
      ),
    );
  }
}
