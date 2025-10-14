import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomeMenuBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onItemSelected;

  const HomeMenuBar({
    super.key,
    this.currentIndex = 0,
    required this.onItemSelected,
  });

  @override
  State<HomeMenuBar> createState() => _HomeMenuBarState();
}

class _HomeMenuBarState extends State<HomeMenuBar> {
  late int _selectedIndex;

  final _items = const [
    {'icon': Icons.event_rounded},
    {'icon': Icons.favorite_rounded},
    {'icon': Icons.group_rounded},
    {'icon': Icons.public_rounded},
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentIndex;
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    widget.onItemSelected(index);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorActive = const Color(0xFF2563EB);
    final colorInactive = theme.iconTheme.color?.withOpacity(0.6) ?? Colors.grey;

    final screenWidth = MediaQuery.of(context).size.width;
    final scale = screenWidth < 400
        ? 1.0
        : screenWidth < 800
        ? 1.2
        : 1.5;

    final iconSize = 28 * scale;
    final paddingV = 10 * scale;
    final paddingH = 8 * scale;

    return Container(
      padding: EdgeInsets.symmetric(vertical: paddingV / 2),
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: theme.brightness == Brightness.dark
                ? Colors.black.withOpacity(0.25)
                : Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_items.length, (index) {
          final item = _items[index];
          final selected = _selectedIndex == index;

          return GestureDetector(
            onTap: () => _onItemTapped(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
              decoration: BoxDecoration(
                color: selected ? colorActive.withOpacity(0.1) : Colors.transparent,
                borderRadius: BorderRadius.circular(12 * scale),
              ),
              child: Icon(
                item['icon'] as IconData,
                color: selected ? colorActive : colorInactive,
                size: iconSize,
              ),
            ),
          );
        }),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}
