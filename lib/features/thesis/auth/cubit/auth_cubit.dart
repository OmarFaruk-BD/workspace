import 'package:bloc/bloc.dart';
import 'package:workspace/features/thesis/auth/model/user_model.dart';
import 'package:workspace/features/thesis/admin/service/employee_service.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final EmployeeService _employeeService = EmployeeService();

  void updateUser(UserModel? user) {
    emit(state.copyWith(user: user));
  }

  void updateUserImage() async {
    final user = await _employeeService.getEmployeeWithImage(state.user?.id);
    emit(state.copyWith(user: state.user?.copyWith(imageUrl: user?.imageUrl)));
  }

  void signOut() {
    emit(AuthInitial());
  }
}
