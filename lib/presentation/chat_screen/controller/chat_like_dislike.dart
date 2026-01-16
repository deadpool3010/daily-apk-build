import 'package:bandhucare_new/core/api/api_services.dart';
import 'package:get/get.dart';

class ChatLikeDislikeController extends GetxController {
  RxBool isLiked = true.obs;
  RxBool isDisliked = true.obs;

  Future<bool?> likeMessageReversal(String messageId) async {
    try {
      final response = await likeMessageApi(messageId);
      // Check if response has 'success' key - default to true if not present
      final success = response['success'] ?? true;
      if (success) {
        return null; // Success - no error, keep optimistic update
      }
      return false; // API returned success: false, trigger rollback
    } catch (e) {
      print('Error in likeMessageReversal: $e');
      return false; // Return false on exception to trigger rollback
    }
  }

  Future<bool?> disLikeMessageReversal(String messageId) async {
    try {
      final response = await disLikeMessageApi(messageId);
      // Check if response has 'success' key - default to true if not present
      final success = response['success'] ?? true;
      if (success) {
        return null; // Success - no error, keep optimistic update
      }
      return false; // API returned success: false, trigger rollback
    } catch (e) {
      print('Error in disLikeMessageReversal: $e');
      return false; // Return false on exception to trigger rollback
    }
  }
}
