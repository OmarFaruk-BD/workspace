import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workspace/core/helper/extention.dart';
import 'package:workspace/core/service/location_service.dart';
import 'package:workspace/features/thesis/auth/cubit/auth_cubit.dart';
import 'package:workspace/features/thesis/area/model/my_area_model.dart';
import 'package:workspace/features/thesis/history/service/attendance_service.dart';
import 'package:workspace/features/thesis/admin/service/e_attendance_service.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial()) {
    updateTime();
  }

  final LocationService _locationService = LocationService();
  final AttendanceService _attendanceService = AttendanceService();
  final EAssignLocationService _assignLocationService =
      EAssignLocationService();

  void updateTime() {
    Timer.periodic(const Duration(seconds: 1), (_) {
      emit(
        state.copyWith(
          time: DateTime.now().toDateString('hh:mm a'),
          date: DateTime.now().toDateString('dd MMMM yyyy, EEEE'),
        ),
      );
    });
  }

  void updateMyArea(BuildContext context) async {
    final user = context.read<AuthCubit>().state.user;
    final assignedTo = user?.id ?? '';
    final myAreaModel = await _assignLocationService
        .getAssignLocationByEmployee(assignedTo);

    emit(state.copyWith(myArea: myAreaModel));
    final lat = double.tryParse(myAreaModel?.latitude ?? '');
    final long = double.tryParse(myAreaModel?.longitude ?? '');
    if (lat != null && long != null) {
      final location = await _locationService.getLocationDetail(lat, long);
      emit(state.copyWith(address: location?.fullAddress));
    }
  }

  void checkPunchIn(BuildContext context) async {
    final user = context.read<AuthCubit>().state.user;
    final assignedTo = user?.id ?? '';
    final attendanceDetail = await _attendanceService
        .getTodayAttendanceEmployee(assignedTo);
    if (attendanceDetail?.punchIn != null &&
        attendanceDetail?.punchOut == null) {
      punch(true);
    }
  }

  void punch(bool isPunchIn) {
    emit(state.copyWith(punchedIn: isPunchIn));
  }
}
