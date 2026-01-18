import 'package:flutter/material.dart';
import 'package:workspace/core/utils/app_colors.dart';
import 'package:workspace/core/components/app_bar.dart';
import 'package:workspace/core/components/app_network_image.dart';
import 'package:workspace/features/thesis/home/model/notification_model.dart';

class EmployeeNotificationDetail extends StatefulWidget {
  const EmployeeNotificationDetail({super.key, required this.model});
  final NotificationModel model;

  @override
  State<EmployeeNotificationDetail> createState() =>
      _EmployeeNotificationDetailState();
}

class _EmployeeNotificationDetailState
    extends State<EmployeeNotificationDetail> {
  late NotificationModel model;
  @override
  void initState() {
    super.initState();
    model = widget.model;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminAppBar(
        title: 'Notifications',
        onBackTap: () => Navigator.pop(context),
      ),
      body: ListView(
        padding: EdgeInsets.all(24),
        children: [
          Text(
            'Notification Details',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 20),
          AppCachedImage(
            model.priority ?? '',
            radius: 8,
            fit: BoxFit.fitWidth,
            width: MediaQuery.of(context).size.width,
          ),
          SizedBox(height: 20),
          SizedBox(height: 20),
          Text(
            model.title ?? '',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 20),
          Text(model.content ?? '', style: TextStyle(color: AppColors.grey)),
          SizedBox(height: 20),
          Text(model.createdAt ?? '', style: TextStyle(color: AppColors.grey)),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
