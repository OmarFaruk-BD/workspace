import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:workspace/core/utils/app_colors.dart';
import 'package:workspace/core/utils/app_images.dart';
import 'package:workspace/core/components/app_bar.dart';
import 'package:workspace/core/components/app_text.dart';
import 'package:workspace/core/components/app_button.dart';
import 'package:workspace/core/components/app_snack_bar.dart';
import 'package:workspace/features/thesis/home/cubit/home_cubit.dart';
import 'package:workspace/core/service/permission_service.dart';
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
      appBar: CustomAppBar(title: 'Area', hasBackButton: false),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(),
              Center(
                child: CommonText(
                  state.time ?? '',
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  textAlign: TextAlign.center,
                ),
              ),
              CommonText(
                state.date ?? '',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                textAlign: TextAlign.center,
              ),
              Spacer(),
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
                      TextSpan(
                        text: 'Alert: ',
                        style: TextStyle(fontSize: 16, color: AppColors.red),
                      ),
                      TextSpan(
                        text: 'Don\'t Cross Your Area',
                        style: TextStyle(fontSize: 16, color: AppColors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
              MapWidget(
                lat: double.tryParse(state.myArea?.latitude ?? ''),
                lng: double.tryParse(state.myArea?.longitude ?? ''),
                radius: double.tryParse(state.myArea?.radius ?? ''),
              ),
              Spacer(),
              BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  return state.punchedIn != true
                      ? Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              child: DutyLocation(),
                            ),
                            SizedBox(height: 15),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              child: AppButton(
                                text: 'Start Visit',
                                btnColor: Colors.white,
                                textColor: AppColors.red,
                                onTap: () => _punch(context),
                              ),
                            ),
                          ],
                        )
                      : SizedBox();
                },
              ),
              BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  return state.punchedIn == true
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: DutyLocation(),
                        )
                      : SizedBox();
                },
              ),
              Spacer(),
            ],
          );
        },
      ),
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
