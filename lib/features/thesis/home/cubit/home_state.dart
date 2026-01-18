part of 'home_cubit.dart';

class HomeState {
  const HomeState({
    this.time,
    this.date,
    this.punchedIn,
    this.myArea,
    this.address,
  });

  final String? time;
  final String? date;
  final bool? punchedIn;
  final MyAreaModel? myArea;
  final String? address;

  HomeState copyWith({
    String? time,
    String? date,
    bool? punchedIn,
    MyAreaModel? myArea,
    String? address,
  }) {
    return HomeState(
      time: time ?? this.time,
      date: date ?? this.date,
      myArea: myArea ?? this.myArea,
      punchedIn: punchedIn ?? this.punchedIn,
      address: address ?? this.address,
    );
  }
}

class HomeInitial extends HomeState {}
