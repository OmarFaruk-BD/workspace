import 'package:flutter/material.dart';
import 'package:workspace/core/components/app_bar.dart';
import 'package:workspace/features/thesis/admin/widget/task_item.dart';
import 'package:workspace/features/thesis/auth/model/user_model.dart';
import 'package:workspace/features/thesis/admin/service/employee_task_service.dart';

class EmployeeTaskList extends StatefulWidget {
  const EmployeeTaskList({super.key, this.user});
  final UserModel? user;

  @override
  State<EmployeeTaskList> createState() => _EmployeeTaskListState();
}

class _EmployeeTaskListState extends State<EmployeeTaskList> {
  final EmployeeTaskService _taskService = EmployeeTaskService();
  List<Map<String, dynamic>> _tasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEmployeeTask();
  }

  Future<void> fetchEmployeeTask() async {
    _tasks = await _taskService.getTasksByEmployee(widget.user?.id ?? '');
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminAppBar(title: 'Task List'),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: fetchEmployeeTask,
          child: ListView(
            padding: EdgeInsets.all(25),
            children: [
              if (_isLoading)
                Center(child: CircularProgressIndicator())
              else if (_tasks.isEmpty)
                Center(child: Text('No tasks found.'))
              else
                ..._tasks.map((item) {
                  return TaskItem(task: item, onBack: fetchEmployeeTask);
                }),
            ],
          ),
        ),
      ),
    );
  }
}
