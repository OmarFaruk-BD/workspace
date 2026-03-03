import 'package:dio/dio.dart';
import 'package:workspace/core/service/app_network_service.dart';

class ApiException {
  final AppNetworkService _networkService = AppNetworkService();

  Future<String> message(DioException exception) async {
    final hasNetworkError =
        exception.type == DioExceptionType.connectionTimeout ||
        exception.type == DioExceptionType.receiveTimeout ||
        exception.type == DioExceptionType.sendTimeout ||
        exception.type == DioExceptionType.connectionError;

    if (hasNetworkError) {
      final networkMessage = await _networkService.message();
      if (networkMessage != null) return networkMessage;
    }

    switch (exception.type) {
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout with the server.';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout in connection with the server.';
      case DioExceptionType.sendTimeout:
        return 'Send timeout in connection with the server.';
      case DioExceptionType.connectionError:
        return 'Connection error occurred.';
      case DioExceptionType.badResponse:
        return 'Received invalid status code: ${exception.response?.statusCode ?? 'unknown'}';
      case DioExceptionType.badCertificate:
        return 'Bad certificate detected.';
      case DioExceptionType.unknown:
        return 'An unexpected error occurred: Status code: ${exception.response?.statusCode ?? 'unknown'}';
    }
  }
}
