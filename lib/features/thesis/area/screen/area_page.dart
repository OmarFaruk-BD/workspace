import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:workspace/core/utils/app_colors.dart';
import 'package:workspace/core/utils/app_images.dart';
import 'package:workspace/core/components/app_bar.dart';
import 'package:workspace/core/components/app_button.dart';
import 'package:workspace/core/components/app_snack_bar.dart';
import 'package:workspace/core/service/app_permission_service.dart';
import 'package:workspace/features/thesis/home/cubit/home_cubit.dart';
import 'package:workspace/features/thesis/area/screen/map_widget.dart';
import 'package:workspace/features/thesis/home/widget/duty_location.dart';
import 'package:workspace/features/thesis/home/widget/punch_bottom_sheet.dart';

class AreaPage extends StatefulWidget {
  const AreaPage({super.key});

  @override
  State<AreaPage> createState() => _AreaPageState();
}

class _AreaPageState extends State<AreaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Area', hasBackButton: false),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Center(
                child: Text(
                  state.time ?? '',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                state.date ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(),
              DottedBorder(
                options: const RoundedRectDottedBorderOptions(
                  strokeWidth: 1,
                  strokeCap: StrokeCap.round,
                  color: AppColors.green,
                  radius: Radius.circular(15),
                  padding: EdgeInsets.all(10),
                ),
                child: Text.rich(
                  TextSpan(
                    text: '',
                    children: [
                      WidgetSpan(
                        child: Image.asset(
                          AppImages.alert,
                          width: 40,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      const TextSpan(
                        text: 'Alert: ',
                        style: TextStyle(fontSize: 16, color: AppColors.red),
                      ),
                      const TextSpan(
                        text: 'Don\'t Cross Your Area',
                        style: TextStyle(fontSize: 16, color: AppColors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              MapWidget(
                lat: double.tryParse(state.myArea?.latitude ?? ''),
                lng: double.tryParse(state.myArea?.longitude ?? ''),
                radius: double.tryParse(state.myArea?.radius ?? ''),
              ),
              const Spacer(),
              BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  return state.punchedIn != true
                      ? Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24),
                              child: DutyLocation(),
                            ),
                            const SizedBox(height: 15),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              child: AppButton(
                                text: 'Start Visit',
                                buttonColor: Colors.white,
                                textColor: AppColors.red,
                                onTap: () => _punch(context),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox();
                },
              ),
              BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  return state.punchedIn == true
                      ? const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: DutyLocation(),
                        )
                      : const SizedBox();
                },
              ),
              const Spacer(),
            ],
          );
        },
      ),
    );
  }

  void _punch(BuildContext context) async {
    final service = await AppPermissionService().locationPermission(context);
    if (!context.mounted) return;

    if (service != true) {
      AppSnackBar.show(context, 'Please enable location service');
      return;
    }

    final permission = await AppPermissionService().locationPermission(context);
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
