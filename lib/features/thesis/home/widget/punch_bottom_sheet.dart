import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:action_slider/action_slider.dart';
import 'package:workspace/core/utils/app_colors.dart';
import 'package:workspace/core/utils/app_images.dart';
import 'package:workspace/core/components/app_text.dart';
import 'package:workspace/core/components/app_snack_bar.dart';
import 'package:workspace/core/service/location_service.dart';
import 'package:workspace/features/thesis/auth/cubit/auth_cubit.dart';
import 'package:workspace/features/thesis/home/cubit/home_cubit.dart';
import 'package:workspace/features/thesis/history/service/attendance_service.dart';

class BottomSheetWidget extends StatelessWidget {
  BottomSheetWidget({super.key});
  final AttendanceService _attendanceService = AttendanceService();
  final LocationService _locationService = LocationService();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return SafeArea(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: ActionSlider.standard(
              width: MediaQuery.of(context).size.width,
              sliderBehavior: SliderBehavior.move,
              backgroundColor: AppColors.primary,
              toggleColor: Colors.white,
              boxShadow: const [],
              icon: SvgPicture.asset(AppImages.arrow),
              action: (controller) {
                _createAttendance(
                  state: state,
                  context: context,
                  controller: controller,
                );
              },
              child: Center(
                child: CommonText(
                  state.punchedIn == true
                      ? '   Swipe Left to Punch Out'
                      : '   Swipe Right to Punch In',
                  color: AppColors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _createAttendance({
    required HomeState state,
    required BuildContext context,
    required ActionSliderController controller,
  }) async {
    controller.loading();
    final location = await _locationService.getMyLocation();
    if (!context.mounted) return;
    final user = context.read<AuthCubit>().state.user;
    if (location?.latitude == null || location?.longitude == null) {
      controller.failure();
      controller.reset();
      Navigator.pop(context);
      AppSnackBar.show(context, 'Please enable location service');
      return;
    }
    final isPunchIn = state.punchedIn ?? false;
    final result = await _attendanceService.createAttendance(
      isPunchIn: !isPunchIn,
      assignTo: user?.id ?? '',
      address: location?.fullAddress ?? '',
      latitude: location?.latitude?.toString() ?? '',
      longitude: location?.longitude?.toString() ?? '',
    );
    result.fold(
      (l) {
        controller.failure();
        controller.reset();
        Navigator.pop(context);
        AppSnackBar.show(context, l);
      },
      (r) {
        controller.success();
        controller.reset();
        context.read<HomeCubit>().punch(!isPunchIn);
        Navigator.pop(context);
        AppSnackBar.show(context, r);
      },
    );
  }
}
