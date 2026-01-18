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
import 'package:workspace/features/thesis/admin/service/notification_service.dart';

class EditEmployeeNotificationPage extends StatefulWidget {
  const EditEmployeeNotificationPage({
    super.key,
    this.assignedTo,
    this.notification,
  });
  final String? assignedTo;
  final NotificationModel? notification;

  @override
  State<EditEmployeeNotificationPage> createState() =>
      _EditEmployeeNotificationPageState();
}

class _EditEmployeeNotificationPageState
    extends State<EditEmployeeNotificationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _notificationService = EmployeeNotificationService();
  final AppValidator _validator = AppValidator();
  final _description = TextEditingController();
  final _comments = TextEditingController();
  final _title = TextEditingController();
  NotificationModel? notification;
  DateTime _date = DateTime.now();
  String _priority = 'General';
  bool _isLoading2 = false;
  String _assignedTo = '';
  bool _isLoading = false;

  final List<String> _priorities = ['General', 'Emergency', 'Urgent'];

  @override
  void initState() {
    super.initState();
    _assignedTo = widget.assignedTo ?? '';
    notification = widget.notification;
    initDataLoad();
    getDetails();
  }

  void getDetails() async {
    final result = await _notificationService.getNotificationDetails(
      assignedTo: widget.assignedTo ?? '',
      notificationId: widget.notification?.id ?? '',
    );
    setState(() => notification = result);
  }

  void initDataLoad() {
    _date =
        DateTime.tryParse(widget.notification?.createdAt ?? '') ??
        DateTime.now();
    _title.text = widget.notification?.title ?? '';
    _description.text = widget.notification?.content ?? '';
    _priority = widget.notification?.priority ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AdminAppBar(title: 'Notification Details'),
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
                      'Title: ${notification?.title ?? ''}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 6),
                        Text(notification?.content ?? ''),
                        SizedBox(height: 12),
                        Text('Priority: ${notification?.priority ?? ''}'),
                        SizedBox(height: 2),
                        Text('Date: ${notification?.createdAt ?? ''}'),
                        SizedBox(height: 4),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 35),
                Text(
                  'Edit Notification',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8),
                Text('Notification Title'),
                SizedBox(height: 8),
                AppTextField(
                  controller: _title,
                  hintText: 'Enter notification title',
                  validator: _validator.validate,
                ),
                SizedBox(height: 20),
                Text('Notification Description'),
                SizedBox(height: 8),
                AppTextField(
                  controller: _description,
                  hintText: 'Enter notification description',
                  validator: _validator.validate,
                ),
                SizedBox(height: 20),
                Text('Notification Priority'),
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
    final result = await _notificationService.editNotification(
      notificationId: widget.notification?.id ?? '',
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
    final result = await _notificationService.deleteNotification(
      widget.notification?.id ?? '',
    );
    setState(() => _isLoading2 = false);
    result.fold((error) => AppSnackBar.show(context, error), (data) {
      AppSnackBar.show(context, data);
      Navigator.pop(context);
    });
  }
}
