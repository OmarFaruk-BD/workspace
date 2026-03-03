import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:workspace/core/utils/app_colors.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.onTap,
    this.maxLine,
    this.hintText,
    this.onChanged,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.radius = 16,
    this.textInputType,
    this.enabled = true,
    this.readOnly = false,
    this.obscureText = false,
    required this.controller,
  });

  final int? maxLine;
  final bool enabled;
  final bool readOnly;
  final double radius;
  final bool obscureText;
  final String? hintText;
  final Function()? onTap;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Function(String)? onChanged;
  final TextInputType? textInputType;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      maxLines: maxLine,
      readOnly: readOnly,
      style: _textStyle(),
      validator: validator,
      onChanged: onChanged,
      controller: controller,
      obscureText: obscureText,
      keyboardType: textInputType,
      cursorColor: AppColors.black,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        isDense: true,
        hintMaxLines: 1,
        enabled: enabled,
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: _buildBorder(),
        labelStyle: _textStyle(),
        hintStyle: _hintTextStyle(),
        enabledBorder: _buildBorder(),
        focusedBorder: _buildBorder(),
        errorStyle: _errorTextStyle(),
        disabledBorder: _buildBorder(),
        contentPadding: const EdgeInsets.fromLTRB(0, 15, 18, 15),
        prefix: prefixIcon == null
            ? const Padding(padding: EdgeInsets.only(left: 20))
            : null,
      ),
    );
  }

  OutlineInputBorder _buildBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide(color: AppColors.black.withAlpha(50)),
    );
  }

  TextStyle _textStyle() {
    return TextStyle(color: enabled ? AppColors.black : AppColors.grey);
  }

  TextStyle _hintTextStyle() => const TextStyle(color: AppColors.black);

  TextStyle _errorTextStyle() {
    return const TextStyle(
      fontSize: 12,
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
