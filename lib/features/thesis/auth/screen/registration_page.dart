// import 'package:flutter/material.dart';
// import 'package:workspace/core/utils/app_styles.dart';
// import 'package:workspace/core/helper/navigation.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:workspace/core/service/app_validator.dart';
// import 'package:workspace/core/components/app_button.dart';
// import 'package:workspace/core/components/app_snack_bar.dart';
// import 'package:workspace/core/components/app_text_field.dart';
// import 'package:workspace/features/auth/screen/pssword_page.dart';

// class RegistrationPage extends StatefulWidget {
//   const RegistrationPage({super.key});

//   @override
//   State<RegistrationPage> createState() => _RegistrationPageState();
// }

// class _RegistrationPageState extends State<RegistrationPage> {
//   final TextEditingController firstNameTEC = TextEditingController();
//   final TextEditingController lastNameTEC = TextEditingController();
//   final TextEditingController emailTEC = TextEditingController();
//   final TextEditingController phoneTEC = TextEditingController();
//   bool isChecked = false;
//   bool isLoading = false;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         FocusManager.instance.primaryFocus?.unfocus();
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           elevation: 0,
//           title: const Text(''),
//           leading: const BackButton(),
//         ),
//         body: ListView(
//           padding: const EdgeInsets.all(24),
//           children: [
//             Text(context.tr('create_new_account'), style: AppStyles.headerText),
//             const SizedBox(height: 15),
//             Text(context.tr('input_your_ame'), style: AppStyles.mediumGrey),
//             const SizedBox(height: 35),
//             Text(context.tr('first_name'), style: AppStyles.mediumGrey),
//             const SizedBox(height: 12),
//             AppTextField(
//               controller: firstNameTEC,
//               hintText: context.tr('first_name'),
//             ),
//             const SizedBox(height: 20),
//             Text(context.tr('last_name'), style: AppStyles.mediumGrey),
//             const SizedBox(height: 12),
//             AppTextField(
//               controller: lastNameTEC,
//               hintText: context.tr('last_name'),
//             ),
//             const SizedBox(height: 20),
//             Text(context.tr('email'), style: AppStyles.mediumGrey),
//             const SizedBox(height: 12),
//             AppTextField(controller: emailTEC, hintText: context.tr('email')),
//             const SizedBox(height: 20),
//             Text(context.tr('mobile_no'), style: AppStyles.mediumGrey),
//             const SizedBox(height: 12),
//             AppTextField(
//               controller: phoneTEC,
//               hintText: context.tr('mobile_no'),
//               textInputType: TextInputType.phone,
//             ),
//             const SizedBox(height: 30),
//             _buildCheckBox(context),
//             const SizedBox(height: 40),
//             AppButton(
//               isLoading: false,
//               text: context.tr('submit'),
//               onTap: _verifyInformation,
//             ),
//             const SizedBox(height: 50),
//           ],
//         ),
//       ),
//     );
//   }

//   Row _buildCheckBox(BuildContext context) {
//     return Row(
//       children: [
//         // AppCheckBox(
//         //   isChecked: isChecked,
//         //   onTap: () => setState(() => isChecked = !isChecked),
//         // ),
//         InkWell(
//           onTap: () => setState(() => isChecked = !isChecked),
//           child: Text(
//             context.tr('i_agree_with_terms_condition'),
//             style: AppStyles.mediumGrey12,
//           ),
//         ),
//       ],
//     );
//   }

//   void _verifyInformation() {
//     if (firstNameTEC.text.isEmpty) {
//       AppSnackBar.show(context, 'Please enter name.');
//       return;
//     }
//     if (lastNameTEC.text.isEmpty) {
//       AppSnackBar.show(context, 'Please enter name.');
//       return;
//     }
//     if (phoneTEC.text.isEmpty) {
//       AppSnackBar.show(context, 'Please enter a phone number.');
//       return;
//     }
//     if (emailTEC.text.isEmpty) {
//       AppSnackBar.show(context, 'Please enter a confirm password.');
//       return;
//     }
//     final error = AppValidator().validateEmail(emailTEC.text);
//     if (error != null) {
//       AppSnackBar.show(context, error);
//       return;
//     }
//     if (!isChecked) {
//       AppSnackBar.show(context, 'Please accept terms and conditions.');
//       return;
//     }
//     Map<String, dynamic> payload = {
//       'first_name': firstNameTEC.text,
//       'last_name': lastNameTEC.text,
//       'email': emailTEC.text,
//       'phone': phoneTEC.text,
//     };
//     AppNavigator.push(context, PasswordPage(payload: payload));
//   }
// }
