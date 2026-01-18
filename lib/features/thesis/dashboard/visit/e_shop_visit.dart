import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:workspace/core/components/app_bar.dart';
import 'package:workspace/core/components/app_button.dart';
import 'package:workspace/core/components/app_snack_bar.dart';
import 'package:workspace/core/components/app_text_field.dart';
import 'package:workspace/features/thesis/auth/model/user_model.dart';
import 'package:workspace/features/thesis/dashboard/model/shop_visit_model.dart';
import 'package:workspace/features/thesis/dashboard/service/shop_visit_service.dart';

class EShopVisitDetails extends StatefulWidget {
  const EShopVisitDetails({super.key, this.user, this.shopVisit});
  final UserModel? user;
  final ShopVisitModel? shopVisit;

  @override
  State<EShopVisitDetails> createState() => _EShopVisitDetailsState();
}

class _EShopVisitDetailsState extends State<EShopVisitDetails> {
  final TextEditingController _commentTEC = TextEditingController();
  final ShopVisitService _service = ShopVisitService();
  ShopVisitModel? shopVisit;
  bool _isLoading = false;

  void _getShopVisit() async {
    shopVisit = await _service.getShopVisitDetail(widget.shopVisit?.id);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    shopVisit = widget.shopVisit;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminAppBar(title: 'Shop Visit Detail'),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: ListView(
          padding: EdgeInsets.all(20),
          children: [
            Image.memory(
              base64Decode(widget.shopVisit?.svAttachment ?? ''),
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 8,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Text('Shop Visit Details')),
                  Text(
                    'Title: ${widget.shopVisit?.svTitle ?? ''}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text('Description: ${widget.shopVisit?.svDescription ?? ''}'),
                  Text('Date: ${widget.shopVisit?.svDate ?? ''}'),
                  Text('Client: ${widget.shopVisit?.svClient ?? ''}'),
                  Text('Amount: ${widget.shopVisit?.svAmount ?? ''}'),
                  Text('Visit Type: ${widget.shopVisit?.svType ?? ''}'),
                ],
              ),
            ),
            SizedBox(height: 20),
            if (widget.shopVisit?.task != null)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 8,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: Text('Shop Visit on Task')),
                    Text(
                      'Title: ${widget.shopVisit?.task?.title ?? ''}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Description: ${widget.shopVisit?.task?.description ?? ''}',
                    ),
                    Text('Due Date: ${widget.shopVisit?.task?.dueDate ?? ''}'),
                    Text('Client: ${widget.shopVisit?.task?.client ?? ''}'),
                    Text('Amount: ${widget.shopVisit?.task?.amount ?? ''}'),
                    Text(
                      'Task Type: ${widget.shopVisit?.task?.taskType ?? ''}',
                    ),
                    Text('Priority: ${widget.shopVisit?.task?.priority ?? ''}'),
                    Text('Status: ${widget.shopVisit?.task?.status ?? ''}'),
                  ],
                ),
              ),
            if (shopVisit?.task?.comments != null)
              Container(
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 8,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: Text('Management Comments')),
                    Text(
                      shopVisit?.task?.comments ?? '',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 50),
            Text(
              'Add Your Comments',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            AppTextField(
              controller: _commentTEC,
              hintText: 'Write a comment',
              maxLine: 3,
            ),
            SizedBox(height: 20),
            AdminButton(
              text: 'Add Comment',
              onTap: _addComment,
              isLoading: _isLoading,
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 50),
          ],
        ),
      ),
    );
  }

  void _addComment() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_commentTEC.text.isEmpty) {
      AppSnackBar.error(context, 'Please enter comment.');
      return;
    }
    setState(() => _isLoading = true);
    final result = await _service.editShopVisitV2(
      shopVisitId: shopVisit?.id ?? '',
      comments: _commentTEC.text,
    );
    setState(() => _isLoading = false);
    result.fold((error) => AppSnackBar.show(context, error), (data) {
      _commentTEC.clear();
      AppSnackBar.show(context, data);
      _getShopVisit();
    });
  }
}
