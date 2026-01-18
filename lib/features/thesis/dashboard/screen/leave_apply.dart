import 'package:flutter/material.dart';
import 'package:workspace/core/helper/extention.dart';
import 'package:workspace/core/utils/app_colors.dart';
import 'package:workspace/core/utils/app_images.dart';
import 'package:workspace/core/components/app_bar.dart';
import 'package:workspace/core/components/app_popup.dart';
import 'package:workspace/core/components/app_button.dart';
import 'package:workspace/core/components/app_snack_bar.dart';
import 'package:workspace/core/components/app_text_field.dart';
import 'package:workspace/core/components/item_selection_field.dart';
import 'package:workspace/core/components/item_selection_popup.dart';
import 'package:workspace/features/thesis/dashboard/service/leave_service.dart';

class LeaveApplyPage extends StatefulWidget {
  const LeaveApplyPage({super.key});

  @override
  State<LeaveApplyPage> createState() => _LeaveApplyPageState();
}

class _LeaveApplyPageState extends State<LeaveApplyPage> {
  final reasonTEC = TextEditingController();
  final phoneTEC = TextEditingController();
  bool isLoading = false;
  bool isFullDay = true;
  DateTime? startDate;
  DateTime? endDate;
  String? leaveType;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AdminAppBar(
          title: 'Leave Request',
          onBackTap: () => Navigator.pop(context),
        ),
        body: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text('Leave '),
            SizedBox(height: 15),
            Row(
              children: [
                _buildButton(
                  title: 'Full day',
                  isSelected: isFullDay,
                  onTap: () => setState(() => isFullDay = true),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    bottomLeft: Radius.circular(40),
                  ),
                ),
                _buildButton(
                  title: 'Half Day',
                  isSelected: !isFullDay,
                  onTap: () => setState(() => isFullDay = false),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
              ],
            ),
            SizedBox(height: 25),
            ItemSelectionField(
              text: leaveType ?? 'Select leave type',
              onTap: () {
                AppPopup.showAnimated(
                  context: context,
                  child: ItemSelectionPopUp(
                    list: [
                      'Sick Leave',
                      'Casual Leave',
                      'Vacation Leave',
                      'Other',
                    ],
                    selectedItem: leaveType,
                    onSelected: (value) => setState(() => leaveType = value),
                  ),
                );
              },
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Flexible(
                  child: ItemSelectionField(
                    icon: AppImages.clock,
                    text: startDate.toDateString('dd MMMM yy') ?? 'From Date',
                    onTap: () async {
                      startDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2050),
                        initialDatePickerMode: DatePickerMode.day,
                      );
                      setState(() {});
                    },
                  ),
                ),
                SizedBox(width: 10),
                Flexible(
                  child: ItemSelectionField(
                    icon: AppImages.clock,
                    text: endDate.toDateString('dd MMMM yy') ?? 'To Date',
                    onTap: () async {
                      endDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2050),
                        initialDatePickerMode: DatePickerMode.day,
                      );
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),

            AppTextField(
              controller: reasonTEC,
              hintText: 'Reason',
              maxLine: 5,
              radius: 8,
            ),
            SizedBox(height: 20),
            Text(
              'Emergency Contact Number ',
              style: TextStyle(color: AppColors.grey),
            ),
            SizedBox(height: 15),
            AppTextField(
              controller: phoneTEC,
              hintText: 'Emergency Contact Number',
              radius: 8,
            ),
            SizedBox(height: 40),
            AppButton(
              text: 'SUBMIT',
              isLoading: isLoading,
              onTap: _requestLeave,
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _requestLeave() async {
    if (leaveType == null) {
      AppSnackBar.show(context, 'Please submit leave type.');
      return;
    }
    if (startDate == null || endDate == null) {
      AppSnackBar.show(context, 'Please select start and end date');
      return;
    }
    if (reasonTEC.text.isEmpty) {
      AppSnackBar.show(context, 'Please submit reason.');
      return;
    }
    if (phoneTEC.text.isEmpty) {
      AppSnackBar.show(context, 'Please submit emergency contact number.');
      return;
    }
    setState(() => isLoading = true);
    Map<String, dynamic> payload = {
      'leave_mode': isFullDay ? 'full_day' : 'half_day',
      'from_date': startDate.toDateString('yyyy-MM-dd'),
      'to_date': endDate.toDateString('yyyy-MM-dd'),
      'emergency_contact': phoneTEC.text,
      'reason': reasonTEC.text,
      'leave_type': leaveType,
    };
    final result = await LeaveService().leaveRequest(payload);
    setState(() => isLoading = false);
    result.fold((error) => AppSnackBar.show(context, error), (data) {
      Navigator.pop(context);
      AppSnackBar.show(context, data);
    });
  }

  Widget _buildButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    required BorderRadius borderRadius,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: isSelected ? AppColors.red : Colors.white,
            border: Border.all(
              color: isSelected ? AppColors.red : AppColors.grey,
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
