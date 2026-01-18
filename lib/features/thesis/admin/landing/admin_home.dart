import 'package:flutter/material.dart';
import 'package:workspace/core/components/app_bar.dart';
import 'package:workspace/features/thesis/admin/widget/home_report.dart';
import 'package:workspace/features/thesis/dashboard/model/task_model.dart';
import 'package:workspace/features/thesis/admin/service/home_task_service.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

//['Daily', 'Weekly', 'Monthly']
//['Pending', 'In Progress', 'Completed', 'Cancelled', 'Failed',]

class _AdminHomePageState extends State<AdminHomePage> {
  final HomeTaskService _service = HomeTaskService();
  List<TaskModel> tasks = [];
  //
  List<TaskModel> daily = [];
  List<TaskModel> weekly = [];
  List<TaskModel> monthly = [];
  //
  List<TaskModel> dailyFailed = [];
  List<TaskModel> dailyPending = [];
  List<TaskModel> dailyProgress = [];
  List<TaskModel> weeklyFailed = [];
  List<TaskModel> weeklyPending = [];
  List<TaskModel> weeklyProgress = [];
  List<TaskModel> monthlyFailed = [];
  List<TaskModel> monthlyPending = [];
  List<TaskModel> monthlyProgress = [];
  //
  int dailyFailedCount = 0;
  int dailyPendingCount = 0;
  int dailyProgressCount = 0;
  int weeklyFailedCount = 0;
  int weeklyPendingCount = 0;
  int weeklyProgressCount = 0;
  int monthlyFailedCount = 0;
  int monthlyPendingCount = 0;
  int monthlyProgressCount = 0;
  //
  Map<String, int> dailyRatio = {};
  Map<String, int> weeklyRatio = {};
  Map<String, int> monthlyRatio = {};

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  void _fetchTasks() async {
    tasks = await _service.getTasks();
    for (var task in tasks) {
      if (task.comments == 'Daily') {
        daily.add(task);
      } else if (task.comments == 'Weekly') {
        weekly.add(task);
      } else {
        monthly.add(task);
      }
    }
    for (var task in daily) {
      if (task.status == 'Failed') {
        dailyFailed.add(task);
      } else if (task.status == 'Pending') {
        dailyPending.add(task);
      } else {
        dailyProgress.add(task);
      }
    }
    for (var task in weekly) {
      if (task.status == 'Failed') {
        weeklyFailed.add(task);
      } else if (task.status == 'Pending') {
        weeklyPending.add(task);
      } else {
        weeklyProgress.add(task);
      }
    }

    for (var task in monthly) {
      if (task.status == 'Failed') {
        monthlyFailed.add(task);
      } else if (task.status == 'Pending') {
        monthlyPending.add(task);
      } else {
        monthlyProgress.add(task);
      }
    }
    dailyFailedCount = dailyFailed.length;
    dailyPendingCount = dailyPending.length;
    dailyProgressCount = dailyProgress.length;
    weeklyFailedCount = weeklyFailed.length;
    weeklyPendingCount = weeklyPending.length;
    weeklyProgressCount = weeklyProgress.length;
    monthlyFailedCount = monthlyFailed.length;
    monthlyPendingCount = monthlyPending.length;
    monthlyProgressCount = monthlyProgress.length;

    dailyRatio = _toRatioWithMin(
      dailyPendingCount,
      dailyProgressCount,
      dailyFailedCount,
    );

    weeklyRatio = _toRatioWithMin(
      weeklyPendingCount,
      weeklyProgressCount,
      weeklyFailedCount,
    );

    monthlyRatio = _toRatioWithMin(
      monthlyPendingCount,
      monthlyProgressCount,
      monthlyFailedCount,
    );

    setState(() {});
  }

  Map<String, int> _toRatioWithMin(int a, int b, int c) {
    const int minValue = 10;
    const int totalRatio = 100;

    final total = a + b + c;

    if (total == 0) {
      return {'a': minValue, 'b': minValue, 'c': totalRatio - (minValue * 2)};
    }

    // Convert raw counts into percentages
    double ra = (a / total) * 100;
    double rb = (b / total) * 100;
    double rc = (c / total) * 100;

    int ia = ra.round();
    int ib = rb.round();
    int ic = rc.round();

    // Ensure minimum 10%
    ia = ia < minValue ? minValue : ia;
    ib = ib < minValue ? minValue : ib;
    ic = ic < minValue ? minValue : ic;

    // Fix total sum
    int sum = ia + ib + ic;

    if (sum != totalRatio) {
      int diff = sum - totalRatio;

      // Reduce the largest bucket first
      if (diff > 0) {
        // Too high → decrease the largest
        if (ia >= ib && ia >= ic && ia - diff >= minValue) {
          ia -= diff;
        } else if (ib >= ia && ib >= ic && ib - diff >= minValue) {
          ib -= diff;
        } else if (ic - diff >= minValue) {
          ic -= diff;
        }
      } else {
        // Too low → increase the smallest
        diff = diff.abs();
        if (ia <= ib && ia <= ic) {
          ia += diff;
        } else if (ib <= ia && ib <= ic) {
          ib += diff;
        } else {
          ic += diff;
        }
      }
    }

    return {'a': ia, 'b': ib, 'c': ic};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminAppBar(title: 'WorkSync', hasBackButton: false),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          DailyReport(
            title: 'Daily',
            pendingCount: dailyRatio['a'] ?? 30,
            progressCount: dailyRatio['b'] ?? 40,
            completeCount: dailyRatio['c'] ?? 30,
            timeList: [9.5, 8.7, 9.0, 9.2, 9.5, 8.9, 9.3, 9.1, 8.8, 9.4],
          ),
          DailyReport(
            title: 'Weekly',
            pendingCount: weeklyRatio['a'] ?? 30,
            progressCount: weeklyRatio['b'] ?? 40,
            completeCount: weeklyRatio['c'] ?? 30,
            timeList: [9.0, 9.2, 8.5, 8.7, 9.3, 9.1, 9.5, 8.9, 8.8, 9.4],
          ),
          DailyReport(
            title: 'Monthly',
            pendingCount: monthlyRatio['a'] ?? 30,
            progressCount: monthlyRatio['b'] ?? 40,
            completeCount: monthlyRatio['c'] ?? 30,
            timeList: [9.1, 8.8, 9.4, 8.5, 9.0, 8.7, 9.2, 9.5, 8.9, 8.5],
          ),
        ],
      ),
    );
  }
}
