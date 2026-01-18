import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workspace/core/utils/app_colors.dart';
import 'package:workspace/core/components/app_bar.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:workspace/features/thesis/dashboard/cubit/leave_cubit.dart';
import 'package:workspace/features/thesis/dashboard/widget/available_item.dart';

class LeaveRequestPage extends StatefulWidget {
  const LeaveRequestPage({super.key});

  @override
  State<LeaveRequestPage> createState() => _LeaveRequestPageState();
}

class _LeaveRequestPageState extends State<LeaveRequestPage> {
  @override
  void initState() {
    super.initState();
    _initDateList();
  }

  void _initDateList() {
    context.read<LeaveCubit>().getLeaveList(
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 6)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeaveCubit, LeaveState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AdminAppBar(
            title: 'Leave Request',
            onBackTap: () => Navigator.pop(context),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                SfDateRangePicker(
                  view: DateRangePickerView.month,
                  backgroundColor: AppColors.white,
                  todayHighlightColor: AppColors.red,
                  endRangeSelectionColor: AppColors.red,
                  startRangeSelectionColor: AppColors.red,
                  selectionMode: DateRangePickerSelectionMode.range,
                  rangeSelectionColor: AppColors.red.withAlpha(40),
                  headerStyle: DateRangePickerHeaderStyle(
                    backgroundColor: AppColors.white,
                  ),
                  monthViewSettings: DateRangePickerMonthViewSettings(
                    showTrailingAndLeadingDates: true,
                  ),
                  initialSelectedRange: PickerDateRange(
                    DateTime.now(),
                    DateTime.now().add(const Duration(days: 6)),
                  ),
                  onSelectionChanged: (dateRangePickerSelectionChangedArgs) {
                    if (dateRangePickerSelectionChangedArgs.value
                        is PickerDateRange) {
                      final PickerDateRange range =
                          dateRangePickerSelectionChangedArgs.value;
                      setState(() {
                        if (range.startDate != null && range.endDate != null) {
                          context.read<LeaveCubit>().getLeaveList(
                            startDate: range.startDate,
                            endDate: range.endDate,
                          );
                        }
                      });
                    }
                  },
                ),
                SizedBox(height: 25),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey.shade200,
                          border: Border(
                            bottom: BorderSide(
                              color: AppColors.green,
                              width: 4,
                            ),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Available : ${state.leaveListModel?.availableTotal ?? 0}',
                            style: TextStyle(color: AppColors.green),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey.shade200,
                        ),
                        child: Center(
                          child: Text(
                            'Taken : ${state.leaveListModel?.takenTotal ?? 0}',
                            style: TextStyle(color: AppColors.grey),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25),
                if (state.isLoading == true) CircularProgressIndicator(),
                if (state.leaveListModel?.days?.isNotEmpty == true)
                  ...List.generate(state.leaveListModel!.days!.length, (index) {
                    final data = state.leaveListModel!.days![index];
                    return AvailableItem(day: data);
                  }),
              ],
            ),
          ),
        );
      },
    );
  }
}
