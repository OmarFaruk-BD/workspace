// import 'package:flutter_svg/svg.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:workspace/core/utils/app_images.dart';
// import 'package:workspace/core/utils/app_styles.dart';
// import 'package:workspace/core/utils/app_colors.dart';
// import 'package:workspace/core/helper/navigation.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:workspace/features/auth/cubit/auth_cubit.dart';
// import 'package:workspace/features/auth/screen/login_page.dart';
// import 'package:workspace/features/auth/service/auth_service.dart';
// import 'package:workspace/features/home/screen/landing_page.dart';

// class ApprovalPage extends StatefulWidget {
//   const ApprovalPage({super.key});

//   @override
//   State<ApprovalPage> createState() => _ApprovalPageState();
// }

// class _ApprovalPageState extends State<ApprovalPage> {
//   @override
//   void initState() {
//     super.initState();
//     _naviagteToLanding();
//   }

//   void _naviagteToLanding() async {
//     final result = await AuthService().getUserDetail();
//     await Future.delayed(const Duration(seconds: 1));
//     if (!context.mounted) return;
//     result.fold(
//       (l) => AppNavigator.pushAndRemoveUntil(context, const LoginPage()),
//       (r) async {
//         context.read<AuthCubit>().updateUser(r);
//         AppNavigator.pushAndRemoveUntil(context, const LandingPage());
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: false,
//       child: GestureDetector(
//         onTap: () {
//           FocusManager.instance.primaryFocus?.unfocus();
//         },
//         child: Scaffold(
//           appBar: AppBar(
//             elevation: 0,
//             title: const Text(''),
//             automaticallyImplyLeading: false,
//             backgroundColor: AppColors.white,
//             surfaceTintColor: AppColors.white,
//           ),
//           body: ListView(
//             padding: const EdgeInsets.all(24),
//             children: [
//               const SizedBox(height: 70),
//               SvgPicture.asset(AppImages.successful),
//               const SizedBox(height: 70),
//               Text(
//                 context.tr('your_account_is_pending_approval'),
//                 style: AppStyles.mediumGrey,
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 70),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
