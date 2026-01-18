import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workspace/core/utils/app_images.dart';
import 'package:workspace/core/helper/navigation.dart';
import 'package:workspace/features/thesis/auth/cubit/auth_cubit.dart';
import 'package:workspace/features/thesis/home/screen/landing_page.dart';
import 'package:workspace/features/thesis/admin/landing/admin_landing.dart';
import 'package:workspace/features/thesis/admin/screen/admin_login_page.dart';
import 'package:workspace/features/thesis/admin/service/admin_auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AdminAuthService _adminAuthService = AdminAuthService();
  @override
  void initState() {
    super.initState();
    _navigateToLandingPage();
  }

  void _navigateToLandingPage() async {
    await Future.delayed(const Duration(seconds: 1));
    final user = await _adminAuthService.getCurrentUser();
    if (!mounted) return;
    if (user != null) {
      Logger().d(user.toMap());
      context.read<AuthCubit>().updateUser(user);
      final child = user.isAdmin
          ? const AdminLandingPage()
          : const LandingPage();
      AppNavigator.pushAndRemoveUntil(context, child);
    } else {
      AppNavigator.pushAndRemoveUntil(context, const AdminLoginPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Image.asset(AppImages.icon, height: 200, width: 200)),
    );
  }
}
