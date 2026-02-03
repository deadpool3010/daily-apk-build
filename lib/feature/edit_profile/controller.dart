import 'package:bandhucare_new/core/api/api_constant.dart';
import 'package:bandhucare_new/core/export_file/app_exports.dart';
import 'package:bandhucare_new/model/city_model.dart';
import 'package:bandhucare_new/model/patientModel.dart';
import 'package:get/get.dart';
import 'package:bandhucare_new/core/api/api_services.dart';
import 'package:bandhucare_new/model/state_model.dart';
import 'package:bandhucare_new/core/controller/session_controller.dart';
import 'package:flutter/material.dart';

class EditProfileController extends GetxController {
  final SessionController sessionController = Get.find();

  RxList<StateModel> states = <StateModel>[].obs;
  RxList<CityModel> cities = <CityModel>[].obs;
  RxInt selectedStateIndex = (-1).obs;
  RxInt selectedCityIndex = (-1).obs;
  RxInt selecteState = 0.obs;
  RxInt selectedCity = 0.obs;

  late TextEditingController nameController;
  late TextEditingController stateController;
  late TextEditingController cityController;
  late TextEditingController addressController;
  late TextEditingController genderController;
  final Map<String, String> changes = {};
  RxBool isChanged = false.obs;

  // List<Map<String,String>>StateCodeMapping=[{
  //  'Gujarat':''
  // }];

  @override
  void onInit() {
    nameController = TextEditingController(
      text: sessionController.user?.name ?? 'NA',
    );

    stateController = TextEditingController(
      text: sessionController.user?.state ?? 'NA',
    );

    cityController = TextEditingController(
      text: sessionController.user?.city ?? 'NA',
    );

    addressController = TextEditingController(
      text: sessionController.user?.address ?? 'NA',
    );

    genderController = TextEditingController(
      text: sessionController.user?.gender ?? 'NA',
    );

    super.onInit();
    check();
    loadAllState();
  }

  Future<void> loadAllState() async {
    final data = await getAllStatesApi();
    states.assignAll(data);
    setInitialState();
  }

  void setInitialState() {
    final userState = sessionController.user?.state;

    final index = states.indexWhere((e) => e.name == userState);

    if (index != -1) {
      selectedStateIndex.value = index;
    }
  }

  void check() {
    print(sessionController.user?.name);

    print(sessionController.user?.state);
  }

  Future<void> loadCity(String stateCode) async {
    final data = await getAllCitiesApi(stateCode);
    cities.assignAll(data);
  }

  void updateChanges() {
    if (!changes.isEmpty) {
      updateProfileApi(
        name: changes['name'],
        city: changes['city'],
        gender: changes['gender'],
        state: changes['state'],
        houseAddress: changes['address'],
      );
    } else {
      Fluttertoast.showToast(msg: 'Nothing To change here');
    }
  }

  //if there is no data
}
