import 'package:flutter/material.dart';
import 'package:workspace/core/utils/app_colors.dart';
import 'package:workspace/features/thesis/admin/landing/admin_home.dart';
import 'package:workspace/features/thesis/admin/screen/employe_list.dart';
import 'package:workspace/features/thesis/admin/landing/admin_message.dart';
import 'package:workspace/features/thesis/admin/landing/admin_dashboard.dart';

class AdminLandingPage extends StatefulWidget {
  const AdminLandingPage({super.key, this.index});
  final int? index;

  @override
  State<AdminLandingPage> createState() => _AdminLandingPageState();
}

class _AdminLandingPageState extends State<AdminLandingPage> {
  int _index = 0;

  static const List<Widget> _screens = <Widget>[
    AdminHomePage(),
    EmployeeListPage(hasBackButton: false),
    AdminMessagePage(),
    AdminDashboardPage(),
  ];

  @override
  void initState() {
    super.initState();
    _index = widget.index ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(15).copyWith(top: 0),
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildBottomNavBar2(
                  label: 'Home',
                  icon: Icons.analytics,
                  isSelected: _index == 0,
                  onTap: () => setState(() => _index = 0),
                ),
                _buildBottomNavBar2(
                  label: 'Employee',
                  icon: Icons.group,
                  isSelected: _index == 1,
                  onTap: () => setState(() => _index = 1),
                ),
                _buildBottomNavBar2(
                  label: 'Message',
                  icon: Icons.message,
                  isSelected: _index == 2,
                  onTap: () => setState(() => _index = 2),
                ),
                _buildBottomNavBar2(
                  label: 'Dashboard',
                  icon: Icons.dashboard,
                  isSelected: _index == 3,
                  onTap: () => setState(() => _index = 3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavBar2({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isSelected ? AppColors.primary : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(icon, size: isSelected ? 15 : 18, color: AppColors.white),
            if (isSelected) const SizedBox(width: 8),
            if (isSelected)
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
