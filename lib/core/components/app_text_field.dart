import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:workspace/core/utils/app_colors.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.onTap,
    this.maxLine,
    this.hintText,
    this.labelText,
    this.maxLength,
    this.onChanged,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.radius = 5,
    this.suffixWidget,
    this.textInputType,
    this.enabled = true,
    this.autovalidateMode,
    this.readOnly = false,
    this.autoFocus = false,
    this.obscureText = false,
    required this.controller,
  });

  final int? maxLine;
  final bool enabled;
  final bool readOnly;
  final double radius;
  final int? maxLength;
  final bool autoFocus;
  final bool obscureText;
  final String? hintText;
  final String? labelText;
  final Function()? onTap;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Widget? suffixWidget;
  final Function(String)? onChanged;
  final TextInputType? textInputType;
  final TextEditingController controller;
  final AutovalidateMode? autovalidateMode;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      maxLines: maxLine,
      readOnly: readOnly,
      style: _textStyle(),
      autofocus: autoFocus,
      validator: validator,
      onChanged: onChanged,
      maxLength: maxLength,
      controller: controller,
      obscureText: obscureText,
      keyboardType: textInputType,
      cursorColor: AppColors.black,
      autovalidateMode: autovalidateMode,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        hintMaxLines: 1,
        enabled: enabled,
        hintText: hintText,
        labelText: labelText,
        suffix: suffixWidget,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: _buildBorder(),
        hintStyle: _textStyle(),
        labelStyle: _textStyle(),
        fillColor: AppColors.white,
        enabledBorder: _buildBorder(),
        focusedBorder: _buildBorder(),
        errorStyle: _errorTextStyle(),
        disabledBorder: _buildBorder(),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      ),
    );
  }

  OutlineInputBorder _buildBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide(
        color: enabled
            ? AppColors.grey.withAlpha(100)
            : AppColors.grey.withAlpha(50),
      ),
    );
  }

  TextStyle _textStyle() {
    return TextStyle(color: enabled ? AppColors.black : AppColors.grey);
  }

  TextStyle _errorTextStyle() {
    return const TextStyle(
      fontSize: 14,
      color: AppColors.red,
      fontWeight: FontWeight.w600,
    );
  }
}

class TextFieldIcon extends StatelessWidget {
  const TextFieldIcon({super.key, this.onTap, this.image, this.icon});
  final VoidCallback? onTap;
  final String? image;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 18,
        height: 18,
        child: Center(
          child: image != null
              ? SvgPicture.asset(image!, width: 18, height: 18)
              : icon != null
              ? Icon(icon, size: 18, color: AppColors.grey)
              : const SizedBox(),
        ),
      ),
    );
  }
}
