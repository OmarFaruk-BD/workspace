import 'package:flutter/material.dart';
import 'package:workspace/core/helper/navigation.dart';
import 'package:workspace/core/components/app_bar.dart';
import 'package:workspace/core/components/app_popup.dart';
import 'package:workspace/core/components/app_button.dart';
import 'package:workspace/core/components/approval_popup.dart';
import 'package:workspace/features/thesis/admin/screen/add_employee.dart';
import 'package:workspace/features/thesis/admin/screen/employe_list.dart';
import 'package:workspace/features/thesis/admin/widget/action_button.dart';
import 'package:workspace/features/thesis/admin/widget/employee_popup.dart';
import 'package:workspace/features/thesis/admin/task/add_employee_task.dart';
import 'package:workspace/features/thesis/admin/task/employee_task_list.dart';
import 'package:workspace/features/thesis/admin/screen/admin_login_page.dart';
import 'package:workspace/features/thesis/admin/screen/manager_list_page.dart';
import 'package:workspace/features/thesis/admin/service/admin_auth_service.dart';
import 'package:workspace/features/thesis/dashboard/visit/e_shop_visit_list.dart';
import 'package:workspace/features/thesis/admin/notification/e_leave_request.dart';
import 'package:workspace/features/thesis/admin/attendance/employee_attendance.dart';
import 'package:workspace/features/thesis/admin/attendance/e_attendance_history.dart';
import 'package:workspace/features/thesis/admin/notification/e_emergency_request.dart';
import 'package:workspace/features/thesis/admin/attendance/employee_location_list.dart';
import 'package:workspace/features/thesis/admin/notification/add_employee_notification.dart';
import 'package:workspace/features/thesis/admin/notification/employee_notification_list.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  final AdminAuthService _service = AdminAuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminAppBar(title: 'Manager Dashboard', hasBackButton: false),
      body: ListView(
        children: [
          SizedBox(height: 20),
          SectionWidget(
            title: 'Employee Related Actions',
            children: [
              ActionButton(
                text: 'Add Employee',
                onTap: () {
                  AppNavigator.push(context, AddEmployeePage());
                },
              ),
              ActionButton(
                text: 'Employee List',
                onTap: () => AppNavigator.push(context, EmployeeListPage()),
              ),
              ActionButton(
                text: 'Manager List',
                onTap: () => AppNavigator.push(context, ManagerListPage()),
              ),
            ],
          ),
          SectionWidget(
            title: 'Task Related Actions',
            children: [
              ActionButton(
                text: 'Assign Task',
                onTap: () async {
                  await AppPopup.showAnimated(
                    child: EmployeePopup(
                      onSelected: (employee) {
                        if (!mounted) return;
                        AppNavigator.push(
                          context,
                          AddEmployeeTaskPage(user: employee),
                        );
                      },
                    ),
                    context: context,
                  );
                },
              ),
              ActionButton(
                text: 'See Assigned Task',
                onTap: () async {
                  await AppPopup.showAnimated(
                    child: EmployeePopup(
                      onSelected: (employee) {
                        if (!mounted) return;
                        AppNavigator.push(
                          context,
                          EmployeeTaskList(user: employee),
                        );
                      },
                    ),
                    context: context,
                  );
                },
              ),
              ActionButton(
                text: 'Shop Visit List',
                onTap: () async {
                  await AppPopup.showAnimated(
                    child: EmployeePopup(
                      onSelected: (employee) {
                        if (!mounted) return;
                        AppNavigator.push(
                          context,
                          EmployeeShopVisitList(user: employee),
                        );
                      },
                    ),
                    context: context,
                  );
                },
              ),
            ],
          ),

          SectionWidget(
            title: 'Attendance and Location Related Actions',
            children: [
              ActionButton(
                text: 'Assign Location',
                onTap: () async {
                  await AppPopup.showAnimated(
                    child: EmployeePopup(
                      onSelected: (employee) {
                        if (!mounted) return;
                        AppNavigator.push(
                          context,
                          AddEmployeeAttendancePage(user: employee),
                        );
                      },
                    ),
                    context: context,
                  );
                },
              ),
              ActionButton(
                text: 'See Assigned Location',
                onTap: () async {
                  await AppPopup.showAnimated(
                    child: EmployeePopup(
                      onSelected: (employee) {
                        if (!mounted) return;
                        AppNavigator.push(
                          context,
                          EmployeeLocationList(user: employee),
                        );
                      },
                    ),
                    context: context,
                  );
                },
              ),
              ActionButton(
                text: 'Attendance History',
                onTap: () async {
                  await AppPopup.showAnimated(
                    child: EmployeePopup(
                      onSelected: (employee) {
                        if (!mounted) return;
                        AppNavigator.push(
                          context,
                          EAttendanceHistory(user: employee),
                        );
                      },
                    ),
                    context: context,
                  );
                },
              ),
            ],
          ),

          SectionWidget(
            title: 'Request Related Actions',
            children: [
              ActionButton(
                text: 'Emergency Request List',
                onTap: () async {
                  await AppPopup.showAnimated(
                    child: EmployeePopup(
                      onSelected: (employee) {
                        if (!mounted) return;
                        AppNavigator.push(
                          context,
                          EEmergencyRequest(user: employee),
                        );
                      },
                    ),
                    context: context,
                  );
                },
              ),
              ActionButton(
                text: 'Leave Request List',
                onTap: () async {
                  await AppPopup.showAnimated(
                    child: EmployeePopup(
                      onSelected: (employee) {
                        if (!mounted) return;
                        AppNavigator.push(
                          context,
                          ELeaveRequest(user: employee),
                        );
                      },
                    ),
                    context: context,
                  );
                },
              ),
              ActionButton(
                text: 'Send Notification',
                onTap: () async {
                  await AppPopup.showAnimated(
                    child: EmployeePopup(
                      onSelected: (employee) {
                        if (!mounted) return;
                        AppNavigator.push(
                          context,
                          AddEmployeeNotificationPage(user: employee),
                        );
                      },
                    ),
                    context: context,
                  );
                },
              ),
              ActionButton(
                text: 'See Notifications',
                onTap: () async {
                  await AppPopup.showAnimated(
                    child: EmployeePopup(
                      onSelected: (employee) {
                        if (!mounted) return;
                        AppNavigator.push(
                          context,
                          EmployeeNotificationList(user: employee),
                        );
                      },
                    ),
                    context: context,
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: AdminButton(text: 'Sign Out', onTap: _signOut),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  void _signOut() async {
    AppPopup.showAnimated(
      context: context,
      child: ApprovalWidget(
        title: 'Sign Out',
        description: 'Are you sure you want to sign out?',
        onApprove: () async {
          await _service.signOut();
          if (!mounted) return;
          AppNavigator.pushAndRemoveUntil(context, const AdminLoginPage());
        },
      ),
    );
  }
}
