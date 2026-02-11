import 'dart:io';

import 'package:bandhucare_new/core/api/api_constant.dart';
import 'package:bandhucare_new/core/export_file/app_exports.dart';
import 'package:image_picker/image_picker.dart';
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
  final formKey = GlobalKey<FormState>();
  RxBool isChanged = false.obs;
  final ImagePicker _imagePicker = ImagePicker();
  final Rx<File?> selectedImage = Rx<File?>(null);
  final List<String> genderList = ['Male', 'Female', 'Other'];
  RxInt selectedGenderIndex = (-1).obs;

  // List<Map<String,String>>StateCodeMapping=[{
  //  'Gujarat':''
  // }];

  @override
  void onInit() {
    super.onInit();
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
    selectedGenderIndex.value = genderList.indexOf(
      sessionController.user?.gender ?? 'NA',
    );
    check();
    loadAllState().then((_) {
      if (selectedStateIndex.value != -1) {
        final stateCode = states[selectedStateIndex.value].code;
        loadCity(stateCode!);
      }
    });
  }

  @override
  void onClose() {
    nameController.dispose();
    stateController.dispose();
    cityController.dispose();
    addressController.dispose();
    genderController.dispose();
    super.onClose();
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

  void setInitialCity() {
    final userCity = sessionController.user?.city;
    print('User City :$userCity');
    final index = cities.indexWhere((e) => e.name == userCity);
    if (index != -1) {
      selectedCityIndex.value = index;
      print('Selected City Index :$selectedCityIndex');
    }
  }

  void check() {
    print(sessionController.user?.name);

    print(sessionController.user?.state);
  }

  Future<void> loadCity(String stateCode) async {
    final data = await getAllCitiesApi(stateCode);
    cities.assignAll(data);
    setInitialCity();
  }

  Future<void> pickProfileImage(ImageSource source) async {
    try {
      final XFile? xFile = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 512,
        maxHeight: 512,
      );
      if (xFile != null) {
        selectedImage.value = File(xFile.path);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to pick image');
    }
  }

  void collectChanges() {
    changes.clear();
    final compare = sessionController.user;

    if (compare?.name.trim() != nameController.text.trim()) {
      changes['name'] = nameController.text.trim();
    }
    if (compare?.gender?.trim() != genderController.text.trim()) {
      changes['gender'] = genderController.text.trim();
    }
    if (compare?.state?.trim() != stateController.text.trim()) {
      changes['state'] = stateController.text.trim();
    }
    if (compare?.city?.trim() != cityController.text.trim()) {
      changes['city'] = cityController.text.trim();
    }
    if (compare?.address?.trim() != addressController.text.trim()) {
      changes['address'] = addressController.text.trim();
    }
    print('Changes :$changes');
  }

  Future<void> updateChanges() async {
    collectChanges();
    print('Changes :$changes');
    final hasImageChange = selectedImage.value != null;
    if (hasImageChange) {
      print('Update Profile - Image selected: ${selectedImage.value?.path}');
    }
    if (changes.isNotEmpty || hasImageChange) {
      try {
        final result = await updateProfileApi(
          name: changes['name'],
          city: changes['city'],
          gender: changes['gender'],
          state: changes['state'],
          houseAddress: changes['address'],
          image: selectedImage.value,
        );
        final profile =
            result['data']?['profile'] ??
            result['data']?['profileDetails'] ??
            result['data'];
        if (profile != null && profile is Map<String, dynamic>) {
          // Merge our sent changes over the response - backend may return stale data
          final merged = Map<String, dynamic>.from(profile);
          if (changes['name'] != null) merged['name'] = changes['name'];
          if (changes['address'] != null)
            merged['address'] = changes['address'];
          if (changes['gender'] != null) merged['gender'] = changes['gender'];
          if (changes['state'] != null) merged['stateName'] = changes['state'];
          if (changes['city'] != null)
            merged['subdistrictName'] = changes['city'];
          await sessionController.updateUserFromProfile(merged);
          if (hasImageChange) selectedImage.value = null;
          Fluttertoast.showToast(msg: "Profile updated successfully");
        }
      } catch (_) {
        // Toast/error already shown by updateProfileApi
      }
    } else {
      Fluttertoast.showToast(msg: 'Nothing to change here');
    }
  }

  //if there is no data
}
