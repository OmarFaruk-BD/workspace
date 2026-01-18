import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:workspace/core/components/app_bar.dart';
import 'package:workspace/features/thesis/auth/model/user_model.dart';
import 'package:workspace/features/thesis/dashboard/model/shop_visit_model.dart';

class ShopVisitDetail extends StatefulWidget {
  const ShopVisitDetail({super.key, this.user, this.shopVisit});
  final UserModel? user;
  final ShopVisitModel? shopVisit;

  @override
  State<ShopVisitDetail> createState() => _ShopVisitDetailState();
}

class _ShopVisitDetailState extends State<ShopVisitDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Shop Visit Detail'),
      body: ListView(
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    'Description: ${widget.shopVisit?.task?.description ?? ''}',
                  ),
                  Text('Due Date: ${widget.shopVisit?.task?.dueDate ?? ''}'),
                  Text('Client: ${widget.shopVisit?.task?.client ?? ''}'),
                  Text('Amount: ${widget.shopVisit?.task?.amount ?? ''}'),
                  Text('Task Type: ${widget.shopVisit?.task?.taskType ?? ''}'),
                  Text('Priority: ${widget.shopVisit?.task?.priority ?? ''}'),
                  Text('Status: ${widget.shopVisit?.task?.status ?? ''}'),
                ],
              ),
            ),
          if (widget.shopVisit?.task?.comments != null)
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
                    widget.shopVisit?.task?.comments ?? '',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          SizedBox(height: 20),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
