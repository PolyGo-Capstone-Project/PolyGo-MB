import 'package:flutter/material.dart';

class AppDropdown extends StatelessWidget {
  final String currentValue;
  final List<String> items;
  final VoidCallback? onTap;

  const AppDropdown({
    super.key,
    required this.currentValue,
    required this.items,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Select',
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      position: PopupMenuPosition.under,
      color: Theme.of(context).colorScheme.surface,
      offset: const Offset(0, 8),
      itemBuilder: (context) {
        return items.map((item) {
          final bool selected = item == currentValue;
          return PopupMenuItem<String>(
            value: item,
            child: Row(
              children: [
                if (selected)
                  const Icon(Icons.check, size: 18)
                else
                  const SizedBox(width: 18),
                const SizedBox(width: 8),
                Text(
                  item,
                  style: TextStyle(
                    color: selected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurface,
                    fontWeight:
                    selected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        }).toList();
      },
      onSelected: (_) {
        if (onTap != null) onTap!();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.surfaceVariant,
        ),
        child: Row(
          children: [
            const Icon(Icons.language, size: 20),
            const SizedBox(width: 6),
            Text(
              currentValue,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}
