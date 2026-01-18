import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workspace/core/utils/app_colors.dart';
import 'package:workspace/core/utils/app_styles.dart';
import 'package:workspace/core/helper/navigation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:workspace/core/service/app_validator.dart';
import 'package:workspace/core/components/app_button.dart';
import 'package:workspace/core/components/app_snack_bar.dart';
import 'package:workspace/core/components/app_text_field.dart';
import 'package:workspace/features/thesis/auth/cubit/auth_cubit.dart';
import 'package:workspace/features/thesis/home/screen/landing_page.dart';
import 'package:workspace/features/thesis/admin/landing/admin_landing.dart';
import 'package:workspace/features/thesis/admin/service/admin_auth_service.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final TextEditingController _passwordTEC = TextEditingController();
  final TextEditingController _emailTEC = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AdminAuthService _authService = AdminAuthService();
  final AppValidator _validator = AppValidator();
  bool obscureText = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top + 40),
              const Text(
                'WorkSync',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 50,
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Welcome to WorkSync, the best platform for sales '
                'representative management and their work.'
                '\n\nLet\'s get started!',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              Text(context.tr('email_phone'), style: AppStyles.mediumGrey),
              const SizedBox(height: 12),
              AppTextField(
                controller: _emailTEC,
                hintText: context.tr('email_phone'),
                validator: _validator.validateEmail,
              ),
              const SizedBox(height: 24),
              Text(context.tr('password'), style: AppStyles.mediumGrey),
              const SizedBox(height: 12),
              AppTextField(
                maxLine: 1,
                controller: _passwordTEC,
                obscureText: obscureText,
                hintText: context.tr('password'),
                validator: _validator.validatePassword,
                suffixIcon: TextFieldIcon(
                  icon: obscureText
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  onTap: () => setState(() => obscureText = !obscureText),
                ),
              ),

              const SizedBox(height: 30),
              AppButton(
                isLoading: isLoading,
                text: context.tr('sign_in'),
                onTap: _userLogin,
              ),
              const SizedBox(height: 40),
              Text(
                'By signing in, you agree to our Terms of Use and Privacy Policy',
                textAlign: TextAlign.center,
                style: AppStyles.mediumGrey,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  void _userLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);
    final result = await _authService.signIn(_emailTEC.text, _passwordTEC.text);
    if (!mounted) return;
    setState(() => isLoading = false);
    result.fold((f) => AppSnackBar.error(context, f), (user) {
      context.read<AuthCubit>().updateUser(user);
      AppSnackBar.show(context, 'Login successfully.');
      final child = user.isAdmin
          ? const AdminLandingPage()
          : const LandingPage();
      AppNavigator.pushAndRemoveUntil(context, child);
    });
  }
}
