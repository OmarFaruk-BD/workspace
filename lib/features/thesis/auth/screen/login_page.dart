// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:workspace/core/utils/app_colors.dart';
// import 'package:workspace/core/utils/app_styles.dart';
// import 'package:workspace/core/helper/navigation.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:workspace/core/service/app_validator.dart';
// import 'package:workspace/core/components/app_button.dart';
// import 'package:workspace/core/components/app_snack_bar.dart';
// import 'package:workspace/core/components/app_text_field.dart';
// import 'package:workspace/features/auth/cubit/auth_cubit.dart';
// import 'package:workspace/features/home/screen/landing_page.dart';
// import 'package:workspace/features/auth/service/auth_service.dart';
// import 'package:workspace/features/auth/screen/registration_page.dart';
// import 'package:workspace/features/auth/screen/forget_password_page.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController passwordTEC = TextEditingController();
//   final TextEditingController emailTEC = TextEditingController();
//   bool obscureText = true;
//   bool isLoading = false;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         FocusManager.instance.primaryFocus?.unfocus();
//       },
//       child: Scaffold(
//         body: ListView(
//           padding: const EdgeInsets.all(24),
//           children: [
//             const SizedBox(height: 40),
//             const Text(
//               'Work Sync',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 50,
//                 color: AppColors.green,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 50),
//             Text(context.tr('email_phone'), style: AppStyles.mediumGrey),
//             const SizedBox(height: 12),
//             AppTextField(
//               controller: emailTEC,
//               hintText: context.tr('email_phone'),
//             ),
//             const SizedBox(height: 24),
//             Text(context.tr('password'), style: AppStyles.mediumGrey),
//             const SizedBox(height: 12),
//             AppTextField(
//               controller: passwordTEC,
//               hintText: context.tr('password'),
//               obscureText: obscureText,
//               maxLine: 1,
//               suffixIcon: InkWell(
//                 onTap: () {
//                   setState(() => obscureText = !obscureText);
//                 },
//                 child: Icon(
//                   obscureText
//                       ? Icons.visibility_outlined
//                       : Icons.visibility_off_outlined,
//                   color: AppColors.grey,
//                   size: 18,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 15),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 InkWell(
//                   onTap: () {
//                     AppNavigator.push(context, const ForgetPasswordPage());
//                   },
//                   child: Text(
//                     context.tr('forgot_password'),
//                     style: AppStyles.mediumGrey12,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 30),
//             AppButton(
//               isLoading: isLoading,
//               text: context.tr('sign_in'),
//               onTap: _userLogin,
//             ),
//             const SizedBox(height: 40),
//             AppButton(
//               isLoading: false,
//               text: context.tr('create_account'),
//               onTap: () {
//                 AppNavigator.push(context, const RegistrationPage());
//               },
//             ),
//             const SizedBox(height: 40),
//           ],
//         ),
//       ),
//     );
//   }

//   void _userLogin() async {
//     if (emailTEC.text.isEmpty) {
//       AppSnackBar.show(context, 'Please enter email.');
//       return;
//     }
//     final error = AppValidator().validateEmail(emailTEC.text);
//     if (error != null) {
//       AppSnackBar.show(context, error);
//       return;
//     }
//     if (passwordTEC.text.isEmpty) {
//       AppSnackBar.show(context, 'Please enter password.');
//       return;
//     }
//     setState(() => isLoading = true);
//     final result = await AuthService().login(
//       email: emailTEC.text.trim(),
//       password: passwordTEC.text.trim(),
//     );
//     if (!mounted) return;
//     setState(() => isLoading = false);
//     result.fold(
//       (error) {
//         AppSnackBar.show(context, error);
//       },
//       (data) {
//         context.read<AuthCubit>().updateUser(data.user);
//         AppSnackBar.show(context, 'Login successfully.');
//         AppNavigator.pushAndRemoveUntil(context, const LandingPage());
//       },
//     );
//   }
// }
