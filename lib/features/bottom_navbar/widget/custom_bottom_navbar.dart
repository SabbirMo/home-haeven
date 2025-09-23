import 'package:flutter/material.dart';
import 'package:home_haven/core/assets/app_colors.dart';
import 'package:home_haven/core/assets/app_icons.dart';

class CustomNavbar extends StatelessWidget {
  const CustomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(AppIcons.homes, 'Home', 0),
          _navItem(AppIcons.cart, 'My Cart', 1),
          _navItem(AppIcons.profile, 'My Account', 2),
        ],
      ),
    );
  }

  Widget _navItem(String iconPath, String label, int index) {
    final isSelected = index == currentIndex;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              iconPath,
              width: isSelected ? 28 : 24,
              height: isSelected ? 28 : 24,
              color: isSelected ? AppColors.primary : AppColors.neutral10,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.neutral10,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
