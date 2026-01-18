import 'package:flutter/material.dart';
import 'package:workspace/core/helper/extention.dart';
import 'package:workspace/core/components/app_bar.dart';
import 'package:workspace/core/components/app_popup.dart';
import 'package:workspace/core/components/app_button.dart';
import 'package:workspace/core/service/app_validator.dart';
import 'package:workspace/core/components/app_snack_bar.dart';
import 'package:workspace/core/components/app_text_field.dart';
import 'package:workspace/core/components/item_selection_popup.dart';
import 'package:workspace/features/thesis/admin/service/employee_task_service.dart';

class EditEmployeeTask extends StatefulWidget {
  const EditEmployeeTask({super.key, required this.task});
  final Map<String, dynamic> task;

  @override
  State<EditEmployeeTask> createState() => _EditEmployeeTaskState();
}

class _EditEmployeeTaskState extends State<EditEmployeeTask> {
  final EmployeeTaskService _taskService = EmployeeTaskService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AppValidator _validator = AppValidator();
  final _description = TextEditingController();
  final _client = TextEditingController();
  final _amount = TextEditingController();
  final _title = TextEditingController();
  DateTime _dueDate = DateTime.now();
  final String _attachments = '';
  String _status = 'Pending';
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
    initDataLoad();
  }

  void initDataLoad() async {
    _assignedTo = widget.task['assignedTo'];
    _status = widget.task['status'];
    _title.text = widget.task['title'];
    _description.text = widget.task['description'];
    _client.text = widget.task['client'];
    _amount.text = widget.task['amount'];
    _taskType = widget.task['taskType'];
    _dayType = widget.task['comments'];
    _priority = widget.task['priority'];
    _dueDate = DateTime.tryParse(widget.task['dueDate']) ?? DateTime.now();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AdminAppBar(title: 'Add Employee Task'),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Task Title'),
                SizedBox(height: 8),
                AppTextField(
                  controller: _title,
                  hintText: 'Enter task title',
                  validator: _validator.validate,
                ),
                SizedBox(height: 20),
                Text('Task Description'),
                SizedBox(height: 8),
                AppTextField(
                  controller: _description,
                  hintText: 'Enter task description',
                  validator: _validator.validate,
                ),
                SizedBox(height: 20),
                Text('Client Name (Optional)'),
                SizedBox(height: 8),
                AppTextField(
                  controller: _client,
                  hintText: 'Enter client name',
                ),
                SizedBox(height: 20),
                Text('Target Amount (Optional)'),
                SizedBox(height: 8),
                AppTextField(
                  controller: _amount,
                  hintText: 'Enter target amount',
                  textInputType: TextInputType.number,
                ),
                SizedBox(height: 20),
                Text('Due Date'),
                SizedBox(height: 8),
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
                SizedBox(height: 20),
                Text('Schedule Type'),
                SizedBox(height: 8),
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
                SizedBox(height: 20),
                Text('Task Type'),
                SizedBox(height: 8),
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
                SizedBox(height: 20),
                Text('Task Priority'),
                SizedBox(height: 8),
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
                SizedBox(height: 30),
                AppButton(
                  text: 'Update Task',
                  isLoading: _isLoading,
                  width: double.maxFinite,
                  onTap: _editTask,
                ),
                SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _editTask() async {
    if (_formKey.currentState?.validate() != true) return;
    setState(() => _isLoading = true);
    final result = await _taskService.editTask(
      taskId: widget.task['taskId'],
      updatedFields: {
        'status': _status,
        'title': _title.text,
        'assignedTo': _assignedTo,
        'description': _description.text,
        'priority': _priority,
        'taskType': _taskType,
        'client': _client.text,
        'amount': _amount.text,
        'dueDate': _dueDate.toDateString() ?? '',
        'comments': _dayType,
        'attachments': _attachments,
      },
    );
    setState(() => _isLoading = false);
    result.fold((error) => AppSnackBar.show(context, error), (data) {
      Navigator.pop(context);
      AppSnackBar.show(context, data);
    });
  }
}
