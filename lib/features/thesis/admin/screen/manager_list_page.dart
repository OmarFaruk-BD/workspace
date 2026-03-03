import 'package:flutter/material.dart';
import 'package:workspace/core/helper/navigation.dart';
import 'package:workspace/core/components/app_bar.dart';
import 'package:workspace/core/components/app_button.dart';
import 'package:workspace/features/thesis/auth/model/user_model.dart';
import 'package:workspace/features/thesis/admin/screen/manager_detail.dart';
import 'package:workspace/features/thesis/admin/service/employee_service.dart';

class ManagerListPage extends StatefulWidget {
  const ManagerListPage({super.key, this.hasBackButton = true});
  final bool hasBackButton;

  @override
  State<ManagerListPage> createState() => _ManagerListPageState();
}

class _ManagerListPageState extends State<ManagerListPage> {
  final EmployeeService _employeeService = EmployeeService();
  List<UserModel> employees = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEmployees();
  }

  Future<void> fetchEmployees() async {
    employees = await _employeeService.getAllEmployees('admin');
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminAppBar(
        title: 'Manager List',
        hasBackButton: widget.hasBackButton,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: fetchEmployees,
          child: ListView(
            padding: const EdgeInsets.all(25),
            children: [
              if (isLoading)
                const Center(child: CircularProgressIndicator())
              else if (employees.isEmpty)
                const Center(child: Text('No employees found.'))
              else
                ...employees.map((employee) {
                  return ManagerItem(
                    employee: employee,
                    onTap: () {
                      AppNavigator.pushTo(
                        context,
                        ManagerDetailPage(userModel: employee),
                      ).then((_) => fetchEmployees());
                    },
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }
}

class ManagerItem extends StatelessWidget {
  const ManagerItem({super.key, required this.employee, this.onTap});
  final UserModel employee;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: InkWell(
        onTap: onTap,
        child: Card(
          child: ListTile(
            title: Text(
              employee.name ?? '',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Row(
                  children: [
                    _buildItem(Icons.business_center, '${employee.position}'),
                    _buildItem(Icons.public_outlined, '${employee.department}'),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _buildItem(Icons.email_outlined, '${employee.email}'),
                    _buildItem(
                      Icons.phone_android_outlined,
                      '${employee.phone}',
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Center(
                  child: AdminButton(radius: 30, vPadding: 6, text: 'Details'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(IconData key, String value) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(key, size: 18),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              value,
              maxLines: 2,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
