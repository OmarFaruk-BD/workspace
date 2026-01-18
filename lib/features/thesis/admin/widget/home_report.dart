import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:workspace/core/utils/app_colors.dart';

class DailyReport extends StatelessWidget {
  const DailyReport({
    super.key,
    required this.title,
    required this.timeList,
    required this.pendingCount,
    required this.progressCount,
    required this.completeCount,
  });
  final String title;
  final int pendingCount;
  final int progressCount;
  final int completeCount;
  final List<double> timeList;

  List<FlSpot> get getSpots {
    final List<FlSpot> list = [];
    for (int i = 0; i < timeList.length; i++) {
      list.add(FlSpot(i.toDouble(), timeList[i]));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.only(bottom: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            offset: const Offset(0, 2),
            color: Colors.grey.shade200,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              '$title Report',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(height: 10),
          Text(
            '$title Attendance Report',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 10),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.4,
            child: Row(
              children: [
                Expanded(
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: true),
                      titlesData: FlTitlesData(
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 50,
                            interval: 0.5,
                            getTitlesWidget: (value, meta) {
                              final timeLabels = {
                                8.0: '8:00 AM',
                                8.5: '8:30 AM',
                                9.0: '9:00 AM',
                                9.5: '9:30 AM',
                                10.0: '10:00 AM',
                              };
                              return Text(
                                timeLabels[value] ?? '',
                                style: const TextStyle(fontSize: 10),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            getTitlesWidget: (value, meta) => Text(
                              '${value.toInt() + 1}',
                              style: const TextStyle(fontSize: 10),
                            ),
                          ),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: const Border(
                          left: BorderSide(),
                          bottom: BorderSide(),
                        ),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          barWidth: 2,
                          isCurved: true,
                          color: Colors.blue,
                          dotData: FlDotData(show: true),
                          spots: getSpots,
                          // spots: const [
                          //   FlSpot(0, 8.5),
                          //   FlSpot(1, 8.7),
                          //   FlSpot(2, 9.0),
                          //   FlSpot(3, 9.2),
                          //   FlSpot(4, 9.5),
                          //   FlSpot(5, 8.9),
                          //   FlSpot(6, 9.3),
                          //   FlSpot(7, 9.1),
                          //   FlSpot(8, 8.8),
                          //   FlSpot(9, 9.4),
                          // ],
                        ),
                      ],
                      minY: 8.0,
                      maxY: 10.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 25),
          Text(
            '$title Task Completion',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 10),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.5,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: PieChart(
                          PieChartData(
                            sections: [
                              PieChartSectionData(
                                color: Colors.green,
                                value: 20,
                                title: '20%',
                                radius: 50,
                              ),
                              PieChartSectionData(
                                color: AppColors.primary,
                                value: 60,
                                title: '60%',
                                radius: 50,
                              ),
                              PieChartSectionData(
                                color: AppColors.secondary,
                                value: 20,
                                title: '20%',
                                radius: 50,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          ColorItem(title: 'Completed', color: Colors.green),
                          ColorItem(title: 'Pending', color: AppColors.primary),
                          ColorItem(
                            title: 'Failed',
                            color: AppColors.secondary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ColorItem extends StatelessWidget {
  const ColorItem({super.key, required this.title, required this.color});
  final Color color;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(height: 8, width: 8, color: color),
        SizedBox(width: 5),
        Text(title, style: TextStyle(fontSize: 10)),
        SizedBox(width: 15),
      ],
    );
  }
}
