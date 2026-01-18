import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:workspace/core/helper/navigation.dart';
import 'package:workspace/core/components/app_bar.dart';
import 'package:workspace/core/components/app_button.dart';
import 'package:workspace/features/thesis/auth/model/user_model.dart';
import 'package:workspace/core/components/loading_or_empty.dart';
import 'package:workspace/features/thesis/dashboard/model/leave_model_v2.dart';
import 'package:workspace/features/thesis/dashboard/screen/edit_leave_request.dart';
import 'package:workspace/features/thesis/dashboard/service/leave_request_service.dart';

class MyLeaveRequest extends StatefulWidget {
  const MyLeaveRequest({super.key, this.user});
  final UserModel? user;

  @override
  State<MyLeaveRequest> createState() => _MyLeaveRequestState();
}

class _MyLeaveRequestState extends State<MyLeaveRequest> {
  final LeaveRequestService _service = LeaveRequestService();
  List<LeaveModelV2> leaveRequestList = [];
  List<LeaveModelV2> previousList = [];
  List<LeaveModelV2> todayList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getNtifications();
  }

  void getNtifications() async {
    setState(() => isLoading = true);
    leaveRequestList = await _service.getLeaveRequestByEmployee(
      widget.user?.id ?? '',
    );
    setState(() => isLoading = false);
    final split = splitNotifications(leaveRequestList);
    previousList = split.previous;
    todayList = split.today;
    setState(() {});
  }

  ({List<LeaveModelV2> today, List<LeaveModelV2> previous}) splitNotifications(
    List<LeaveModelV2> notifications,
  ) {
    try {
      final today = DateTime.now();
      final dateFormat = DateFormat('MM-dd-yyyy');

      final upcomingList = <LeaveModelV2>[];
      final previousList = <LeaveModelV2>[];

      for (final n in notifications) {
        if (n.toDate == null) continue;

        final toDate = dateFormat.parse(n.toDate!);

        if (toDate.isBefore(today)) {
          previousList.add(n);
        } else {
          upcomingList.add(n);
        }
      }

      previousList.sort((a, b) {
        final aDate = dateFormat.parse(a.toDate!);
        final bDate = dateFormat.parse(b.toDate!);
        return bDate.compareTo(aDate);
      });

      return (today: upcomingList, previous: previousList);
    } catch (e) {
      return (today: [], previous: []);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'My Leave Requests',
        onBackTap: () => Navigator.pop(context),
      ),
      body: ListView(
        padding: EdgeInsets.all(24),
        children: [
          LoadingOrEmptyText(
            isLoading: isLoading,
            isEmpty: leaveRequestList.isEmpty,
            emptyText: 'No leave requests found.',
          ),
          Text(
            'Upcoming Leave Requests',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          if (todayList.isEmpty && isLoading == false)
            const Text('No leave requests found'),
          SizedBox(height: 10),
          ...List.generate(todayList.length, (index) {
            return LeaveRequestItem(
              data: todayList[index],
              assignedTo: widget.user?.id,
              onEdit: () => getNtifications(),
            );
          }),
          Text(
            'Previous Leave Requests',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          if (previousList.isEmpty && isLoading == false)
            const Text('No leave requests found'),
          SizedBox(height: 10),
          ...List.generate(previousList.length, (index) {
            return LeaveRequestItem(
              isPrevious: true,
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

class LeaveRequestItem extends StatelessWidget {
  const LeaveRequestItem({
    super.key,
    this.onEdit,
    this.assignedTo,
    required this.data,
    this.isPrevious = false,
  });

  final bool isPrevious;
  final LeaveModelV2 data;
  final String? assignedTo;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: () {
          if (!isPrevious) {
            AppNavigator.pushTo(
              context,
              EditLeaveRequest(leave: data, assignedTo: assignedTo),
            ).then((_) => onEdit?.call());
          }
        },
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
                      data.description ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'From: ${data.fromDate ?? ''}, \nTo: ${data.toDate ?? ''}',
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Status: ${data.status ?? ''}',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              AppButton(
                text: data.type ?? '',
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
