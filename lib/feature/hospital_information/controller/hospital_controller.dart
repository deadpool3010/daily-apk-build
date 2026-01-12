import 'package:bandhucare_new/core/api/api_services.dart';
import 'package:bandhucare_new/core/services/shared_pref_localization.dart';
import 'package:bandhucare_new/model/hospital_model.dart';
import 'package:get/get.dart';

class HospitalController extends GetxController {
  final Rx<HospitalModel> hospital = HospitalModel().obs;
  String? languageCode;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    _initializeAndLoad();
  }

  void _initializeAndLoad() async {
    final prefs = SharedPrefLocalization();
    final savedLocale = await prefs.getAppLocale();
    languageCode = (savedLocale.isNotEmpty ? savedLocale : 'en_US')
        .toLowerCase();
    loadHospitalInformation();
  }

  void loadHospitalInformation() async {
    try {
      final response = await _getHospitalInformation();
      if (response.isNotEmpty) {
        hospital.value = HospitalModel.fromJson(response);
      } else {
        throw Exception('No hospital information found');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Map<String, dynamic>> _getHospitalInformation() async {
    try {
      final response = await getHospitalInformationApi(languageCode!);
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }
}
