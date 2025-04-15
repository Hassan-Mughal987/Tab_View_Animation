import 'package:flutter/material.dart';
import 'package:tab_view_animation/providers/home_provider.dart';
class GreyContainer extends StatelessWidget {
  final HomeProvider provider;
  final int index;

  const GreyContainer({super.key, required this.provider, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => provider.onTabSelected(index),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade700,
          borderRadius: BorderRadius.circular(8),
        ),
        height: 35,
        width: provider.getContainerWidth(provider.tabNames[index]),
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              provider.tabNames[index],
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ),
      ),
    );
  }
}