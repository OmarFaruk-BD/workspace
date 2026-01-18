import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workspace/core/utils/app_colors.dart';
import 'package:workspace/core/utils/app_images.dart';
import 'package:workspace/core/utils/app_styles.dart';
import 'package:workspace/core/components/app_text.dart';
import 'package:workspace/core/components/app_snack_bar.dart';
import 'package:workspace/core/service/permission_service.dart';
import 'package:workspace/features/thesis/home/cubit/home_cubit.dart';
import 'package:workspace/features/thesis/home/widget/duty_location.dart';
import 'package:workspace/features/thesis/home/widget/punch_bottom_sheet.dart';

class PunchButton extends StatelessWidget {
  const PunchButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Positioned(
          top: 170,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 25),
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 25),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.yellow),
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
                  InkWell(
                    onTap: () => _punch(context),
                    child: Image.asset(
                      state.punchedIn == true
                          ? AppImages.punchOutPNG
                          : AppImages.punchInPNG,
                      width: 230,
                      height: 230,
                    ),
                  ),
                  if (state.punchedIn == true) ...[
                    SizedBox(height: 25),
                    DutyLocation(),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _punch(BuildContext context) async {
    final service = await PermissionService().locationPermission(context);
    if (!context.mounted) return;

    if (service != true) {
      AppSnackBar.show(context, 'Please enable location service');
      return;
    }

    final permission = await PermissionService().locationPermission(context);
    if (!context.mounted) return;
    if (permission != true) {
      AppSnackBar.show(context, 'Please enable location permission');
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => BottomSheetWidget(),
    );
  }
}
