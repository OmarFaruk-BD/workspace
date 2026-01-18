import 'package:flutter/material.dart';
import 'package:workspace/core/helper/extention.dart';
import 'package:workspace/core/components/app_bar.dart';
import 'package:workspace/core/components/app_popup.dart';
import 'package:workspace/core/components/app_button.dart';
import 'package:workspace/core/service/app_validator.dart';
import 'package:workspace/core/components/app_snack_bar.dart';
import 'package:workspace/core/components/app_text_field.dart';
import 'package:workspace/features/thesis/auth/model/user_model.dart';
import 'package:workspace/core/components/item_selection_popup.dart';
import 'package:workspace/features/thesis/dashboard/service/leave_request_service.dart';

class CreateLeaveRequest extends StatefulWidget {
  const CreateLeaveRequest({super.key, this.user});
  final UserModel? user;

  @override
  State<CreateLeaveRequest> createState() => _CreateLeaveRequestState();
}

class _CreateLeaveRequestState extends State<CreateLeaveRequest> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AppValidator _validator = AppValidator();
  final _description = TextEditingController();
  final _leaveService = LeaveRequestService();
  final _title = TextEditingController();
  String _leaveType = 'Casual';
  bool _isLoading = false;
  DateTime? _fromDate;
  DateTime? _toDate;

  final List<String> _leaveTypeList = ['Sick', 'Vacation', 'Casual', 'Other'];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: CustomAppBar(title: 'Create Leave Request'),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Leave Request Title'),
                SizedBox(height: 8),
                AppTextField(
                  controller: _title,
                  hintText: 'Enter leave request title',
                  validator: _validator.validate,
                ),
                SizedBox(height: 20),
                Text('Leave Request Description'),
                SizedBox(height: 8),
                AppTextField(
                  controller: _description,
                  hintText: 'Enter leave request description',
                  validator: _validator.validate,
                ),
                SizedBox(height: 20),
                Text('Leave Duration'),
                SizedBox(height: 8),
                AppTextField(
                  readOnly: true,
                  controller: TextEditingController(
                    text: getDurationText(_fromDate, _toDate),
                  ),
                  hintText: 'Pick leave duration',
                  validator: _validator.validate,
                  onTap: () async {
                    final dateRange = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 365)),
                      initialDateRange: DateTimeRange(
                        start: _fromDate ?? DateTime.now(),
                        end: _toDate ?? DateTime.now(),
                      ),
                    );
                    setState(() {
                      _fromDate = dateRange?.start;
                      _toDate = dateRange?.end;
                    });
                  },
                ),
                SizedBox(height: 20),
                Text('Leave Request Type'),
                SizedBox(height: 8),
                AppTextField(
                  readOnly: true,
                  controller: TextEditingController(text: _leaveType),
                  validator: _validator.validate,
                  onTap: () async {
                    await AppPopup.showAnimated(
                      context: context,
                      child: ItemSelectionPopUp(
                        list: _leaveTypeList,
                        selectedItem: _leaveType,
                        onSelected: (value) =>
                            setState(() => _leaveType = value ?? 'Casual'),
                      ),
                    );
                  },
                ),
                SizedBox(height: 30),
                AppButton(
                  text: 'Create Leave Request',
                  isLoading: _isLoading,
                  width: double.maxFinite,
                  onTap: _createLeaveRequest,
                ),
                SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? getDurationText(DateTime? fromDate, DateTime? toDate) {
    if (fromDate == null || toDate == null) return null;
    return '${fromDate.toDateString() ?? ''} - ${toDate.toDateString() ?? ''}';
  }

  void _createLeaveRequest() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final result = await _leaveService.createLeaveRequest(
      userName: widget.user?.name ?? '',
      userId: widget.user?.id ?? '',
      title: _title.text,
      description: _description.text,
      type: _leaveType,
      fromDate: _fromDate.toDateString() ?? '',
      toDate: _toDate.toDateString() ?? '',
      status: 'Pending',
      comment: '',
      note: '',
    );
    setState(() => _isLoading = false);
    result.fold((error) => AppSnackBar.show(context, error), (data) {
      _title.clear();
      _description.clear();
      AppSnackBar.show(context, data);
    });
  }
}
