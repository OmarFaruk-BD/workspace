import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:workspace/core/components/app_bar.dart';
import 'package:workspace/core/helper/navigation.dart';
import 'package:workspace/features/thesis/auth/model/user_model.dart';
import 'package:workspace/core/components/loading_or_empty.dart';
import 'package:workspace/features/thesis/dashboard/visit/e_shop_visit.dart';
import 'package:workspace/features/thesis/dashboard/model/shop_visit_model.dart';
import 'package:workspace/features/thesis/dashboard/service/shop_visit_service.dart';

class EmployeeShopVisitList extends StatefulWidget {
  const EmployeeShopVisitList({super.key, this.user});
  final UserModel? user;

  @override
  State<EmployeeShopVisitList> createState() => _EmployeeShopVisitListState();
}

class _EmployeeShopVisitListState extends State<EmployeeShopVisitList> {
  final ShopVisitService _service = ShopVisitService();
  List<ShopVisitModel> shopVisitList = [];
  List<ShopVisitModel> previousList = [];
  List<ShopVisitModel> thisMonthList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getShopVisitList();
  }

  void getShopVisitList() async {
    setState(() => isLoading = true);
    shopVisitList = await _service.getShopVisitByEmployee(
      widget.user?.id ?? '',
    );
    setState(() => isLoading = false);
    final split = splitNotifications(shopVisitList);
    previousList = split.previous;
    thisMonthList = split.today;
    setState(() {});
  }

  ({List<ShopVisitModel> today, List<ShopVisitModel> previous})
  splitNotifications(List<ShopVisitModel> notifications) {
    try {
      final thisMonth = DateTime(DateTime.now().year, DateTime.now().month);
      final dateFormat = DateFormat('MM-dd-yyyy');

      final todayNotificationList = <ShopVisitModel>[];
      final previousNotificationList = <ShopVisitModel>[];

      for (final n in notifications) {
        if (n.svDate == null) continue;

        final createdDate = dateFormat.parse(n.svDate!);

        if (createdDate.isBefore(thisMonth)) {
          previousNotificationList.add(n);
        } else {
          todayNotificationList.add(n);
        }
      }

      return (today: todayNotificationList, previous: previousNotificationList);
    } catch (e) {
      return (today: [], previous: []);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminAppBar(
        title: 'Shop Visit List',
        onBackTap: () => Navigator.pop(context),
      ),
      body: ListView(
        padding: EdgeInsets.all(24),
        children: [
          LoadingOrEmptyText(
            isLoading: isLoading,
            isEmpty: shopVisitList.isEmpty,
            emptyText: 'No shop visit found.',
          ),
          Text(
            'This Month Shop Visits',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          if (thisMonthList.isEmpty && isLoading == false)
            const Text('No shop visit found this month'),
          SizedBox(height: 10),
          ...List.generate(thisMonthList.length, (index) {
            return EShopVisitItem(
              data: thisMonthList[index],
              assignedTo: widget.user,
              onEdit: () => getShopVisitList(),
            );
          }),
          Text(
            'Previous Shop Visits',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          if (previousList.isEmpty && isLoading == false)
            const Text('No shop visit found previously'),
          SizedBox(height: 10),
          ...List.generate(previousList.length, (index) {
            return EShopVisitItem(
              data: previousList[index],
              assignedTo: widget.user,
              onEdit: () => getShopVisitList(),
            );
          }),
        ],
      ),
    );
  }
}

class EShopVisitItem extends StatelessWidget {
  const EShopVisitItem({
    super.key,
    this.onEdit,
    this.assignedTo,
    required this.data,
  });
  final UserModel? assignedTo;
  final VoidCallback? onEdit;
  final ShopVisitModel data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: () {
          AppNavigator.pushTo(
            context,
            EShopVisitDetails(shopVisit: data, user: assignedTo),
          );
        },
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 80,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.memory(
                      base64Decode(data.svAttachment ?? ''),
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.svTitle ?? '',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          data.svDescription ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.grey),
                        ),
                        if (data.svClient != null && data.svClient!.isNotEmpty)
                          Text(
                            'Client: ${data.svClient ?? ''}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.grey),
                          ),
                        if (data.svAmount != null && data.svAmount!.isNotEmpty)
                          Text(
                            'Amount: ${data.svAmount ?? ''}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.grey),
                          ),

                        Text(
                          'Shop Visit Type: ${data.svType ?? ''}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.grey),
                        ),

                        Text(
                          'Date: ${data.svDate ?? ''}',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  AppNavigator.pushTo(
                    context,
                    EShopVisitDetails(shopVisit: data, user: assignedTo),
                  );
                },
                child: Text('Details'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
