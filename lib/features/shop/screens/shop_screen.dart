  import 'package:flutter/material.dart';
  import '../../shared/app_bottom_bar.dart';
  import '../../shared/app_error_state.dart';
  import '../widgets/shop_menu_bar.dart';
  import '../widgets/subscriptions.dart';
  import '../widgets/gifts.dart';
  import '../widgets/wallet.dart'; // ✅ import Wallet
  import '../../../../core/localization/app_localizations.dart';

  class ShopScreen extends StatefulWidget {
    const ShopScreen({super.key});

    @override
    State<ShopScreen> createState() => _ShopScreenState();
  }

  class _ShopScreenState extends State<ShopScreen> {
    int _selectedTab = 0;
    bool _hasError = false;

    void _onTabSelected(int index) {
      setState(() => _selectedTab = index);
    }

    void _retry() {
      setState(() {
        _hasError = false;
      });
      // Nếu tab là Wallet/Gifts/Subscriptions, gọi lại load data bên trong widget đó
      // Ví dụ bạn có thể expose method loadData() trong mỗi widget
    }

    Widget _buildTabContent() {
      try {
        switch (_selectedTab) {
          case 0:
            return const Subscriptions();
          case 1:
            return const Gifts();
          case 2:
            return const Wallet();
          default:
            return const SizedBox.shrink();
        }
      } catch (e, st) {
        debugPrint("Error in ShopScreen tab: $e\n$st");
        _hasError = true;
        return AppErrorState(onRetry: _retry);
      }
    }

    @override
    Widget build(BuildContext context) {
      final theme = Theme.of(context);
      final isDark = theme.brightness == Brightness.dark;

      return Scaffold(
        backgroundColor: isDark ? Colors.black : Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              ShopMenuBar(
                currentIndex: _selectedTab,
                onItemSelected: _onTabSelected,
              ),
              Expanded(
                child: _hasError
                    ? AppErrorState(onRetry: _retry)
                    : _buildTabContent(),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const AppBottomBar(currentIndex: 2),
      );
    }
  }
