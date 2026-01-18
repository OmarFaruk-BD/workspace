import 'package:flutter/material.dart';
import 'package:workspace/core/utils/app_colors.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({super.key, required this.text, required this.onTap});

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Text(
              text,
              style: TextStyle(
                color: AppColors.admin,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 10),
            Icon(Icons.arrow_forward_ios, size: 18, color: AppColors.admin),
          ],
        ),
      ),
    );
  }
}

class SectionWidget extends StatelessWidget {
  const SectionWidget({super.key, required this.children, required this.title});
  final List<Widget> children;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(horizontal: 25).copyWith(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            blurRadius: 5,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 15),
          ...children,
        ],
      ),
    );
  }
}
