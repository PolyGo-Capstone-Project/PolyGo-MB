import 'package:flutter/material.dart';

class AppDropdown extends StatelessWidget {
  static bool _menuOpen = false;

  final String currentValue;
  final List<String> items;
  final ValueChanged<String>? onSelected;
  final VoidCallback? onTap;
  final double borderRadius;
  final IconData? icon;

  const AppDropdown({
    super.key,
    required this.currentValue,
    required this.items,
    this.onSelected,
    this.onTap,
    this.borderRadius = 8.0,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (innerContext) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Material(
          color: Theme.of(context).colorScheme.surfaceVariant,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(borderRadius),
            onTap: () async {
              //
              if (_menuOpen) return;
              _menuOpen = true;

              final RenderBox button =
              innerContext.findRenderObject() as RenderBox;
              final Offset topLeft = button.localToGlobal(Offset.zero);

              //
              final Rect rect = Rect.fromLTWH(
                topLeft.dx,
                topLeft.dy + button.size.height + 4,
                button.size.width,
                button.size.height,
              );

              final selected = await showMenu<String>(
                context: innerContext,
                position: RelativeRect.fromRect(
                  rect,
                  Offset.zero & MediaQuery.of(innerContext).size,
                ),
                items: items.map((item) {
                  final bool isSelected = item == currentValue;
                  return PopupMenuItem<String>(
                    value: item,
                    child: Row(
                      children: [
                        if (isSelected)
                          Icon(Icons.check,
                              size: 18,
                              color: Theme.of(innerContext)
                                  .colorScheme
                                  .primary)
                        else
                          const SizedBox(width: 18),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            item,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: isSelected
                                  ? Theme.of(innerContext)
                                  .colorScheme
                                  .primary
                                  : Theme.of(innerContext)
                                  .colorScheme
                                  .onSurface,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Theme.of(innerContext).colorScheme.surface,
              );

              _menuOpen = false;

              if (!innerContext.mounted) return;

              if (selected != null) {
                if (onSelected != null) {
                  onSelected!(selected);
                } else if (onTap != null) {
                  onTap!();
                }
              }
            },
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon ?? Icons.language,
                    size: 20,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      currentValue,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
