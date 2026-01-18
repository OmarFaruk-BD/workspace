
import 'package:bloc/bloc.dart';
import 'package:workspace/features/thesis/dashboard/model/leave_request_model.dart';
import 'package:workspace/features/thesis/dashboard/service/leave_service.dart';

part 'leave_state.dart';

class LeaveCubit extends Cubit<LeaveState> {
  LeaveCubit() : super(LeaveInitial());

  void getLeaveList({DateTime? startDate, DateTime? endDate}) async {
    emit(state.copyWith(isLoading: true));
    final leaveList = await LeaveService().getLeaveList(
      startDate: startDate,
      endDate: endDate,
    );
    emit(state.copyWith(leaveListModel: leaveList, isLoading: false));
  }
}
