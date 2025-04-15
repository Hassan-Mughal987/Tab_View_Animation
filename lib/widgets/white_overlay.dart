import 'package:flutter/material.dart';
import 'package:tab_view_animation/providers/home_provider.dart';


class WhiteOverlay extends StatelessWidget {
  final HomeProvider provider;

  const WhiteOverlay({super.key, required this.provider});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
      valueListenable: provider.overlayColorNotifier,
      builder: (context, overlayColor, child) {
        return ValueListenableBuilder<int>(
          valueListenable: provider.selectedIndexNotifier,
          builder: (context, selectedIndex, child) {
            // Ensure selectedIndex is within bounds and tabNames is not empty
            final tabName = provider.tabNames.isNotEmpty && selectedIndex >= 0 && selectedIndex < provider.tabNames.length
                ? provider.tabNames[selectedIndex]
                : ''; // Default value if index is out of bounds or list is empty

            // Cache the container width to avoid redundant calculations
            final containerWidth = provider.getContainerWidth(tabName);

            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: overlayColor,
                borderRadius: BorderRadius.circular(21),
              ),
              height: 35,
              width: containerWidth,
              alignment: Alignment.center,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    tabName,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}