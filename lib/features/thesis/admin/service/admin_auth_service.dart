import 'package:fpdart/fpdart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:workspace/features/thesis/auth/model/user_model.dart';
import 'package:workspace/features/thesis/admin/service/employee_service.dart';

class AdminAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final EmployeeService _employeeService = EmployeeService();

  Future<Either<String, UserModel>> signIn(
    String email,
    String password,
  ) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      UserModel? user = await _employeeService.getEmployeeDetail(
        result.user?.uid ?? '',
      );
      if (user == null) {
        return left('No user found for that email.');
      }
      return right(user);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return left('No user found for that email.');
        case 'wrong-password':
          return left('Wrong password provided.');
        case 'invalid-email':
          return left('The email address is not valid.');
        default:
          return left('Login failed: ${e.message}');
      }
    } catch (e) {
      return left('Something went wrong.');
    }
  }

  Future<UserModel?> getCurrentUser() async {
    User? result = _auth.currentUser;
    if (result == null) return null;
    final user = await _employeeService.getEmployeeDetail(result.uid);
    return user;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
