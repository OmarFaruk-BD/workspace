import 'package:flutter/material.dart';

class AppBottomSheet {
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget widget,
  }) async {
    return await showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => widget,
    );
  }
}

class DatePickerBottomSheet extends StatelessWidget {
  const DatePickerBottomSheet({super.key, this.initialDate});
  final DateTime? initialDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Select Date',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        CalendarDatePicker(
          initialDate: initialDate,
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
          onDateChanged: (date) => Navigator.pop(context, date),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, initialDate),
                child: const Text('Confirm'),
              ),
            ],
          ),
        ),
        SizedBox(height: MediaQuery.of(context).padding.bottom),
      ],
    );
  }
}
