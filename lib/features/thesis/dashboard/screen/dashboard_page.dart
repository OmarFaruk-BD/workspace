import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workspace/core/utils/app_colors.dart';
import 'package:workspace/core/utils/app_images.dart';
import 'package:workspace/core/helper/navigation.dart';
import 'package:workspace/features/thesis/home/widget/header.dart';
import 'package:workspace/features/thesis/auth/cubit/auth_cubit.dart';
import 'package:workspace/features/thesis/home/screen/notification.dart';
import 'package:workspace/features/thesis/dashboard/screen/my_task_list.dart';
import 'package:workspace/features/thesis/dashboard/visit/my_shop_visit.dart';
import 'package:workspace/features/thesis/dashboard/screen/assigned_area.dart';
import 'package:workspace/features/thesis/dashboard/screen/my_leave_request.dart';
import 'package:workspace/features/thesis/history/screen/attendance_history.dart';
import 'package:workspace/features/thesis/dashboard/visit/create_shop_visit.dart';
import 'package:workspace/features/thesis/dashboard/screen/create_leave_request.dart';
import 'package:workspace/features/thesis/dashboard/screen/my_emergency_request.dart';
import 'package:workspace/features/thesis/dashboard/screen/create_emergency_request.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Scaffold(
          body: ListView(
            padding: const EdgeInsets.all(0),
            children: [
              HeaderWidgetV2(),
              Padding(
                padding: const EdgeInsets.all(25).copyWith(bottom: 0),
                child: Row(
                  children: [
                    DashboardItem(
                      text: 'Tasks\nOverview',
                      icon: AppImages.overview,
                      onTap: () => AppNavigator.push(
                        context,
                        MyTaskList(user: state.user),
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                    DashboardItem(
                      text: 'Attendance\nHistory',
                      icon: AppImages.overview_2,
                      onTap: () =>
                          AppNavigator.push(context, AttendanceHistoryPage()),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(25).copyWith(bottom: 0),
                child: Row(
                  children: [
                    DashboardItem(
                      text: 'Emergency\nRequest',
                      icon: AppImages.overview_2,
                      onTap: () => AppNavigator.push(
                        context,
                        CreateEmergencyRequest(user: state.user),
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                    DashboardItem(
                      text: 'My Emergency\nRequest',
                      icon: AppImages.overview_2,
                      onTap: () => AppNavigator.push(
                        context,
                        MyEmergencyRequest(user: state.user),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(25).copyWith(bottom: 0),
                child: Row(
                  children: [
                    DashboardItem(
                      text: 'Assigned\nArea',
                      icon: AppImages.overview_2,
                      onTap: () => AppNavigator.push(
                        context,
                        MyAssignedArea(user: state.user),
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                    DashboardItem(
                      text: 'My\nNotification',
                      icon: AppImages.overview_2,
                      onTap: () =>
                          AppNavigator.push(context, NotificationPage()),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(25).copyWith(bottom: 0),
                child: Row(
                  children: [
                    DashboardItem(
                      text: 'Create\nLeave Request',
                      icon: AppImages.overview_2,
                      onTap: () => AppNavigator.push(
                        context,
                        CreateLeaveRequest(user: state.user),
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                    DashboardItem(
                      text: 'My Leave\nRequest',
                      icon: AppImages.overview_2,
                      onTap: () => AppNavigator.push(
                        context,
                        MyLeaveRequest(user: state.user),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(25).copyWith(bottom: 0),
                child: Row(
                  children: [
                    DashboardItem(
                      text: 'Create\nShop Visit',
                      icon: AppImages.overview_2,
                      onTap: () => AppNavigator.push(
                        context,
                        CreateShopVisit(user: state.user),
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                    DashboardItem(
                      text: 'My Shop\nVisit List',
                      icon: AppImages.overview_2,
                      onTap: () => AppNavigator.push(
                        context,
                        MyShopVisitPage(user: state.user),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        );
      },
    );
  }
}

class DashboardItem extends StatelessWidget {
  const DashboardItem({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
  });
  final String text;
  final String icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.only(bottom: 4),
          decoration: BoxDecoration(
            color: AppColors.grey.withAlpha(150),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.red.withAlpha(100)),
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFF2F2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SvgPicture.asset(icon),
                ),
                SizedBox(height: 12),
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
