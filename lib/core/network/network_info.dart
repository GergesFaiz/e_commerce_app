import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;
  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    final dynamic result = await connectivity.checkConnectivity();
    // connectivity_plus 5.x returns ConnectivityResult,
    // 6.x+ returns List<ConnectivityResult>. Support both.
    if (result is List<ConnectivityResult>) {
      return !result.contains(ConnectivityResult.none);
    }
    return (result as ConnectivityResult) != ConnectivityResult.none;
  }
}
