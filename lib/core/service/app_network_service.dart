import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class AppNetworkService {
  final Connectivity _connectivity = Connectivity();

  Future<bool> hasConnection() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    return !connectivityResult.contains(ConnectivityResult.none);
  }

  Future<bool> hasInternetAccess([String host = 'google.com']) async {
    try {
      final result = await InternetAddress.lookup(host);
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<String?> message() async {
    if (!await hasConnection()) {
      return 'Device is not connected to any network.';
    }
    if (!await hasInternetAccess()) {
      return 'Connected to a network, but no internet access.';
    }
    return null;
  }
}
