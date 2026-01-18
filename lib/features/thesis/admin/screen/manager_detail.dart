import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:workspace/core/helper/extention.dart';
import 'package:workspace/core/utils/app_colors.dart';
import 'package:workspace/core/utils/app_images.dart';
import 'package:workspace/core/helper/navigation.dart';
import 'package:workspace/core/components/app_bar.dart';
import 'package:workspace/core/components/app_button.dart';
import 'package:workspace/core/components/app_snack_bar.dart';
import 'package:workspace/core/components/approval_popup.dart';
import 'package:workspace/features/thesis/auth/model/user_model.dart';
import 'package:workspace/core/components/app_network_image.dart';
import 'package:workspace/features/thesis/admin/screen/edit_employe.dart';
import 'package:workspace/features/thesis/admin/service/employee_service.dart';

class ManagerDetailPage extends StatefulWidget {
  const ManagerDetailPage({super.key, required this.userModel});
  final UserModel userModel;

  @override
  State<ManagerDetailPage> createState() => _ManagerDetailPageState();
}

class _ManagerDetailPageState extends State<ManagerDetailPage> {
  final EmployeeService _employeeService = EmployeeService();
  bool showPassword = false;
  bool isDeleting = false;
  UserModel? user;

  @override
  void initState() {
    super.initState();
    user = widget.userModel;
    fetchEmployees();
  }

  Future<void> fetchEmployees() async {
    user = await _employeeService.getEmployeeWithImage(user?.id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminAppBar(
        title: 'Manger Profile',
        onBackTap: () => Navigator.pop(context),
      ),
      body: ListView(
        children: [
          Stack(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 50),
                height: MediaQuery.of(context).size.height * 0.18,
                color: AppColors.secondary,
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
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async {
              setState(() => showPassword = !showPassword);
              await Future.delayed(const Duration(seconds: 3));
              setState(() => showPassword = false);
            },
            child: _buildItem(
              'Password',
              showPassword ? user?.password ?? '' : '(tap to see)',
            ),
          ),
          _buildDivider(),
          _buildItem('Role', user?.role.capitalize() ?? 'N/A'),
          _buildDivider(),
          _buildItem('Position', user?.position ?? 'N/A'),
          _buildDivider(),
          _buildItem('Department', user?.department ?? 'N/A'),
          _buildDivider(),
          SizedBox(height: 40),
          Row(
            children: [
              SizedBox(width: 20),
              Expanded(
                child: AdminButton(
                  text: 'Edit Profile',
                  onTap: () {
                    AppNavigator.pushTo(
                      context,
                      EditEmployeePage(user: user, title: 'Manager'),
                    ).then((_) => fetchEmployees());
                  },
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: AdminButton(
                  text: 'Delete Profile',
                  isLoading: isDeleting,
                  onTap: () async {
                    final text =
                        'Are you sure you want to delete this profile?';
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return ApprovalWidget(
                          title: 'Delete Profile!',
                          description: text,
                          onApprove: _deleteEmployee,
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(width: 20),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
        ],
      ),
    );
  }

  void _deleteEmployee() async {
    Navigator.pop(context);
    setState(() => isDeleting = true);
    final result = await _employeeService.deleteEmployee(user);
    setState(() => isDeleting = false);
    result.fold((error) => AppSnackBar.show(context, error), (success) {
      AppSnackBar.show(context, success);
      Navigator.pop(context, true);
    });
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
