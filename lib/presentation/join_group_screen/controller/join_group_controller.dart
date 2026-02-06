import 'package:bandhucare_new/core/export_file/app_exports.dart';

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

        // Safely access data field
        if (result['data'] != null && result['data'] is Map<String, dynamic>) {
          final data = result['data'] as Map<String, dynamic>;
          accessToken = data['accessToken']?.toString() ?? '';
          refreshToken = data['refreshToken']?.toString() ?? '';
        } else {
          accessToken = '';
          refreshToken = '';
        }

        await SharedPrefLocalization().saveTokens(accessToken, refreshToken);

        // Only update FCM token if it's available
        final currentFcmToken = fcmToken;
        if (currentFcmToken != null && currentFcmToken.isNotEmpty) {
          try {
            await updateFcmTokenApi(currentFcmToken);
          } catch (e) {
            // Log error but don't block the flow if FCM token update fails
            print('Failed to update FCM token: $e');
          }
        }

        // Refresh homepage data so that new group appears immediately
        if (Get.isRegistered<HomepageController>()) {
          try {
            final homepageController = Get.find<HomepageController>();
            // Fire and forget; controller handles its own loading state
            homepageController.loadHomepageData();
          } catch (e) {
            print('Failed to refresh homepage after group join: $e');
          }
        }

        // Use post-frame callback to ensure proper widget disposal before navigation
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Future.delayed(Duration(milliseconds: 300), () {
            // Get group data from arguments to pass to consent form
            final groupData = Get.arguments as Map<String, dynamic>? ?? {};
            // Navigate to consent form screen with group data
            Get.offNamed(AppRoutes.consentFormScreen, arguments: groupData);
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
