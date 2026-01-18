import 'package:flutter/material.dart';
import 'package:workspace/core/components/loading_or_empty.dart';
import 'package:workspace/features/thesis/auth/model/user_model.dart';
import 'package:workspace/features/thesis/admin/service/employee_service.dart';

class EmployeePopup extends StatefulWidget {
  const EmployeePopup({super.key, this.onSelected, this.selectedUser});

  final UserModel? selectedUser;
  final Function(UserModel?)? onSelected;

  @override
  State<EmployeePopup> createState() => _EmployeePopupState();
}

class _EmployeePopupState extends State<EmployeePopup> {
  final EmployeeService _employeeService = EmployeeService();
  List<UserModel> employees = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEmployees();
  }

  Future<void> fetchEmployees() async {
    employees = await _employeeService.getAllEmployees('employee');
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(15),
        child: Container(
          padding: const EdgeInsets.all(15),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          child: Column(
            children: [
              const FilterHeader(title: 'Select Employee'),
              const SizedBox(height: 10),
              LoadingOrEmptyText(
                isLoading: isLoading,
                isEmpty: employees.isEmpty,
                emptyText: 'No employees found.',
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ...List.generate(
                        employees.length,
                        (index) => SizedBox(
                          width: double.infinity,
                          child: _PopupItem(
                            employee: employees[index],
                            isSelected: widget.selectedUser == employees[index],
                            onSelected: () {
                              Navigator.pop(context);
                              widget.onSelected?.call(employees[index]);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FilterHeader extends StatelessWidget {
  const FilterHeader({super.key, this.title = 'Select Option'});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(width: 15),
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        InkWell(
          onTap: () => Navigator.pop(context),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text('Close'),
          ),
        ),
      ],
    );
  }
}

class _PopupItem extends StatelessWidget {
  const _PopupItem({
    required this.employee,
    required this.isSelected,
    required this.onSelected,
  });
  final UserModel employee;
  final bool isSelected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: InkWell(
        onTap: onSelected,
        child: Card(
          child: ListTile(
            title: Text(
              employee.name ?? '',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4),
                Row(
                  children: [
                    _buildItem(Icons.business_center, '${employee.position}'),
                    _buildItem(Icons.public_outlined, '${employee.department}'),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    _buildItem(Icons.email_outlined, '${employee.email}'),
                    _buildItem(
                      Icons.phone_android_outlined,
                      '${employee.phone}',
                    ),
                  ],
                ),
                SizedBox(height: 4),
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
          SizedBox(width: 6),
          Expanded(
            child: Text(
              value,
              maxLines: 2,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
