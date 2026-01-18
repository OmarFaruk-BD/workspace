import 'package:flutter/material.dart';
import 'package:workspace/core/helper/navigation.dart';
import 'package:workspace/core/components/app_button.dart';
import 'package:workspace/features/thesis/dashboard/model/task_model.dart';
import 'package:workspace/features/thesis/dashboard/screen/my_task_detail.dart';

class MyTaskItem extends StatelessWidget {
  const MyTaskItem({super.key, required this.task, required this.onBack});
  final TaskModel task;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 22),
      child: InkWell(
        onTap: () {
          AppNavigator.pushTo(
            context,
            MyTaskDetail(task: task),
          ).then((_) => onBack?.call());
        },
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 8,
                offset: const Offset(0, 1),
              ),
            ],
          ),
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
                  task.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(child: Text('Priority: ${task.priority}')),
                    Expanded(child: Text('Type: ${task.taskType}')),
                  ],
                ),

                SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(child: Text('Schedule: ${task.comments}')),
                    Expanded(child: Text('Status: ${task.status}')),
                  ],
                ),
                SizedBox(height: 10),
                Center(
                  child: AppButton(
                    radius: 50,
                    vPadding: 6,
                    hPadding: 25,
                    text: 'Details',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
