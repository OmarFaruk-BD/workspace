import 'dart:io';

import 'package:flutter/material.dart';
import 'package:workspace/core/helper/extention.dart';
import 'package:workspace/core/components/app_bar.dart';
import 'package:workspace/core/components/app_popup.dart';
import 'package:workspace/core/components/app_button.dart';
import 'package:workspace/core/service/app_validator.dart';
import 'package:workspace/core/components/app_snack_bar.dart';
import 'package:workspace/core/components/app_text_field.dart';
import 'package:workspace/features/thesis/auth/model/user_model.dart';
import 'package:workspace/core/components/app_image_helper.dart';
import 'package:workspace/core/components/app_image_picker.dart';
import 'package:workspace/core/components/item_selection_popup.dart';
import 'package:workspace/features/thesis/admin/service/employee_service.dart';

class EditEmployeePage extends StatefulWidget {
  const EditEmployeePage({super.key, this.user, this.title = 'Employee'});
  final UserModel? user;
  final String title;

  @override
  State<EditEmployeePage> createState() => _EditEmployeePageState();
}

class _EditEmployeePageState extends State<EditEmployeePage> {
  final TextEditingController _departmentTEC = TextEditingController();
  final TextEditingController _positionTEC = TextEditingController();
  final TextEditingController _passwordTEC = TextEditingController();
  final TextEditingController _phoneTEC = TextEditingController();
  final TextEditingController _emailTEC = TextEditingController();
  final TextEditingController _nameTEC = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final EmployeeService _employeeService = EmployeeService();
  final AppValidator _validator = AppValidator();
  String role = 'Employee';
  bool _isLoading = false;
  String? _uploadedImage;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    initLoadData();
  }

  void initLoadData() {
    _departmentTEC.text = widget.user?.department ?? '';
    _positionTEC.text = widget.user?.position ?? '';
    _passwordTEC.text = widget.user?.password ?? '';
    role = widget.user?.role.capitalize() ?? '';
    _phoneTEC.text = widget.user?.phone ?? '';
    _emailTEC.text = widget.user?.email ?? '';
    _nameTEC.text = widget.user?.name ?? '';
    setState(() {});
    getImage();
  }

  void getImage() async {
    final getUser = await _employeeService.getEmployeeWithImage(
      widget.user?.id,
    );
    setState(() => _uploadedImage = getUser?.imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AdminAppBar(title: 'Edit ${widget.title}'),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(25),
              children: [
                Text('Name'),
                const SizedBox(height: 8),
                AppTextField(
                  controller: _nameTEC,
                  hintText: 'Enter Employee Name',
                  validator: _validator.validateName,
                ),
                SizedBox(height: 20),
                Text('Email'),
                const SizedBox(height: 8),
                AppTextField(
                  readOnly: true,
                  controller: _emailTEC,
                  hintText: 'Enter Employee Email',
                  validator: _validator.validateEmail,
                ),
                SizedBox(height: 20),
                Text('Password'),
                const SizedBox(height: 8),
                AppTextField(
                  readOnly: true,
                  controller: _passwordTEC,
                  hintText: 'Enter Employee Password',
                  validator: _validator.validatePassword,
                ),
                SizedBox(height: 20),
                Text('Position'),
                const SizedBox(height: 8),
                AppTextField(
                  controller: _positionTEC,
                  hintText: 'Enter Employee Position',
                  validator: _validator.validate,
                ),
                SizedBox(height: 20),
                Text('Phone No'),
                const SizedBox(height: 8),
                AppTextField(
                  controller: _phoneTEC,
                  hintText: 'Enter Employee Phone',
                  validator: _validator.validatePhoneNo,
                  textInputType: TextInputType.phone,
                ),
                SizedBox(height: 20),
                Text('Department'),
                const SizedBox(height: 8),
                AppTextField(
                  controller: _departmentTEC,
                  hintText: 'Enter Employee Department',
                  validator: _validator.validate,
                ),
                SizedBox(height: 20),
                Text('User Role'),
                const SizedBox(height: 8),
                AppTextField(
                  readOnly: true,
                  hintText: 'Role',
                  controller: TextEditingController(text: role),
                  onTap: () {
                    AppPopup.showAnimated(
                      child: ItemSelectionPopUp(
                        list: ['Admin', 'Employee'],
                        onSelected: (item) {
                          role = item ?? 'Employee';
                          setState(() {});
                        },
                        selectedItem: role,
                      ),
                      context: context,
                    );
                  },
                ),
                SizedBox(height: 20),
                Text('User Image'),
                const SizedBox(height: 8),
                AppTextField(
                  readOnly: true,
                  hintText: 'Pick User Image',
                  controller: TextEditingController(
                    text: _imageFile?.path.split('/').last ?? 'Pick User Image',
                  ),
                  onTap: () async {
                    await AppImagePicker().pickImage(
                      context: context,
                      onImagePick: (file) {
                        _imageFile = file;
                        setState(() {});
                      },
                    );
                  },
                ),
                if (_imageFile != null) const SizedBox(height: 20),
                if (_imageFile != null)
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
                          icon: Icon(Icons.delete, color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                if (_uploadedImage != null && _imageFile == null)
                  const SizedBox(height: 20),
                if (_uploadedImage != null && _imageFile == null)
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: AppImageHelper.base64ToImage(
                      _uploadedImage!,
                      fit: BoxFit.contain,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width * 0.5,
                    ),
                  ),
                const SizedBox(height: 30),
                AppButton(
                  isLoading: _isLoading,
                  onTap: _editEmployee,
                  text: 'Update ${widget.title}',
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _editEmployee() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final result = await _employeeService.editEmployee(
      uid: widget.user?.id ?? '',
      name: _nameTEC.text.trim(),
      email: _emailTEC.text.trim(),
      phone: _phoneTEC.text.trim(),
      password: _passwordTEC.text.trim(),
      position: _positionTEC.text.trim(),
      department: _departmentTEC.text.trim(),
      role: role,
      imageFile: _imageFile,
    );

    setState(() => _isLoading = false);

    result.fold((error) => AppSnackBar.show(context, error), (success) {
      AppSnackBar.show(context, success);
      Navigator.pop(context);
    });
  }
}
