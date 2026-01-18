import 'package:flutter/material.dart';
import 'package:workspace/core/helper/extention.dart';
import 'package:workspace/core/components/app_bar.dart';
import 'package:workspace/core/components/app_popup.dart';
import 'package:workspace/core/components/app_button.dart';
import 'package:workspace/core/service/app_validator.dart';
import 'package:workspace/core/components/app_snack_bar.dart';
import 'package:workspace/core/components/approval_popup.dart';
import 'package:workspace/core/components/app_text_field.dart';
import 'package:workspace/core/components/item_selection_popup.dart';
import 'package:workspace/features/thesis/dashboard/model/leave_model_v2.dart';
import 'package:workspace/features/thesis/dashboard/service/leave_request_service.dart';

class ELeaveDetail extends StatefulWidget {
  const ELeaveDetail({super.key, this.assignedTo, this.leave});
  final LeaveModelV2? leave;
  final String? assignedTo;

  @override
  State<ELeaveDetail> createState() => _ELeaveDetailState();
}

class _ELeaveDetailState extends State<ELeaveDetail> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final LeaveRequestService _service = LeaveRequestService();
  final AppValidator _validator = AppValidator();
  String _leaveStatus = 'Pending';
  LeaveModelV2? leaveModel;
  bool _isLoading2 = false;
  bool _isLoading = false;

  final List<String> _statusList = ['Pending', 'Approved', 'Rejected'];

  @override
  void initState() {
    super.initState();
    leaveModel = widget.leave;
    initDataLoad();
    getDetails();
  }

  void getDetails() async {
    final result = await _service.getLeaveRequestDetails(
      userId: widget.assignedTo ?? '',
      requestId: widget.leave?.id ?? '',
    );
    setState(() => leaveModel = result);
  }

  void initDataLoad() async {
    _leaveStatus = leaveModel?.status ?? 'Pending';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AdminAppBar(title: 'Leave Request Details'),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: ListTile(
                    title: Text(
                      'Title: ${leaveModel?.title ?? ''}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 6),
                        Text(leaveModel?.description ?? ''),
                        SizedBox(height: 12),
                        Text('From Date: ${leaveModel?.fromDate ?? ''}'),
                        SizedBox(height: 2),
                        Text('To Date: ${leaveModel?.toDate ?? ''}'),
                        SizedBox(height: 4),
                        Text('Status: ${leaveModel?.status ?? ''}'),
                        SizedBox(height: 4),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 35),
                Text(
                  'Update Leave Request Status',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8),
                AppTextField(
                  readOnly: true,
                  controller: TextEditingController(text: _leaveStatus),
                  validator: _validator.validate,
                  onTap: () async {
                    await AppPopup.showAnimated(
                      context: context,
                      child: ItemSelectionPopUp(
                        list: _statusList,
                        selectedItem: _leaveStatus,
                        onSelected: (value) =>
                            setState(() => _leaveStatus = value ?? 'Pending'),
                      ),
                    );
                  },
                ),
                SizedBox(height: 30),
                AdminButton(
                  text: 'Update Leave Request',
                  isLoading: _isLoading,
                  width: double.maxFinite,
                  onTap: _editNotification,
                ),
                SizedBox(height: 45),
                Text(
                  'Delete Leave Request',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8),
                AdminButton(
                  text: 'Delete Leave Request',
                  isLoading: _isLoading2,
                  width: double.maxFinite,
                  onTap: () {
                    AppPopup.showAnimated(
                      context: context,
                      child: ApprovalWidget(
                        onApprove: _deleteLeaveRequest,
                        title: 'Delete Leave Request',
                        description:
                            'Are you sure you want to delete this leave request?',
                      ),
                    );
                  },
                ),
                SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getDurationText(DateTime? fromDate, DateTime? toDate) {
    if (fromDate == null || toDate == null) return 'Pick leave duration';
    return '${fromDate.toDateString() ?? ''} - ${toDate.toDateString() ?? ''}';
  }

  void _editNotification() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    Map<String, dynamic> updatedFields = {'status': _leaveStatus};
    final result = await _service.editLeaveRequest(
      leaveId: widget.leave?.id ?? '',
      updatedFields: updatedFields,
    );
    setState(() => _isLoading = false);
    result.fold((error) => AppSnackBar.show(context, error), (data) {
      AppSnackBar.show(context, data);
      getDetails();
    });
  }

  void _deleteLeaveRequest() async {
    Navigator.pop(context);
    setState(() => _isLoading2 = true);
    final result = await _service.deleteLeaveRequest(widget.leave?.id ?? '');
    setState(() => _isLoading2 = false);
    result.fold((error) => AppSnackBar.show(context, error), (data) {
      AppSnackBar.show(context, data);
      Navigator.pop(context);
    });
  }
}
