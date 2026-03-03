import 'package:flutter/material.dart';
import 'package:workspace/core/utils/app_colors.dart';
import 'package:workspace/core/components/app_bar.dart';
import 'package:workspace/core/components/app_network_image.dart';
import 'package:workspace/features/thesis/home/model/notification_model.dart';

class NotificationDetail extends StatefulWidget {
  const NotificationDetail({super.key, required this.model});
  final NotificationModel model;

  @override
  State<NotificationDetail> createState() => _NotificationDetailState();
}

class _NotificationDetailState extends State<NotificationDetail> {
  late NotificationModel model;
  @override
  void initState() {
    super.initState();
    model = widget.model;
    _getDeatails();
  }

  void _getDeatails() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminAppBar(
        title: 'Notifications',
        onBackTap: () => Navigator.pop(context),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'Notification Details',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          AppCachedImage(
            model.priority ?? '',
            radius: 8,
            fit: BoxFit.fitWidth,
            width: MediaQuery.of(context).size.width,
          ),
          const SizedBox(height: 20),
          const SizedBox(height: 20),
          Text(
            model.title ?? '',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          Text(model.content ?? '', style: const TextStyle(color: AppColors.grey)),
          const SizedBox(height: 20),
          Text(model.createdAt ?? '', style: const TextStyle(color: AppColors.grey)),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
