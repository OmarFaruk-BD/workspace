import 'package:flutter/material.dart';
import 'package:workspace/core/utils/app_colors.dart';
import 'package:workspace/core/helper/navigation.dart';
import 'package:workspace/core/components/app_button.dart';
import 'package:workspace/core/components/app_snack_bar.dart';
import 'package:workspace/features/thesis/dashboard/screen/leave_detail.dart';
import 'package:workspace/features/thesis/dashboard/service/leave_service.dart';
import 'package:workspace/features/thesis/dashboard/model/my_leave_request.dart';

class LeaveItem extends StatefulWidget {
  const LeaveItem({super.key, this.leave, this.onCancel});
  final Datum? leave;
  final VoidCallback? onCancel;

  @override
  State<LeaveItem> createState() => _LeaveItemState();
}

class _LeaveItemState extends State<LeaveItem> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => AppNavigator.push(context, LeaveDetail(data: widget.leave)),
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.grey),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.leave?.leaveType ?? '',
                  style: TextStyle(color: AppColors.yellow),
                ),
                Text('${widget.leave?.dayCount ?? ''} Day'),
              ],
            ),
            SizedBox(height: 8),
            Container(
              width: double.maxFinite,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade200,
              ),
              child: Center(
                child: Text(
                  widget.leave?.status ?? '',
                  style: TextStyle(color: AppColors.yellow),
                ),
              ),
            ),
            SizedBox(height: 8),
            Container(height: 2, width: double.infinity, color: AppColors.grey),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Start : ${widget.leave?.fromDate ?? ''}'),
                    Text('End : ${widget.leave?.toDate ?? ''}'),
                  ],
                ),
                AppButton(
                  text: 'Cancel',
                  radius: 8,
                  vPadding: 6,
                  hPadding: 18,
                  textSize: 12,
                  onTap: _cancelLeave,
                  isLoading: isLoading,
                  textColor: AppColors.red,
                  btnColor: AppColors.red.withAlpha(50),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _cancelLeave() async {
    setState(() => isLoading = true);
    final result = await LeaveService().cancelLeaveRequest(widget.leave?.id);
    setState(() => isLoading = false);
    result.fold((error) => AppSnackBar.show(context, error), (data) {
      widget.onCancel?.call();
      AppSnackBar.show(context, data);
    });
  }
}
