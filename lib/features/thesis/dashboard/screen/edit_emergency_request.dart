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
import 'package:workspace/features/thesis/home/model/notification_model.dart';
import 'package:workspace/features/thesis/dashboard/service/emergency_request_service.dart';

class EditEmergencyRequest extends StatefulWidget {
  const EditEmergencyRequest({super.key, this.assignedTo, this.request});
  final String? assignedTo;
  final NotificationModelV2? request;

  @override
  State<EditEmergencyRequest> createState() => _EditEmergencyRequestState();
}

class _EditEmergencyRequestState extends State<EditEmergencyRequest> {
  final EmergencyRequestService _service = EmergencyRequestService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AppValidator _validator = AppValidator();
  final _description = TextEditingController();
  final _comments = TextEditingController();
  final _title = TextEditingController();
  DateTime _date = DateTime.now();
  String _priority = 'Emergency';
  NotificationModelV2? request;
  bool _isLoading2 = false;
  String _assignedTo = '';
  bool _isLoading = false;

  final List<String> _priorities = ['Minor', 'Urgent', 'Emergency'];

  @override
  void initState() {
    super.initState();
    _assignedTo = widget.assignedTo ?? '';
    request = widget.request;
    initDataLoad();
    getDetails();
  }

  void getDetails() async {
    final result = await _service.getrequestDetails(
      assignedTo: widget.assignedTo ?? '',
      requestId: widget.request?.id ?? '',
    );
    setState(() => request = result);
  }

  void initDataLoad() {
    _date =
        DateTime.tryParse(widget.request?.createdAt ?? '') ?? DateTime.now();
    _title.text = widget.request?.title ?? '';
    _description.text = widget.request?.content ?? '';
    _priority = widget.request?.priority ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: CustomAppBar(title: 'Emergency Request Details'),
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
                      'Title: ${request?.title ?? ''}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 6),
                        Text(request?.content ?? ''),
                        SizedBox(height: 12),
                        Text('Priority: ${request?.priority ?? ''}'),
                        SizedBox(height: 2),
                        Text('Date: ${request?.createdAt ?? ''}'),
                        SizedBox(height: 4),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 35),
                Text(
                  'Edit Emergency Request',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8),
                Text('Emergency Request Title'),
                SizedBox(height: 8),
                AppTextField(
                  controller: _title,
                  hintText: 'Enter request title',
                  validator: _validator.validate,
                ),
                SizedBox(height: 20),
                Text('Emergency Request Description'),
                SizedBox(height: 8),
                AppTextField(
                  controller: _description,
                  hintText: 'Enter emergency description',
                  validator: _validator.validate,
                ),
                SizedBox(height: 20),
                Text('Emergency Request Priority'),
                SizedBox(height: 8),
                AppTextField(
                  readOnly: true,
                  controller: TextEditingController(text: _priority),
                  validator: _validator.validate,
                  onTap: () async {
                    await AppPopup.showAnimated(
                      context: context,
                      child: ItemSelectionPopUp(
                        list: _priorities,
                        selectedItem: _priority,
                        onSelected: (value) =>
                            setState(() => _priority = value ?? 'General'),
                      ),
                    );
                  },
                ),
                SizedBox(height: 30),
                AppButton(
                  text: 'Update Notification',
                  isLoading: _isLoading,
                  width: double.maxFinite,
                  onTap: _editNotification,
                ),
                SizedBox(height: 45),
                Text(
                  'Delete Notification',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8),
                AppButton(
                  text: 'Delete Notification',
                  isLoading: _isLoading2,
                  width: double.maxFinite,
                  onTap: () {
                    AppPopup.showAnimated(
                      context: context,
                      child: ApprovalWidget(
                        onApprove: _deleteNotification,
                        title: 'Delete Notification',
                        description:
                            'Are you sure you want to delete this notification?',
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

  void _editNotification() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    Map<String, dynamic> updatedFields = {
      'date': _date.toDateString() ?? '',
      'title': _title.text,
      'priority': _priority,
      'comments': _comments.text,
      'assignedTo': _assignedTo,
      'description': _description.text,
    };
    final result = await _service.editrequest(
      requestId: widget.request?.id ?? '',
      updatedFields: updatedFields,
    );
    setState(() => _isLoading = false);
    result.fold((error) => AppSnackBar.show(context, error), (data) {
      AppSnackBar.show(context, data);
      getDetails();
    });
  }

  void _deleteNotification() async {
    Navigator.pop(context);
    setState(() => _isLoading2 = true);
    final result = await _service.deleteRequest(widget.request?.id ?? '');
    setState(() => _isLoading2 = false);
    result.fold((error) => AppSnackBar.show(context, error), (data) {
      AppSnackBar.show(context, data);
      Navigator.pop(context);
    });
  }
}
