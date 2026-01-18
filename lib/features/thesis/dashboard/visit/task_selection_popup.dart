import 'package:flutter/material.dart';
import 'package:workspace/core/utils/app_colors.dart';
import 'package:workspace/core/components/loading_or_empty.dart';
import 'package:workspace/features/thesis/dashboard/model/task_model.dart';
import 'package:workspace/features/thesis/admin/service/employee_task_service.dart';

class TaskSelectionPopup extends StatefulWidget {
  const TaskSelectionPopup({
    super.key,
    this.onSelected,
    this.selectedTask,
    required this.userId,
  });
  final String userId;
  final TaskModel? selectedTask;
  final Function(TaskModel?)? onSelected;

  @override
  State<TaskSelectionPopup> createState() => _TaskSelectionPopupState();
}

class _TaskSelectionPopupState extends State<TaskSelectionPopup> {
  final EmployeeTaskService _taskService = EmployeeTaskService();
  List<TaskModel> tasks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    tasks = await _taskService.getTasksByEmployeeV2(widget.userId);
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
                isEmpty: tasks.isEmpty,
                emptyText: 'No employees found.',
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ...List.generate(tasks.length, (index) {
                        final isSelected =
                            widget.selectedTask?.taskId == tasks[index].taskId;
                        return SizedBox(
                          width: double.infinity,
                          child: _PopupItem(
                            task: tasks[index],
                            isSelected: isSelected,
                            onSelected: () {
                              Navigator.pop(context);
                              widget.onSelected?.call(tasks[index]);
                            },
                          ),
                        );
                      }),
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
    required this.task,
    required this.isSelected,
    required this.onSelected,
  });
  final TaskModel task;
  final bool isSelected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: InkWell(
        onTap: onSelected,
        child: Card(
          color: isSelected ? AppColors.primary : AppColors.white,
          child: ListTile(
            title: Text(
              task.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4),
                Text(
                  'Description: ${task.description}',
                  maxLines: 2,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                if (task.client.isNotEmpty)
                  Text(
                    'Client: ${task.client}',
                    maxLines: 2,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                if (task.amount.isNotEmpty)
                  Text(
                    'Amount: ${task.amount}',
                    maxLines: 2,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                SizedBox(height: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
