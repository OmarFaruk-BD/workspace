import 'package:flutter/material.dart';
import 'package:workspace/core/utils/app_colors.dart';
import 'package:workspace/core/utils/app_styles.dart';
import 'package:workspace/core/helper/navigation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:workspace/core/service/app_validator.dart';
import 'package:workspace/core/components/app_button.dart';
import 'package:workspace/core/components/app_snack_bar.dart';
import 'package:workspace/core/components/app_text_field.dart';
import 'package:workspace/features/thesis/auth/screen/change_password_otp_page.dart';
import 'package:workspace/features/thesis/auth/service/auth_service.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final TextEditingController emailTEC = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text(''),
          leading: const BackButton(),
          backgroundColor: AppColors.white,
        ),
        body: ListView(
          padding: const EdgeInsets.all(15),
          children: [
            Text(
              context.tr('forgot_your_password'),
              style: AppStyles.headerText,
            ),
            const SizedBox(height: 15),
            Text(context.tr('input_your_email'), style: AppStyles.mediumGrey),
            const SizedBox(height: 35),
            Text(context.tr('email'), style: AppStyles.mediumGrey),
            const SizedBox(height: 12),
            AppTextField(controller: emailTEC, hintText: context.tr('email')),
            SizedBox(height: MediaQuery.of(context).size.height * 0.4),
            AppButton(
              text: context.tr('submit'),
              isLoading: isLoading,
              onTap: _verifyData,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  void _verifyData() {
    if (emailTEC.text.isEmpty) {
      AppSnackBar.show(context, 'Please enter email address.');
      return;
    }
    final error = AppValidator().validateEmail(emailTEC.text);
    if (error != null) {
      AppSnackBar.show(context, error);
      return;
    }
    if (!isLoading) {
      _setPassword();
    }
  }

  void _setPassword() async {
    setState(() => isLoading = true);
    final result = await AuthService().resetPassword(emailTEC.text.trim());
    if (!mounted) return;
    setState(() => isLoading = false);
    result.fold((error) => AppSnackBar.show(context, error), (data) {
      AppSnackBar.show(context, data);
      AppNavigator.push(
        context,
        ChangePasswordOTPPage(email: emailTEC.text.trim()),
      );
    });
  }
}
