import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../routes/app_routes.dart'; // 👈 để gọi route của bạn

class AppBottomBar extends StatefulWidget {
  final int currentIndex; // 👈 thêm thuộc tính
  const AppBottomBar({super.key, this.currentIndex = 0});

  @override
  State<AppBottomBar> createState() => _AppBottomBarState();
}

class _AppBottomBarState extends State<AppBottomBar> {
  late int _selectedIndex;

  final _items = const [
    {'icon': Icons.home_rounded, 'label': 'Home'},
    {'icon': Icons.people_alt_rounded, 'label': 'Friend'},
    {'icon': Icons.storefront_rounded, 'label': 'Shop'},
    {'icon': Icons.person_rounded, 'label': 'Me'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentIndex;
  }

  void _onItemTapped(BuildContext context, int index) {
    setState(() => _selectedIndex = index);

    // 🔹 Điều hướng tương ứng theo index
    switch (index) {
      case 0:
        Navigator.pushNamed(context, AppRoutes.home);
        break;
      case 1:
        Navigator.pushNamed(context, AppRoutes.home);
        break;
      case 2:
        Navigator.pushNamed(context, AppRoutes.home);
        break;
      case 3:
        Navigator.pushNamed(context, AppRoutes.userInfo);
        break;
      case 4:

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorActive = const Color(0xFF2563EB);
    final colorInactive = theme.iconTheme.color?.withOpacity(0.6) ?? Colors.grey;

    // 🔹 Responsive scale factor
    final screenWidth = MediaQuery.of(context).size.width;
    final scale = screenWidth < 400
        ? 1.0
        : screenWidth < 800
        ? 1.2
        : 1.5;

    final iconSize = 26 * scale;
    final fontSize = 14 * scale;
    final paddingV = 10 * scale;
    final paddingH = 12 * scale;

    return Container(
      padding: EdgeInsets.symmetric(vertical: paddingV / 1.5, horizontal: 8 * scale),
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: theme.brightness == Brightness.dark
                ? Colors.grey.withOpacity(0.1)
                : const Color(0x22000000),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_items.length, (index) {
          final item = _items[index];
          final selected = _selectedIndex == index;
          final iconColor = selected ? colorActive : colorInactive;

          return GestureDetector(
            onTap: () => _onItemTapped(context, index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
              decoration: BoxDecoration(
                color: selected ? colorActive.withOpacity(0.1) : Colors.transparent,
                borderRadius: BorderRadius.circular(12 * scale),
              ),
              child: Row(
                children: [
                  Icon(item['icon'] as IconData, color: iconColor, size: iconSize),
                  if (selected) ...[
                    SizedBox(width: 6 * scale),
                    Text(
                      item['label'] as String,
                      style: TextStyle(
                        color: colorActive,
                        fontWeight: FontWeight.w600,
                        fontSize: fontSize,
                      ),
                    ).animate().fadeIn(duration: 250.ms),
                  ],
                ],
              ),
            ),
          );
        }),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}
