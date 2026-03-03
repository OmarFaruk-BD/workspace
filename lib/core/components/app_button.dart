import 'package:flutter/material.dart';
import 'package:workspace/core/utils/app_colors.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    this.onTap,
    this.width,
    this.gradient,
    this.prefixIcon,
    this.suffixIcon,
    this.radius = 5,
    this.borderColor,
    required this.text,
    this.hPadding = 15,
    this.vPadding = 15,
    this.textSize = 15,
    this.isLoading = false,
    this.fontWeight = FontWeight.w700,
    this.textColor = AppColors.white,
    this.buttonColor = AppColors.primary,
  });

  final String text;
  final double? width;
  final double radius;
  final bool isLoading;
  final double textSize;
  final double hPadding;
  final double vPadding;
  final Color textColor;
  final Color buttonColor;
  final Color? borderColor;
  final Gradient? gradient;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        width: width,
        padding: EdgeInsets.symmetric(vertical: vPadding, horizontal: hPadding),
        decoration: BoxDecoration(
          color: buttonColor,
          gradient: gradient,
          borderRadius: BorderRadius.circular(radius),
          border: gradient == null
              ? Border.all(color: borderColor ?? buttonColor)
              : null,
        ),
        child: isLoading
            ? SizedBox(
                width: text.length * 8,
                child: Center(
                  child: SizedBox(
                    width: textSize * 1.42,
                    height: textSize * 1.42,
                    child: CircularProgressIndicator(color: textColor),
                  ),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (prefixIcon != null) ...[
                    prefixIcon!,
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: textColor,
                      fontSize: textSize,
                      fontWeight: fontWeight,
                    ),
                  ),
                  if (suffixIcon != null) ...[
                    const SizedBox(width: 8),
                    suffixIcon!,
                  ],
                ],
              ),
      ),
    );
  }
}

class AppButtonSmall extends AppButton {
  const AppButtonSmall({
    super.key,
    super.onTap,
    super.width,
    super.textColor,
    super.isLoading,
    super.prefixIcon,
    super.suffixIcon,
    super.radius = 30,
    super.buttonColor,
    super.borderColor,
    super.vPadding = 4,
    required super.text,
    super.textSize = 12,
    super.hPadding = 12,
    super.fontWeight = FontWeight.w500,
  });
}

class AppButtonDisabled extends AppButton {
  const AppButtonDisabled({
    super.key,
    super.onTap,
    super.width,
    super.prefixIcon,
    super.suffixIcon,
    super.radius = 15,
    required super.text,
    super.textSize = 15,
    super.hPadding = 15,
    super.vPadding = 16,
    super.isLoading = false,
    super.fontWeight = FontWeight.w700,
    super.textColor = AppColors.grey,
    super.borderColor = AppColors.grey,
    super.buttonColor = AppColors.white,
  });
}
