import 'package:bandhucare_new/core/api/api_services.dart';
import 'package:bandhucare_new/core/constants/variables.dart';
import 'package:bandhucare_new/core/services/shared_pref_localization.dart';
import 'package:bandhucare_new/model/hospital_model.dart';
import 'package:get/get.dart';

class HospitalController extends GetxController {
  final Rx<HospitalModel> hospital = HospitalModel().obs;
  String? languageCode;
  String? currentLat;
  String? currentLng;
  String? destinationLat;
  String? destinationLng;

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

      // Safely convert latitude and longitude to double
      // Handle both double and string types from API
      final latValue = response['latitude'];
      final lngValue = response['longitude'];

      destLat = latValue is double
          ? latValue
          : (latValue is String ? double.parse(latValue) : null);
      destLong = lngValue is double
          ? lngValue
          : (lngValue is String ? double.parse(lngValue) : null);

      print('destLat: $destLat');
      print('destLong: $destLong');
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }
}
