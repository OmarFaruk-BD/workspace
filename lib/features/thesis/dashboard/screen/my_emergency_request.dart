import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:workspace/core/helper/navigation.dart';
import 'package:workspace/core/components/app_bar.dart';
import 'package:workspace/core/components/app_button.dart';
import 'package:workspace/features/thesis/auth/model/user_model.dart';
import 'package:workspace/core/components/loading_or_empty.dart';
import 'package:workspace/features/thesis/home/model/notification_model.dart';
import 'package:workspace/features/thesis/dashboard/screen/edit_emergency_request.dart';
import 'package:workspace/features/thesis/dashboard/service/emergency_request_service.dart';

class MyEmergencyRequest extends StatefulWidget {
  const MyEmergencyRequest({super.key, this.user});
  final UserModel? user;

  @override
  State<MyEmergencyRequest> createState() => _MyEmergencyRequestState();
}

class _MyEmergencyRequestState extends State<MyEmergencyRequest> {
  final EmergencyRequestService _service = EmergencyRequestService();
  List<NotificationModelV2> notifications = [];
  List<NotificationModelV2> previousList = [];
  List<NotificationModelV2> todayList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getNtifications();
  }

  void getNtifications() async {
    setState(() => isLoading = true);
    notifications = await _service.getRequestByEmployee(widget.user?.id ?? '');
    setState(() => isLoading = false);
    final split = splitNotifications(notifications);
    previousList = split.previous;
    todayList = split.today;
    setState(() {});
  }

  ({List<NotificationModelV2> today, List<NotificationModelV2> previous})
  splitNotifications(List<NotificationModelV2> notifications) {
    try {
      final today = DateTime.now();
      final dateFormat = DateFormat('MM-dd-yyyy');

      final todayNotificationList = <NotificationModelV2>[];
      final previousNotificationList = <NotificationModelV2>[];

      for (final n in notifications) {
        if (n.createdAt == null) continue;

        final createdDate = dateFormat.parse(n.createdAt!);
        final isToday =
            createdDate.year == today.year &&
            createdDate.month == today.month &&
            createdDate.day == today.day;

        if (isToday) {
          todayNotificationList.add(n);
        } else if (createdDate.isBefore(today)) {
          previousNotificationList.add(n);
        }
      }

      previousNotificationList.sort((a, b) {
        final aDate = dateFormat.parse(a.createdAt!);
        final bDate = dateFormat.parse(b.createdAt!);
        return bDate.compareTo(aDate);
      });

      return (today: todayNotificationList, previous: previousNotificationList);
    } catch (e) {
      return (today: [], previous: []);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'My Emergency Requests',
        onBackTap: () => Navigator.pop(context),
      ),
      body: ListView(
        padding: EdgeInsets.all(24),
        children: [
          LoadingOrEmptyText(
            isLoading: isLoading,
            isEmpty: notifications.isEmpty,
            emptyText: 'No requests found.',
          ),
          Text(
            'Today My Emergency Requests',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          if (todayList.isEmpty && isLoading == false)
            const Text('No requests found'),
          SizedBox(height: 10),
          ...List.generate(todayList.length, (index) {
            return RequestItem(
              data: todayList[index],
              assignedTo: widget.user?.id,
              onEdit: () => getNtifications(),
            );
          }),
          Text(
            'Previous Emergency Requests',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          if (previousList.isEmpty && isLoading == false)
            const Text('No requests found'),
          SizedBox(height: 10),
          ...List.generate(previousList.length, (index) {
            return RequestItem(
              data: previousList[index],
              assignedTo: widget.user?.id,
              onEdit: () => getNtifications(),
            );
          }),
        ],
      ),
    );
  }
}

class RequestItem extends StatelessWidget {
  const RequestItem({
    super.key,
    this.onEdit,
    this.assignedTo,
    required this.data,
  });
  final String? assignedTo;
  final VoidCallback? onEdit;
  final NotificationModelV2 data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: () => AppNavigator.pushTo(
          context,
          EditEmergencyRequest(request: data, assignedTo: assignedTo),
        ).then((_) => onEdit?.call()),

        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 5),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title ?? '',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      data.content ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 10),
                    Text(
                      data.createdAt ?? '',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              AppButton(
                text: data.priority ?? '',
                radius: 20,
                vPadding: 6,
                textSize: 12,
                hPadding: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
