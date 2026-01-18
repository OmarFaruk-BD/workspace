import 'package:flutter/material.dart';
import 'package:workspace/core/components/app_bar.dart';
import 'package:workspace/features/thesis/dashboard/widget/chip_item.dart';
import 'package:workspace/features/thesis/dashboard/widget/leave_item.dart';
import 'package:workspace/features/thesis/dashboard/service/leave_service.dart';
import 'package:workspace/features/thesis/dashboard/model/my_leave_request.dart';

class LeaveApproval extends StatefulWidget {
  const LeaveApproval({super.key});

  @override
  State<LeaveApproval> createState() => _LeaveApprovalState();
}

class _LeaveApprovalState extends State<LeaveApproval> {
  String? selectedItem = 'Pending';
  MyLeaveRequestModel? leaveModel;

  void _getData() async {
    final getData = await LeaveService().getMyLeaveRequest();
    setState(() => leaveModel = getData);
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminAppBar(
        title: 'Leave Approval',
        onBackTap: () => Navigator.pop(context),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ChipItem(
                  text: 'Pending (${leaveModel?.pending?.count ?? 0})',
                  isSelected: selectedItem == 'Pending',
                  onTap: () => setState(() => selectedItem = 'Pending'),
                ),
                ChipItem(
                  text: 'Approved (${leaveModel?.approved?.count ?? 0})',
                  isSelected: selectedItem == 'Approved',
                  onTap: () => setState(() => selectedItem = 'Approved'),
                ),
                ChipItem(
                  text: 'Not approved (${leaveModel?.notApproved?.count ?? 0})',
                  isSelected: selectedItem == 'Not approved',
                  onTap: () => setState(() => selectedItem = 'Not approved'),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          if (leaveModel?.pending?.items?.data?.isNotEmpty == true &&
              selectedItem == 'Pending')
            ...List.generate(leaveModel!.pending!.items!.data!.length, (index) {
              final getData = leaveModel!.pending!.items!.data![index];
              return LeaveItem(leave: getData, onCancel: () => _getData());
            }),
          if (leaveModel?.approved?.items?.data?.isNotEmpty == true &&
              selectedItem == 'Approved')
            ...List.generate(leaveModel!.approved!.items!.data!.length, (
              index,
            ) {
              final myLeaveModel = leaveModel!.approved!.items!.data![index];
              return LeaveItem(leave: myLeaveModel, onCancel: () => _getData());
            }),
          if (leaveModel?.notApproved?.items?.data?.isNotEmpty == true &&
              selectedItem == 'Not approved')
            ...List.generate(leaveModel!.notApproved!.items!.data!.length, (
              index,
            ) {
              final myLeaveModel = leaveModel!.notApproved!.items!.data![index];
              return LeaveItem(leave: myLeaveModel, onCancel: () => _getData());
            }),
        ],
      ),
    );
  }
}
