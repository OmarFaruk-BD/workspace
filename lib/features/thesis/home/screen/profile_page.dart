import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workspace/core/utils/app_colors.dart';
import 'package:workspace/core/utils/app_images.dart';
import 'package:workspace/core/helper/extention.dart';
import 'package:workspace/core/helper/navigation.dart';
import 'package:workspace/core/components/app_bar.dart';
import 'package:workspace/core/components/app_popup.dart';
import 'package:workspace/core/components/app_button.dart';
import 'package:workspace/features/thesis/auth/cubit/auth_cubit.dart';
import 'package:workspace/features/thesis/auth/model/user_model.dart';
import 'package:workspace/core/components/approval_popup.dart';
import 'package:workspace/core/components/app_network_image.dart';
import 'package:workspace/features/thesis/admin/screen/edit_employe.dart';
import 'package:workspace/features/thesis/auth/service/auth_service.dart';
import 'package:workspace/features/thesis/admin/screen/admin_login_page.dart';
import 'package:workspace/features/thesis/admin/service/employee_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.user});
  final UserModel? user;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final EmployeeService _employeeService = EmployeeService();
  bool showPassword = false;
  bool isDeleting = false;
  UserModel? user;

  @override
  void initState() {
    super.initState();
    user = widget.user;
    fetchEmployees();
  }

  Future<void> fetchEmployees() async {
    user = await _employeeService.getEmployeeWithImage(user?.id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Profile',
        onBackTap: () => Navigator.pop(context),
      ),
      body: ListView(
        children: [
          Stack(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 50),
                height: MediaQuery.of(context).size.height * 0.18,
                color: AppColors.primary,
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Center(
                  child: Container(
                    width: 150,
                    height: 150,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(150),
                    ),
                    child: user?.imageUrl != null
                        ? CircleAvatar(
                            radius: 40,
                            backgroundImage: MemoryImage(
                              base64Decode(user?.imageUrl ?? ''),
                            ),
                          )
                        : AppCachedImage(AppImages.demoAvaterURL, radius: 100),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Center(
            child: Text(
              user?.name ?? '',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
          Center(child: Text(user?.position ?? 'N/A')),
          SizedBox(height: 20),
          _buildItem('Name', user?.name ?? 'N/A'),
          _buildDivider(),
          _buildItem('Email', user?.email ?? 'N/A'),
          _buildDivider(),
          _buildItem('Phone', user?.phone ?? 'N/A'),
          _buildDivider(),
          InkWell(
            onTap: () async {
              setState(() => showPassword = !showPassword);
              await Future.delayed(const Duration(seconds: 3));
              setState(() => showPassword = false);
            },
            child: _buildItem(
              'Password',
              showPassword ? user?.password ?? '' : '*********',
            ),
          ),
          _buildDivider(),
          _buildItem('Role', user?.role.capitalize() ?? 'N/A'),
          _buildDivider(),
          _buildItem('Position', user?.position ?? 'N/A'),
          _buildDivider(),
          _buildItem('Department', user?.department ?? 'N/A'),
          _buildDivider(),
          Padding(
            padding: const EdgeInsets.all(35).copyWith(bottom: 0),
            child: AppButton(
              text: 'Edit Profile',
              onTap: () {
                AppNavigator.pushTo(
                  context,
                  EditEmployeePage(user: user),
                ).then((_) => fetchEmployees());
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(35),
            child: AppButton(
              text: 'Sign Out',
              onTap: () {
                AppPopup.showAnimated(
                  context: context,
                  child: ApprovalWidget(
                    onApprove: () => _signOut(context),
                    title: 'Sign Out',
                    description: 'Are you sure you want to sign out?',
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _signOut(BuildContext context) async {
    context.read<AuthCubit>().signOut();
    await AuthService().removeData();
    if (!context.mounted) return;
    AppNavigator.pushAndRemoveUntil(context, const AdminLoginPage());
  }

  Container _buildDivider() {
    return Container(
      height: 1,
      width: double.maxFinite,
      color: AppColors.grey,
      margin: EdgeInsets.symmetric(horizontal: 40),
    );
  }

  Padding _buildItem(String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(key, style: TextStyle(color: AppColors.grey)),
          Text(value, style: TextStyle(color: AppColors.grey)),
        ],
      ),
    );
  }
}
