import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workspace/core/components/app_bar.dart';
import 'package:workspace/features/thesis/auth/cubit/auth_cubit.dart';
import 'package:workspace/features/thesis/auth/model/user_model.dart';
import 'package:workspace/core/components/loading_or_empty.dart';
import 'package:workspace/features/thesis/dashboard/model/task_model.dart';
import 'package:workspace/features/thesis/dashboard/widget/my_task_item.dart';
import 'package:workspace/features/thesis/admin/service/employee_task_service.dart';

class MyTaskList extends StatefulWidget {
  const MyTaskList({super.key, this.user});
  final UserModel? user;

  @override
  State<MyTaskList> createState() => _MyTaskListState();
}

class _MyTaskListState extends State<MyTaskList> {
  final EmployeeTaskService _taskService = EmployeeTaskService();
  List<TaskModel> _tasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEmployeeTask();
  }

  Future<void> fetchEmployeeTask() async {
    _tasks = await _taskService.getTasksByEmployeeV2(widget.user?.id ?? '');
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'My Task List'),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: fetchEmployeeTask,
          child: ListView(
            padding: EdgeInsets.all(15),
            children: [
              LoadingOrEmptyText(
                isLoading: _isLoading,
                isEmpty: _tasks.isEmpty,
                emptyText: 'No tasks found.',
              ),
              if (_tasks.isNotEmpty)
                ..._tasks.map((item) {
                  return MyTaskItem(task: item, onBack: fetchEmployeeTask);
                }),
            ],
          ),
        ),
      ),
    );
  }
}

class MyTaskListV2 extends StatefulWidget {
  const MyTaskListV2({super.key});

  @override
  State<MyTaskListV2> createState() => _MyTaskListV2State();
}

class _MyTaskListV2State extends State<MyTaskListV2> {
  final EmployeeTaskService _taskService = EmployeeTaskService();
  List<TaskModel> _tasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEmployeeTask();
  }

  Future<void> fetchEmployeeTask() async {
    final authState = context.read<AuthCubit>().state;
    _tasks = await _taskService.getTasksByEmployeeV2(authState.user?.id ?? '');
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'My Task List', hasBackButton: false),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: fetchEmployeeTask,
          child: ListView(
            padding: EdgeInsets.all(15),
            children: [
              LoadingOrEmptyText(
                isLoading: _isLoading,
                isEmpty: _tasks.isEmpty,
                emptyText: 'No tasks found.',
              ),
              if (_tasks.isNotEmpty)
                ..._tasks.map((item) {
                  return MyTaskItem(task: item, onBack: fetchEmployeeTask);
                }),
            ],
          ),
        ),
      ),
    );
  }
}
