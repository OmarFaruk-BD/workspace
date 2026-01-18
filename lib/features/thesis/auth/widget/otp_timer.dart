import 'package:flutter/material.dart';
import 'package:workspace/core/utils/app_colors.dart';
import 'package:workspace/core/utils/app_styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:workspace/core/components/app_snack_bar.dart';
import 'package:workspace/features/thesis/auth/service/auth_service.dart';

class OTPCountDownTimer extends StatefulWidget {
  const OTPCountDownTimer({super.key});

  @override
  State<StatefulWidget> createState() => _OTPCountDownTimerState();
}

class _OTPCountDownTimerState extends State<OTPCountDownTimer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isResendOTP = false;
  bool isTimerEnd = false;
  int counterTime = 30;

  @override
  void initState() {
    super.initState();
    initiateAnimation();
    checkTimer();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void initiateAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: counterTime),
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          isTimerEnd = true;
        });
      }
    });
    _controller.forward();
  }

  void resetAnimation() {
    _controller.reset();
    _controller.forward();
  }

  void checkTimer() async {
    await Future.delayed(Duration(seconds: counterTime)).then((value) {
      if (mounted) setState(() => isTimerEnd = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child:
          isTimerEnd
              ? _resendOTPButton()
              : Countdown(
                animation: StepTween(
                  begin: counterTime,
                  end: 0,
                ).animate(_controller),
              ),
    );
  }

  Widget _resendOTPButton() {
    return isResendOTP
        ? const Center(child: CircularProgressIndicator(color: AppColors.green))
        : Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              context.tr('dont_receive_code'),
              style: AppStyles.mediumGrey12,
            ),
            const SizedBox(width: 10),
            InkWell(
              onTap: _reSendOTP,
              child: Text(context.tr('resend'), style: AppStyles.mediumGrey12),
            ),
          ],
        );
  }

  Future<void> _reSendOTP() async {
    setState(() => isResendOTP = true);
    final result = await AuthService().resendOTP();
    if (!mounted) return;
    result.fold(
      (l) => AppSnackBar.show(context, l),
      (r) => AppSnackBar.show(context, r),
    );
    if (!mounted) return;
    setState(() {
      isResendOTP = false;
      isTimerEnd = false;
    });
    resetAnimation();
    checkTimer();
  }
}

class Countdown extends AnimatedWidget {
  const Countdown({super.key, required this.animation})
    : super(listenable: animation);
  final Animation<int> animation;
  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);
    String timerText =
        '${clockTimer.inMinutes.remainder(60).toString()}:${(clockTimer.inSeconds.remainder(60) % 60).toString().padLeft(2, '0')}';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(context.tr('expires_in'), style: AppStyles.mediumGrey12),
        Text(timerText, style: AppStyles.mediumGrey12),
      ],
    );
  }
}
