import 'package:logger/logger.dart';
import 'package:fpdart/fpdart.dart';
import 'package:workspace/core/api/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workspace/features/thesis/auth/model/registration_model.dart';
import 'package:workspace/features/thesis/auth/model/user_model.dart';

class AuthService {
  Future<Either<String, RegistrationModel>> register(
    Map<String, dynamic> body,
  ) async {
    try {
      ApiResponse response = await ApiClient().post(
        path: 'Endpoints.register',
        withToken: false,
        data: body,
      );
      Logger().e(body);
      Logger().e(response.response?.data);
      response.print();

      if (response.statusCode == 200 && response.response?.data != null) {
        RegistrationModel responseModel = RegistrationModel.fromMap(
          response.response?.data,
        );
        _saveData(
          password: body['password'] ?? '',
          email: responseModel.user?.email ?? '',
          token: responseModel.accessToken ?? '',
        );
        return right(responseModel);
      } else {
        return left(response.message());
      }
    } catch (e) {
      Logger().e(e);
      return left('Something went wrong.');
    }
  }

  Future<Either<String, String>> verifyOTP(String? otpCode) async {
    try {
      var body = {'code': otpCode};
      ApiResponse response = await ApiClient().post(
        path: 'Endpoints.verifyEmail',
        data: body,
      );
      Logger().e(body);
      response.print();

      return response.fold((f) => left(f.message()), (s) => right(s.message()));
    } catch (e) {
      return left('Something went wrong.');
    }
  }

  Future<Either<String, String>> resendOTP() async {
    try {
      ApiResponse response = await ApiClient().post(
        path: 'Endpoints.resendCode',
      );
      response.print();

      return response.fold((f) => left(f.message()), (s) => right(s.message()));
    } catch (e) {
      return left('Something went wrong.');
    }
  }

  Future<Either<String, RegistrationModel>> login({
    String? email,
    String? password,
  }) async {
    try {
      final Map<String, dynamic> body = {'email': email, 'password': password};
      final ApiResponse response = await ApiClient().post(
        path: 'Endpoints.login',
        data: body,
      );
      response.print();
      if (response.statusCode == 200 && response.response?.data != null) {
        RegistrationModel responseModel = RegistrationModel.fromMap(
          response.response?.data,
        );
        await _saveData(
          email: email ?? '',
          password: password ?? '',
          token: responseModel.accessToken ?? '',
        );
        return right(responseModel);
      } else {
        return left(response.message());
      }
    } catch (e) {
      Logger().e(e);
      return left('Something went wrong.');
    }
  }

  Future<Either<String, UserModel>> getUserDetail() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? email = prefs.getString('email');
      String? password = prefs.getString('password');

      final loginResult = await login(email: email, password: password);

      return loginResult.fold((l) => left(l), (registration) {
        UserModel? user = registration.user;
        if (user != null) {
          return right(user);
        } else {
          return left('Failed to get user details');
        }
      });
    } catch (e) {
      Logger().e(e);
      return left('Something went wrong.');
    }
  }

  Future<UserModel?> getUserProfile() async {
    try {
      final response = await ApiClient().get(path: 'Endpoints.profile');
      response.print();
      UserModel? user = UserModel.fromMap(response.data['data']);
      return user;
    } catch (e) {
      Logger().e(e);
      return null;
    }
  }

  Future<Either<String, String>> resetPassword(String email) async {
    try {
      var body = {'email': email};
      ApiResponse response = await ApiClient().post(
        path: 'Endpoints.resetPassword',
        data: body,
      );
      Logger().e(body);
      response.print();
      return response.fold((f) => left(f.message()), (s) => right(s.message()));
    } catch (e) {
      return left('Something went wrong.');
    }
  }

  Future<Either<String, String>> validateOTP({
    String? email,
    String? otpCode,
  }) async {
    try {
      var body = {'code': otpCode, 'email': email};
      ApiResponse response = await ApiClient().post(
        path: 'Endpoints.validateOTP',
        data: body,
      );
      Logger().e(body);
      response.print();
      return response.fold((f) => left(f.message()), (s) => right(s.message()));
    } catch (e) {
      return left('Something went wrong.');
    }
  }

  Future<Either<String, String>> changePassword({
    String? email,
    String? password,
  }) async {
    try {
      var body = {'email': email, 'password': password};
      ApiResponse response = await ApiClient().post(
        path: 'Endpoints.changePassword',
        data: body,
      );
      Logger().e(body);
      response.print();
      return response.fold((f) => left(f.message()), (s) => right(s.message()));
    } catch (e) {
      return left('Something went wrong.');
    }
  }

  Future<void> _saveData({
    required String token,
    required String email,
    required String password,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('email', email);
    await prefs.setString('password', password);
  }

  Future<void> removeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('email');
    await prefs.remove('password');
  }
}
