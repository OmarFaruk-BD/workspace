import 'package:flutter/material.dart';
import 'package:workspace/core/components/app_bar.dart';

class AdminEmployeePage extends StatefulWidget {
  const AdminEmployeePage({super.key});

  @override
  State<AdminEmployeePage> createState() => _AdminEmployeePageState();
}

class _AdminEmployeePageState extends State<AdminEmployeePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminAppBar(title: 'Employee Page', hasBackButton: false),
      body: Center(child: Text('Admin Employee Page')),
    );
  }
}
