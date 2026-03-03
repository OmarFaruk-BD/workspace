import 'package:flutter/material.dart';
import 'package:workspace/core/helper/extention.dart';
import 'package:workspace/core/components/app_bar.dart';
import 'package:workspace/core/components/app_popup.dart';
import 'package:workspace/core/components/app_button.dart';
import 'package:workspace/core/service/app_validator.dart';
import 'package:workspace/core/components/app_snack_bar.dart';
import 'package:workspace/core/components/app_text_field.dart';
import 'package:workspace/features/thesis/auth/model/user_model.dart';
import 'package:workspace/core/components/item_selection_popup.dart';
import 'package:workspace/features/thesis/admin/service/employee_task_service.dart';

class AddEmployeeTaskPage extends StatefulWidget {
  const AddEmployeeTaskPage({super.key, this.user});
  final UserModel? user;

  @override
  State<AddEmployeeTaskPage> createState() => _AddEmployeeTaskPageState();
}

class _AddEmployeeTaskPageState extends State<AddEmployeeTaskPage> {
  final EmployeeTaskService _taskService = EmployeeTaskService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AppValidator _validator = AppValidator();
  final _description = TextEditingController();
  final _client = TextEditingController();
  final _amount = TextEditingController();
  final _title = TextEditingController();
  DateTime _dueDate = DateTime.now();
  final String _status = 'Pending';
  final String _attachments = '';
  String _taskType = 'Sales';
  String _dayType = 'Daily';
  String _priority = 'Low';
  String _assignedTo = '';
  bool _isLoading = false;

  final List<String> _taskTypeList = ['Sales', 'Support', 'Marketing'];
  final List<String> _dayTypeList = ['Daily', 'Weekly', 'Monthly'];
  final List<String> _priorityList = ['Low', 'Medium', 'High'];

  @override
  void initState() {
    super.initState();
    _assignedTo = widget.user?.id ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: const AdminAppBar(title: 'Add Employee Task'),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Task Title'),
                const SizedBox(height: 8),
                AppTextField(
                  controller: _title,
                  hintText: 'Enter task title',
                  validator: _validator.validate,
                ),
                const SizedBox(height: 20),
                const Text('Task Description'),
                const SizedBox(height: 8),
                AppTextField(
                  controller: _description,
                  hintText: 'Enter task description',
                  validator: _validator.validate,
                ),
                const SizedBox(height: 20),
                const Text('Client Name (Optional)'),
                const SizedBox(height: 8),
                AppTextField(
                  controller: _client,
                  hintText: 'Enter client name',
                ),
                const SizedBox(height: 20),
                const Text('Target Amount (Optional)'),
                const SizedBox(height: 8),
                AppTextField(
                  controller: _amount,
                  hintText: 'Enter target amount',
                  textInputType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                const Text('Due Date'),
                const SizedBox(height: 8),
                AppTextField(
                  readOnly: true,
                  controller: TextEditingController(
                    text: _dueDate.toDateString(),
                  ),
                  validator: _validator.validate,
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _dueDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      setState(() => _dueDate = date);
                    }
                  },
                ),
                const SizedBox(height: 20),
                const Text('Schedule Type'),
                const SizedBox(height: 8),
                AppTextField(
                  readOnly: true,
                  controller: TextEditingController(text: _dayType),
                  validator: _validator.validate,
                  onTap: () async {
                    await AppPopup.showAnimated(
                      context: context,
                      child: ItemSelectionPopUp(
                        list: _dayTypeList,
                        selectedItem: _dayType,
                        onSelected: (value) =>
                            setState(() => _dayType = value ?? 'Daily'),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                const Text('Task Type'),
                const SizedBox(height: 8),
                AppTextField(
                  readOnly: true,
                  controller: TextEditingController(text: _taskType),
                  validator: _validator.validate,
                  onTap: () async {
                    await AppPopup.showAnimated(
                      context: context,
                      child: ItemSelectionPopUp(
                        list: _taskTypeList,
                        selectedItem: _taskType,
                        onSelected: (value) =>
                            setState(() => _taskType = value ?? 'Sales'),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                const Text('Task Priority'),
                const SizedBox(height: 8),
                AppTextField(
                  readOnly: true,
                  controller: TextEditingController(text: _priority),
                  validator: _validator.validate,
                  onTap: () async {
                    await AppPopup.showAnimated(
                      context: context,
                      child: ItemSelectionPopUp(
                        list: _priorityList,
                        selectedItem: _priority,
                        onSelected: (value) =>
                            setState(() => _priority = value ?? 'Low'),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 30),
                AppButton(
                  text: 'Assign Task',
                  isLoading: _isLoading,
                  width: double.maxFinite,
                  onTap: _createTask,
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _createTask() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final result = await _taskService.createTask(
      status: _status,
      title: _title.text,
      assignedTo: _assignedTo,
      description: _description.text,
      priority: _priority,
      taskType: _taskType,
      client: _client.text,
      amount: _amount.text,
      dueDate: _dueDate.toDateString() ?? '',
      comments: _dayType,
      attachments: _attachments,
    );
    setState(() => _isLoading = false);
    result.fold((error) => AppSnackBar.show(context, error), (data) {
      AppSnackBar.show(context, data);
    });
  }
}
