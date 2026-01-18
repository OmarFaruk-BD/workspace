part of 'leave_cubit.dart';

class LeaveState {
  const LeaveState({this.leaveListModel, this.isLoading});
  final bool? isLoading;
  final LeaveListModel? leaveListModel;

  LeaveState copyWith({bool? isLoading, LeaveListModel? leaveListModel}) {
    return LeaveState(
      isLoading: isLoading ?? this.isLoading,
      leaveListModel: leaveListModel ?? this.leaveListModel,
    );
  }
}

class LeaveInitial extends LeaveState {}
