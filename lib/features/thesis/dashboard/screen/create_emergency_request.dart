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
import 'package:workspace/features/thesis/dashboard/service/emergency_request_service.dart';

class CreateEmergencyRequest extends StatefulWidget {
  const CreateEmergencyRequest({super.key, this.user});
  final UserModel? user;

  @override
  State<CreateEmergencyRequest> createState() => _CreateEmergencyRequestState();
}

class _CreateEmergencyRequestState extends State<CreateEmergencyRequest> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _notificationService = EmergencyRequestService();
  final AppValidator _validator = AppValidator();
  final _description = TextEditingController();
  final _title = TextEditingController();
  final DateTime _date = DateTime.now();
  String _priority = 'Emergency';
  String _assignedTo = '';
  bool _isLoading = false;

  final List<String> _priorities = ['Minor', 'Urgent', 'Emergency'];

  @override
  void initState() {
    super.initState();
    _assignedTo = widget.user?.id ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: CustomAppBar(title: 'Create Emergency Request'),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                  hintText: 'Enter request description',
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
                            setState(() => _priority = value ?? 'Emergency'),
                      ),
                    );
                  },
                ),
                SizedBox(height: 30),
                AppButton(
                  text: 'Create Emergency Request',
                  isLoading: _isLoading,
                  width: double.maxFinite,
                  onTap: _createRequest,
                ),
                SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _createRequest() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final result = await _notificationService.createRequest(
      title: _title.text,
      priority: _priority,
      assignedTo: _assignedTo,
      description: _description.text,
      date: _date.toDateString() ?? '',
      userName: widget.user?.name ?? '',
    );
    setState(() => _isLoading = false);
    result.fold((error) => AppSnackBar.show(context, error), (data) {
      _title.clear();
      _description.clear();
      AppSnackBar.show(context, data);
    });
  }
}
