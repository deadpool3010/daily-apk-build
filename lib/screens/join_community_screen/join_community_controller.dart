import 'package:bandhucare_new/constant/variables.dart';
import 'package:bandhucare_new/routes/routes.dart';
import 'package:bandhucare_new/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JoinCommunityController extends GetxController {
  final groupId = Get.arguments['groupId'];
  final communities = RxList<Map<String, dynamic>>();
  final isLoading = RxBool(false);
  final selectedCommunityIds = RxList<String>();
  final noCommunityMessage = RxString("");
  final isJoiningCommunity = RxBool(false);
  @override
  void onInit() {
    super.onInit();
    fetchCommunities();
  }

  Future<void> fetchCommunities() async {
    try {
      isLoading(true);

      final response = await getCommunity(groupId);
      print(response);
      print(groupId);
      if (response["success"] == true) {
        final data = response["data"];

        // CASE 1: data is a STRING (no communities)
        if (data is String) {
          communities.clear();
          noCommunityMessage.value = data; // <-- store "No communities found"
          return;
        }

        // CASE 2: data is a MAP
        if (data is Map<String, dynamic>) {
          final fetchedCommunities = data["communities"];

          if (fetchedCommunities is List) {
            communities.assignAll(
              fetchedCommunities
                  .whereType<Map>()
                  .map((item) => Map<String, dynamic>.from(item))
                  .toList(),
            );
            noCommunityMessage.value = ""; // reset message
          } else {
            communities.clear();
            noCommunityMessage.value = "No communities found";
          }

          return;
        }

        // CASE 3: Unexpected format
        communities.clear();
        noCommunityMessage.value = "No communities found";
        return;
      } else {
        communities.clear();
        noCommunityMessage.value = "Something went wrong";
      }
    } catch (e) {
      print("Error loading communities: $e");
      communities.clear();
      noCommunityMessage.value = "Failed to load communities";
    } finally {
      isLoading(false);
    }
  }

  void toggleSelection(String communityId) {
    if (communityId.isEmpty) return;
    if (selectedCommunityIds.contains(communityId)) {
      selectedCommunityIds.remove(communityId);
    } else {
      selectedCommunityIds.add(communityId);
    }
  }

  Future<void> joinSelectedCommunities() async {
    if (selectedCommunityIds.isEmpty) {
      Get.snackbar(
        'Select a community',
        'Please choose at least one community to continue.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    final ids = selectedCommunityIds.toList();

    try {
      isJoiningCommunity(true);
      print('');
      print('========================================');
      print('🚀 Initiating AddMeToCommunity API call');
      print('Selected Community IDs: $ids');
      print('Unique Code: $uniqueCode');
      print('========================================');
      final response = await addMeToCommunityApi(ids, uniqueCode);
      print('');
      print('========================================');
      print('✅ AddMeToCommunity API RESPONSE RECEIVED');
      print('Response: $response');
      accessToken = response['data']['accessToken'];
      refreshToken = response['data']['refreshToken'];
      print('========================================');

      final success = response['success'] == true;
      final message =
          response['message'] ??
          (success
              ? 'Successfully added to community!'
              : 'Failed to add to community.');

      Get.snackbar(
        success ? 'Success' : 'Failed',
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: success ? Colors.green : Colors.red,
        colorText: Colors.white,
      );

      if (success) {
        Get.offAllNamed(AppRoutes.homeScreen);
      }
    } catch (e) {
      var errorMessage = e.toString();
      if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.replaceFirst('Exception: ', '');
      }

      print('');
      print('========================================');
      print('❌ AddMeToCommunity API ERROR');
      print('Error: $errorMessage');
      print('========================================');

      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isJoiningCommunity(false);
    }
  }
}

// Future<void> _handleAddMeToCommunity() async {
//   if (accessToken.isEmpty) {
//     Fluttertoast.showToast(
//       msg: "Access token not found. Please try again.",
//       toastLength: Toast.LENGTH_SHORT,
//       backgroundColor: Colors.red,
//       textColor: Colors.white,
//     );
//     return;
//   }

//   setState(() {
//     isLoadingAddMeToCommunity = true;
//   });
//   // Sync with controller
//   final controller = Get.find<LoginController>();
//   controller.isLoadingAddMeToCommunity.value = true;

//   try {
//     final result = await addMeToCommunityApi();
//     print('');
//     print('========================================');
//     print('✅ ✅ ✅ AddMeToCommunity API SUCCESS ✅ ✅ ✅');
//     print('========================================');
//     print('📦 Full Response: $result');
//     print('📊 Success: ${result['success']}');
//     print('📨 Message: ${result['message']}');
//     print('📋 Data: ${result['data']}');
//     print('========================================');
//     print('');

//     // Update accessToken and refreshToken from response
//     // Check in data object first, then root level
//     if (result['data'] != null) {
//       if (result['data']['accessToken'] != null) {
//         accessToken = result['data']['accessToken'] as String;
//         print('🔄 AccessToken updated: $accessToken');
//       }
//       if (result['data']['refreshToken'] != null) {
//         refreshToken = result['data']['refreshToken'] as String;
//         print('🔄 RefreshToken updated: $refreshToken');
//       }
//     }
//     // Also check at root level if not found in data
//     if (result['accessToken'] != null) {
//       accessToken = result['accessToken'] as String;
//       print('🔄 AccessToken updated (root level): $accessToken');
//     }
//     if (result['refreshToken'] != null) {
//       refreshToken = result['refreshToken'] as String;
//       print('🔄 RefreshToken updated (root level): $refreshToken');
//     }

//     Fluttertoast.showToast(
//       msg: result['message'] ?? "Successfully added to community!",
//       toastLength: Toast.LENGTH_SHORT,
//       backgroundColor: Colors.green,
//       textColor: Colors.white,
//     );

//     // Navigate to homepage after successful API call
//     Navigator.pushReplacementNamed(context, '/home');
//   } catch (e) {
//     print('');
//     print('========================================');
//     print('❌ ❌ ❌ AddMeToCommunity API FAILED ❌ ❌ ❌');
//     print('========================================');
//     print('Error: $e');
//     print('========================================');
//     print('');

//     // Extract the actual error message
//     String errorMessage = e.toString();
//     if (errorMessage.startsWith('Exception: Exception: ')) {
//       errorMessage = errorMessage.replaceFirst('Exception: Exception: ', '');
//     } else if (errorMessage.startsWith('Exception: ')) {
//       errorMessage = errorMessage.replaceFirst('Exception: ', '');
//     }

//     Fluttertoast.showToast(
//       msg: errorMessage,
//       toastLength: Toast.LENGTH_LONG,
//       backgroundColor: Colors.red,
//       textColor: Colors.white,
//     );
//   } finally {
//     setState(() {
//       isLoadingAddMeToCommunity = false;
//     });
//     // Sync with controller
//     final controller = Get.find<LoginController>();
//     controller.isLoadingAddMeToCommunity.value = false;
//   }
// }
