part of 'auth_cubit.dart';

class AuthState {
  AuthState({this.user});

  final UserModel? user;

  AuthState copyWith({UserModel? user}) {
    return AuthState(user: user ?? this.user);
  }
}

class AuthInitial extends AuthState {}
