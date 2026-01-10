import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkService {
  // define controller for check connectivity

  final _controller = StreamController<bool>.broadcast();
  // broadcaast means we will get the data from the controller to all the listeners
  Stream<bool> get onStatusChange => _controller.stream;
  NetworkService() {
    Connectivity().onConnectivityChanged.listen((result) {
      // connectivity_plus v7+ returns List<ConnectivityResult>
      _controller.add(!result.contains(ConnectivityResult.none));
    });
  }
  Future<bool> checkNow() async {
    final result = await Connectivity().checkConnectivity();
    // connectivity_plus v7+ returns List<ConnectivityResult>
    final hasInternet = !result.contains(ConnectivityResult.none);
    _controller.add(hasInternet);
    return hasInternet;
  }
}
