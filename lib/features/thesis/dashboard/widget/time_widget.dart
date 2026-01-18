import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:workspace/core/utils/app_colors.dart';
import 'package:workspace/core/utils/app_styles.dart';
import 'package:workspace/core/components/app_text.dart';
import 'package:workspace/features/thesis/home/cubit/home_cubit.dart';
import 'package:workspace/features/thesis/dashboard/widget/dashboard_map.dart';

class TimeWidget extends StatelessWidget {
  const TimeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Positioned(
          top: 170,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: DottedBorder(
              options: const RoundedRectDottedBorderOptions(
                color: AppColors.yellow,
                radius: Radius.circular(20),
                padding: EdgeInsets.zero,
              ),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CommonText(
                      state.time ?? '',
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                    Text(state.date ?? '', style: AppStyles.mediumGrey12),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: DashboardMapWidget(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
