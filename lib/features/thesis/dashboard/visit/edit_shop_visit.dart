import 'dart:io';

import 'package:flutter/material.dart';
import 'package:workspace/core/helper/extention.dart';
import 'package:workspace/core/components/app_bar.dart';
import 'package:workspace/core/components/app_popup.dart';
import 'package:workspace/core/components/app_button.dart';
import 'package:workspace/core/service/app_validator.dart';
import 'package:workspace/core/components/app_snack_bar.dart';
import 'package:workspace/core/components/app_text_field.dart';
import 'package:workspace/core/components/app_image_picker.dart';
import 'package:workspace/core/components/app_alert_dialog.dart';
import 'package:workspace/core/components/item_selection_popup.dart';
import 'package:workspace/features/thesis/auth/model/user_model.dart';
import 'package:workspace/features/thesis/dashboard/model/task_model.dart';
import 'package:workspace/features/thesis/dashboard/model/shop_visit_model.dart';
import 'package:workspace/features/thesis/dashboard/service/shop_visit_service.dart';
import 'package:workspace/features/thesis/dashboard/visit/task_selection_popup.dart';

class EditShopVisit extends StatefulWidget {
  const EditShopVisit({super.key, this.user, this.shopVisit});
  final UserModel? user;
  final ShopVisitModel? shopVisit;

  @override
  State<EditShopVisit> createState() => _EditShopVisitState();
}

class _EditShopVisitState extends State<EditShopVisit> {
  final TextEditingController _description = TextEditingController();
  final TextEditingController _client = TextEditingController();
  final TextEditingController _amount = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _title = TextEditingController();
  final ShopVisitService _service = ShopVisitService();
  final AppValidator _validator = AppValidator();
  final DateTime _date = DateTime.now();
  String? _visitType = 'Sales';
  ShopVisitModel? shopVisit;
  bool _isLoading2 = false;
  bool _isLoading = false;
  TaskModel? _task;
  File? _imageFile;

  final List<String> _taskTypeList = ['Sales', 'Support', 'Marketing'];
  @override
  void initState() {
    super.initState();
    shopVisit = widget.shopVisit;
    _initLoadData();
    _getShopVisit();
  }

  void _getShopVisit() async {
    shopVisit = await _service.getShopVisitDetail(widget.shopVisit?.id);
    setState(() {});
  }

  void _deleteShopVisit() async {
    Navigator.pop(context);
    setState(() => _isLoading2 = true);
    final result = await _service.deleteShopVisit(widget.shopVisit?.id ?? '');
    setState(() => _isLoading2 = false);
    result.fold((error) => AppSnackBar.show(context, error), (data) {
      AppSnackBar.show(context, data);
      Navigator.pop(context);
    });
  }

