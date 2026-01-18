import 'package:flutter/material.dart';
import 'package:workspace/core/components/app_bar.dart';
import 'package:workspace/core/utils/app_colors.dart';
import 'package:workspace/features/thesis/dashboard/model/my_leave_request.dart';
import 'package:workspace/features/thesis/dashboard/model/leave_detail_model.dart';
import 'package:workspace/features/thesis/dashboard/service/leave_service.dart';

class LeaveDetail extends StatefulWidget {
  const LeaveDetail({super.key, this.data});
  final Datum? data;

  @override
  State<LeaveDetail> createState() => _LeaveDetailState();
}

class _LeaveDetailState extends State<LeaveDetail> {
  LeaveDetailModel? leave;

  @override
  void initState() {
    super.initState();
    _initDataLoad();
    leave = LeaveDetailModel(
      leaveType: widget.data?.leaveType,
      leaveMode: widget.data?.leaveMode,
      status: widget.data?.status,
      dayCount: widget.data?.dayCount,
      fromDate: widget.data?.fromDate,
      toDate: widget.data?.toDate,
    );
  }

  void _initDataLoad() async {
    leave = await LeaveService().getLeaveDetails(widget.data?.id ?? '');
    setState(() {});
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
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.grey),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      leave?.leaveType ?? '',
                      style: TextStyle(color: AppColors.green),
                    ),
                    Text('${leave?.dayCount ?? ''} Day'),
                  ],
                ),
                SizedBox(height: 8),
                Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade200,
                  ),
                  child: Center(
                    child: Text(
                      leave?.status ?? '',
                      style: TextStyle(color: AppColors.green),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  height: 2,
                  width: double.infinity,
                  color: AppColors.grey,
                ),
                SizedBox(height: 15),
                Text(leave?.reason ?? ''),
                SizedBox(height: 15),
                Text('Start : ${leave?.fromDate ?? ''}'),
                Text('End : ${leave?.toDate ?? ''}'),
              ],
            ),
          ),
          SizedBox(height: 25),
          Text(
            'Emergency Contact',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 10),
          Text(leave?.emergencyContact ?? ''),
        ],
      ),
    );
  }
}
