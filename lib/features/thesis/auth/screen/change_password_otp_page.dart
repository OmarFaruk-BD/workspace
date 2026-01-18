import 'package:pinput/pinput.dart';
import 'package:flutter/material.dart';
import 'package:workspace/core/utils/app_styles.dart';
import 'package:workspace/core/utils/app_colors.dart';
import 'package:workspace/core/helper/navigation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:workspace/core/components/app_button.dart';
import 'package:workspace/core/components/app_snack_bar.dart';
import 'package:workspace/features/thesis/auth/service/auth_service.dart';
import 'package:workspace/features/thesis/auth/widget/reset_otp_timer.dart';
import 'package:workspace/features/thesis/auth/screen/change_password_page.dart';

class ChangePasswordOTPPage extends StatefulWidget {
  const ChangePasswordOTPPage({super.key, required this.email});
  final String email;

  @override
  State<ChangePasswordOTPPage> createState() => _ChangePasswordOTPPageState();
}

class _ChangePasswordOTPPageState extends State<ChangePasswordOTPPage> {
  final pinPutController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 75,
      height: 55,
      textStyle: const TextStyle(
        fontSize: 24,
        color: AppColors.black,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grey),
        borderRadius: BorderRadius.circular(16),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColors.grey),
    );

    final submittedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColors.grey),
    );
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
            Text(context.tr('submit_otp'), style: AppStyles.headerText),
            const SizedBox(height: 15),
            Text(
              context.tr('submit_otp_that_has_been_sent_to_your_phone'),
              style: AppStyles.mediumGrey,
            ),
            const SizedBox(height: 40),
            Pinput(
              controller: pinPutController,
              length: 4,
              showCursor: true,
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: focusedPinTheme,
              submittedPinTheme: submittedPinTheme,
              pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
              onCompleted: (pin) {},
            ),
            const SizedBox(height: 15),
            ResetOTPTimer(email: widget.email),
            SizedBox(height: MediaQuery.of(context).size.height * 0.4),
            AppButton(
              isLoading: isLoading,
              text: context.tr('submit'),
              onTap: _verifyData,
            ),
            const SizedBox(height: 30),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  void _verifyData() async {
    if (pinPutController.text.length < 4) {
      AppSnackBar.show(context, 'Please sumbit the OTP');
      return;
    }
    setState(() => isLoading = true);
    final result = await AuthService().validateOTP(
      email: widget.email,
      otpCode: pinPutController.text.trim(),
    );
    if (!mounted) return;
    setState(() => isLoading = false);
    result.fold(
      (error) {
        AppSnackBar.show(context, error);
      },
      (data) {
        AppSnackBar.show(context, data);
        AppNavigator.push(context, ChangePasswordPage(email: widget.email));
      },
    );
  }
}
