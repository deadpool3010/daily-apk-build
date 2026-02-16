import 'package:bandhucare_new/core/network/service/network_service.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  final NetworkService _networkService = NetworkService();
  RxBool hasInternet = true.obs;
  RxBool isChecking = false.obs;

  @override
  void onInit() {
    super.onInit();
    _networkService.onStatusChange.listen((status) {
      hasInternet.value = status;
    });
  }

  Future<void> retry() async {
    isChecking.value = true;
    await _networkService.checkNow();
    isChecking.value = false;
  }
}
