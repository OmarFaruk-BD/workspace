import 'package:flutter/material.dart';
import 'package:workspace/core/utils/app_colors.dart';
import 'package:workspace/core/utils/app_styles.dart';
import 'package:workspace/core/helper/navigation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:workspace/core/components/app_button.dart';
import 'package:workspace/core/components/app_snack_bar.dart';
import 'package:workspace/core/components/app_text_field.dart';
import 'package:workspace/features/thesis/auth/service/auth_service.dart';
import 'package:workspace/features/thesis/admin/screen/admin_login_page.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key, this.email});
  final String? email;

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController password2TEC = TextEditingController();
  final TextEditingController passwordTEC = TextEditingController();
  bool isLoading = false;
  bool obscureText1 = true;
  bool obscureText2 = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text(''),
          leading: const BackButton(),
          backgroundColor: AppColors.white,
          surfaceTintColor: AppColors.white,
        ),
        body: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              context.tr('input_your_new_password'),
              style: AppStyles.headerText,
            ),
            const SizedBox(height: 15),
            Text(
              context.tr('input_your_new_password'),
              style: AppStyles.mediumGrey,
            ),
            const SizedBox(height: 35),
            Text(context.tr('password'), style: AppStyles.mediumGrey),
            const SizedBox(height: 12),
            AppTextField(
              controller: passwordTEC,
              hintText: context.tr('password'),
              obscureText: obscureText1,
              maxLine: 1,
              suffixIcon: InkWell(
                onTap: () {
                  setState(() => obscureText1 = !obscureText1);
                },
                child: Icon(
                  !obscureText1
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: AppColors.grey,
                  size: 16,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(context.tr('re_type_password'), style: AppStyles.mediumGrey),
            const SizedBox(height: 12),
            AppTextField(
              controller: password2TEC,
              hintText: context.tr('re_type_password'),
              obscureText: obscureText2,
              maxLine: 1,
              suffixIcon: InkWell(
                onTap: () {
                  setState(() => obscureText2 = !obscureText2);
                },
                child: Icon(
                  !obscureText2
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: AppColors.grey,
                  size: 16,
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.35),
            AppButton(
              isLoading: false,
              text: context.tr('submit'),
              onTap: _verifyInformation,
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  void _verifyInformation() {
    if (passwordTEC.text.isEmpty) {
      AppSnackBar.show(context, 'Please enter a password.');
      return;
    }
    if (passwordTEC.text.characters.length < 8) {
      AppSnackBar.show(
        context,
        'The password field must be at least 8 characters.',
      );
      return;
    }
    if (passwordTEC.text != password2TEC.text) {
      AppSnackBar.show(context, 'Your password does not match.');
      return;
    }

    _changePassword();
  }

  void _changePassword() async {
    setState(() => isLoading = true);
    final result = await AuthService().changePassword(
      email: widget.email,
      password: passwordTEC.text.trim(),
    );
    if (!mounted) return;
    setState(() => isLoading = false);
    result.fold(
      (error) {
        AppSnackBar.show(context, error);
      },
      (data) {
        AppSnackBar.show(context, data);
        AppNavigator.pushAndRemoveUntil(context, const AdminLoginPage());
      },
    );
  }
}
