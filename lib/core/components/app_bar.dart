import 'package:flutter/material.dart';
import 'package:workspace/core/utils/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.onBackTap,
    required this.title,
    this.hasBackButton = true,
  });

  final String title;
  final bool hasBackButton;
  final VoidCallback? onBackTap;

  @override
  Size get preferredSize => AppBar().preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      shadowColor: Colors.white,
      surfaceTintColor: Colors.white,
      backgroundColor: AppColors.primary,
      automaticallyImplyLeading: hasBackButton,
      leading: hasBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            )
          : const SizedBox(),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class AdminAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AdminAppBar({
    super.key,
    this.onBackTap,
    required this.title,
    this.hasBackButton = true,
  });

  final String title;
  final bool hasBackButton;
  final VoidCallback? onBackTap;

  @override
  Size get preferredSize => AppBar().preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      shadowColor: Colors.white,
      surfaceTintColor: Colors.white,
      backgroundColor: AppColors.secondary,
      automaticallyImplyLeading: hasBackButton,
      leading: hasBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            )
          : const SizedBox(),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
