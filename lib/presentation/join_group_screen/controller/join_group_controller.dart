import 'package:bandhucare_new/core/app_exports.dart';

class JoinGroupController extends GetxController {
  final isLoading = false.obs;

  Future<void> joinGroup({
    required String groupId,
    required String uniqueCode,
  }) async {
    if (groupId.isEmpty) {
      Fluttertoast.showToast(
        msg: "Group ID is missing",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    if (uniqueCode.isEmpty) {
      Fluttertoast.showToast(
        msg: "Unique code is missing",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      // Call join group API with empty users array as per the API spec
      final result = await joinGroupApi(
        groupId: groupId,
        users: [], // Empty array as per API specification
        uniqueCode: uniqueCode,
      );

      if (result['success'] == true ||
          (result['message'] != null &&
              result['message'].toString().toLowerCase().contains('success'))) {
        Fluttertoast.showToast(
          msg: result['message'] ?? "Successfully joined the group!",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        accessToken = result['data']['accessToken'] ?? '';
        refreshToken = result['data']['refreshToken'] ?? '';

        await SharedPrefLocalization().saveTokens(
          accessToken,
          refreshToken ?? '',
        );
        await updateFcmTokenApi(fcmToken!);

        // Use post-frame callback to ensure proper widget disposal before navigation
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Future.delayed(Duration(milliseconds: 300), () {
            // Navigate to join community screen or home screen
            Get.offNamed(AppRoutes.consentFormScreen);
          });
        });
      } else {
        throw Exception(result['message'] ?? 'Failed to join group');
      }
    } catch (e) {
      String errorMessage = e.toString();
      if (errorMessage.startsWith('Exception: Exception: ')) {
        errorMessage = errorMessage.replaceFirst('Exception: Exception: ', '');
      } else if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.replaceFirst('Exception: ', '');
      }

      Fluttertoast.showToast(
        msg: errorMessage.isNotEmpty
            ? errorMessage
            : "Failed to join group. Please try again.",
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
