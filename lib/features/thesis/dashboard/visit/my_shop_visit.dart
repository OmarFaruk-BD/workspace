import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:workspace/core/components/app_bar.dart';
import 'package:workspace/core/helper/navigation.dart';
import 'package:workspace/features/thesis/auth/model/user_model.dart';
import 'package:workspace/core/components/loading_or_empty.dart';
import 'package:workspace/features/thesis/dashboard/model/shop_visit_model.dart';
import 'package:workspace/features/thesis/dashboard/service/shop_visit_service.dart';
import 'package:workspace/features/thesis/dashboard/visit/edit_shop_visit.dart';
import 'package:workspace/features/thesis/dashboard/visit/shop_visit_detail.dart';

class MyShopVisitPage extends StatefulWidget {
  const MyShopVisitPage({super.key, this.user});
  final UserModel? user;

  @override
  State<MyShopVisitPage> createState() => _MyShopVisitPageState();
}

class _MyShopVisitPageState extends State<MyShopVisitPage> {
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

      // previousNotificationList.sort((a, b) {
      //   final aDate = dateFormat.parse(a.svDate!);
      //   final bDate = dateFormat.parse(b.svDate!);
      //   return bDate.compareTo(aDate);
      // });

      return (today: todayNotificationList, previous: previousNotificationList);
    } catch (e) {
      return (today: [], previous: []);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'My Shop Visit',
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
            return ShopVisitItem(
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
            return ShopVisitItem(
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

class ShopVisitItem extends StatelessWidget {
  const ShopVisitItem({
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
            ShopVisitDetail(shopVisit: data, user: assignedTo),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      AppNavigator.pushTo(
                        context,
                        ShopVisitDetail(shopVisit: data, user: assignedTo),
                      );
                    },
                    child: Text('Details'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      AppNavigator.pushTo(
                        context,
                        EditShopVisit(shopVisit: data, user: assignedTo),
                      ).then((_) => onEdit?.call());
                    },
                    child: Text('Edit'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
