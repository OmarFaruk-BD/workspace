import 'package:flutter/material.dart';
import 'package:workspace/core/helper/navigation.dart';
import 'package:workspace/core/components/app_button.dart';
import 'package:workspace/features/thesis/admin/task/employee_task_details.dart';

class TaskItem extends StatelessWidget {
  const TaskItem({super.key, required this.task, this.onBack});
  final Map<String, dynamic> task;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 15),
      child: ListTile(
        title: Text(
          task['title'] ?? '',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(
              task['description'] ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Expanded(child: Text('Priority: ${task['priority'] ?? ''}')),
                Expanded(child: Text('Type: ${task['taskType'] ?? ''}')),
              ],
            ),

            SizedBox(height: 4),
            Row(
              children: [
                Expanded(child: Text('Schedule: ${task['comments'] ?? ''}')),
                Expanded(child: Text('Status: ${task['status'] ?? ''}')),
              ],
            ),
            SizedBox(height: 10),
            Center(
              child: AdminButton(
                radius: 50,
                vPadding: 8,
                hPadding: 25,
                text: 'Detail',
                onTap: () {
                  AppNavigator.pushTo(
                    context,
                    EmployeeTaskDetailPage(task: task),
                  ).then((_) => onBack?.call());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
