import 'package:flutter/material.dart';
import 'package:workspace/core/components/app_bar.dart';
import 'package:workspace/features/thesis/auth/model/user_model.dart';
import 'package:workspace/features/thesis/admin/service/employee_task_service.dart';

class EmployeeAttendaceList extends StatefulWidget {
  const EmployeeAttendaceList({super.key, this.user});
  final UserModel? user;

  @override
  State<EmployeeAttendaceList> createState() => _EmployeeAttendaceListState();
}

class _EmployeeAttendaceListState extends State<EmployeeAttendaceList> {
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
      appBar: const AdminAppBar(title: 'Employee List'),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: fetchEmployeeTask,
          child: ListView(
            padding: const EdgeInsets.all(25),
            children: [
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_tasks.isEmpty)
                const Center(child: Text('No tasks found.'))
              else
                ..._tasks.map((item) {
                  return TaskItem(task: item);
                }),
            ],
          ),
        ),
      ),
    );
  }
}

class TaskItem extends StatelessWidget {
  const TaskItem({super.key, required this.task});
  final Map<String, dynamic> task;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        title: Text(
          task['title'] ?? '',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                _buildItem(Icons.business_center, '${task['title']}'),
                _buildItem(Icons.public_outlined, '${task['title']}'),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                _buildItem(Icons.email_outlined, '${task['title']}'),
                _buildItem(Icons.phone_android_outlined, '${task['title']}'),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: () {}, child: const Text('Add Task')),
                ElevatedButton(onPressed: () {}, child: const Text('Live Location')),
              ],
            ),
          ],
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
          Text(
            value,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