  void _initLoadData() {
    if (widget.shopVisit != null) {
      _title.text = widget.shopVisit?.svTitle ?? '';
      _description.text = widget.shopVisit?.svDescription ?? '';
      _client.text = widget.shopVisit?.svClient ?? '';
      _amount.text = widget.shopVisit?.svAmount ?? '';
      _visitType = widget.shopVisit?.svType ?? 'Sales';
      _task = widget.shopVisit?.task;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: const CustomAppBar(title: 'Edit Shop Visit'),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text('Select a task to create a shop visit (Optional)'),
              const SizedBox(height: 8),
              AppTextField(
                readOnly: true,
                controller: TextEditingController(text: getTaskDetails(_task)),
                onTap: () {
                  AppPopup.show(
                    context: context,
                    widget: TaskSelectionPopup(
                      selectedTask: _task,
                      userId: widget.user?.id ?? '',
                      onSelected: (value) {
                        setState(() => _task = value);
                        if (_client.text.isEmpty) {
                          _client.text = _task?.client ?? '';
                        }
                        if (_amount.text.isEmpty) {
                          _amount.text = _task?.amount ?? '';
                        }
                        if (_title.text.isEmpty) {
                          _title.text = _task?.title ?? '';
                        }
                        if (_description.text.isEmpty) {
                          _description.text = _task?.description ?? '';
                        }
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              const Text('Shop Visit Title'),
              const SizedBox(height: 8),
              AppTextField(
                controller: _title,
                hintText: 'Enter shop visit title',
                validator: _validator.validate,
              ),
              const SizedBox(height: 20),
              const Text('Shop Visit Description'),
              const SizedBox(height: 8),
              AppTextField(
                controller: _description,
                hintText: 'Enter shop visit description',
                validator: _validator.validate,
              ),
              const SizedBox(height: 20),
              const Text('Client Name (Optional)'),
              const SizedBox(height: 8),
              AppTextField(controller: _client, hintText: 'Enter client name'),
              const SizedBox(height: 20),
              const Text('Target Amount (Optional)'),
              const SizedBox(height: 8),
              AppTextField(
                controller: _amount,
                hintText: 'Enter target amount',
                textInputType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              const Text('Shop Visit Date'),
              const SizedBox(height: 8),
              AppTextField(
                readOnly: true,
                validator: _validator.validate,
                controller: TextEditingController(text: _date.toDateString()),
              ),
              const SizedBox(height: 20),
              const Text('Shop Visit Type'),
              const SizedBox(height: 8),
              AppTextField(
                readOnly: true,
                controller: TextEditingController(text: _visitType),
                validator: _validator.validate,
                onTap: () async {
                  final result = await AppPopup.show<String>(
                    context: context,
                    widget: ItemSelectionPopup(
                      list: _taskTypeList,
                      selectedItem: _visitType,
                    ),
                  );
                  setState(() => _visitType = result ?? 'Sales');
                },
              ),
              const SizedBox(height: 20),
              const Text('Shop Visit Image'),
              const SizedBox(height: 8),
              AppTextField(
                readOnly: true,
                hintText: 'Pick shop visit image',
                controller: TextEditingController(
                  text:
                      _imageFile?.path.split('/').last ??
                      'Pick shop visit image',
                ),
                onTap: () async {
                  final file = await AppImagePickerService.pickImage(context);
                  if (file == null || !context.mounted) return;
                  setState(() => _imageFile = file);
                },
              ),
              if (_imageFile != null) ...[
                const SizedBox(height: 20),
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          _imageFile!,
                          fit: BoxFit.contain,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width * 0.5,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: IconButton(
                        onPressed: () => setState(() => _imageFile = null),
                        icon: const Icon(Icons.delete, color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 30),
              AppButton(
                text: 'Update Shop Visit',
                isLoading: _isLoading,
                width: double.maxFinite,
                onTap: _editShopVisit,
              ),
              const SizedBox(height: 40),
              const Text(
                'Delete Shop Visit',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              AppButton(
                text: 'Delete Shop Visit',
                isLoading: _isLoading2,
                width: double.maxFinite,
                onTap: () async {
                  final result = await AppPopup.show<bool>(
                    context: context,
                    widget: const AppAlertDialog(
                      confirmText: 'Delete',
                      title: 'Delete Shop Visit',
                      content:
                          'Are you sure you want to delete this shop visit?',
                    ),
                  );
                  if (result != true) return;
                  _deleteShopVisit();
                },
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  void _editShopVisit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final result = await _service.editShopVisit(
      shopVisitId: shopVisit?.id ?? '',
      svTitle: _title.text,
      svDescription: _description.text,
      svDate: _date.toDateString() ?? '',
      svClient: _client.text,
      svAmount: _amount.text,
      imageFile: _imageFile,
      svType: _visitType ?? '',
      svTaskId: _task?.taskId ?? '',
      status: _task?.status ?? '',
      title: _task?.title ?? '',
      assignedTo: _task?.assignedTo ?? '',
      description: _task?.description ?? '',
      priority: _task?.priority ?? '',
      taskType: _task?.taskType ?? '',
      client: _task?.client ?? '',
      amount: _task?.amount ?? '',
      dueDate: _task?.dueDate ?? '',
      comments: _task?.comments ?? '',
      attachments: _task?.attachments ?? '',
    );
    setState(() => _isLoading = false);
    result.fold((error) => AppSnackBar.show(context, error), (data) {
      AppSnackBar.show(context, data);
      _task = null;
      _title.clear();
      _description.clear();
      _client.clear();
      _amount.clear();
      _imageFile = null;
      setState(() {});
    });
  }

  String getTaskDetails(TaskModel? task) {
    if (task == null) return 'Select a task';
    String detsil =
        '${task.title}\nClient: ${task.client}\nAmount: ${task.amount}';
    return detsil;
  }
}
