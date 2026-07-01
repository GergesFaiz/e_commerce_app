import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;
  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    // In connectivity_plus 5.x it returns ConnectivityResult, in 6.x it returns List<ConnectivityResult>
    // Based on the error, it seems to be returning a single ConnectivityResult here.
    return result != ConnectivityResult.none;
  }
}
