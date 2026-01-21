import 'package:bandhucare_new/core/api/api_services.dart';
import 'package:get/get.dart';

class WeeklyQuestionnerController extends GetxController {
  var filteredQuestionner = <Map<String, String>>[].obs;
  var filteredIndices = <int>[].obs;

  final String? sessionId = Get.arguments?['sessionId'] as String?;
  final isLoading = false.obs;
  var weeklyQuestionner = <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();

    final sessionIdValue = Get.arguments?['sessionId'] as String?;
    if (sessionIdValue != null && sessionIdValue.isNotEmpty) {
      weeklyQuestionnaire(sessionIdValue);
    }
  }

  void _updateFilteredLists() {
    filteredQuestionner.value = List.from(weeklyQuestionner);
    filteredIndices.value = List.generate(
      weeklyQuestionner.length,
      (index) => index,
    );
  }

  void searchQuestionner(String query) {
    if (query.isEmpty) {
      _updateFilteredLists();
    } else {
      filteredQuestionner.value = [];
      filteredIndices.value = [];
      for (int i = 0; i < weeklyQuestionner.length; i++) {
        final question = weeklyQuestionner[i].keys.first.toLowerCase();
        if (question.contains(query.toLowerCase())) {
          filteredQuestionner.add(weeklyQuestionner[i]);
          filteredIndices.add(i);
        }
      }
    }
  }

  Future<void> weeklyQuestionnaire(String sessionId) async {
    try {
      isLoading.value = true;
      // Get API response as List<Map<String, dynamic>>
      final List<Map<String, dynamic>> result = await getFormQuestionAnsApi(
        sessionId,
      );

      // Transform API response from {questionId, question, response}
      // to {question: response} format
      final transformedList = result.map((item) {
        final question = item['question']?.toString() ?? '';
        final response = item['response']?.toString() ?? '';
        return <String, String>{question: response};
      }).toList();

      // Update the observable list
      weeklyQuestionner.assignAll(transformedList);

      // Update filtered lists after data is loaded
      _updateFilteredLists();
    } catch (e) {
      print('Error loading weekly questionnaire: $e');
      // Optionally show error to user
    } finally {
      isLoading.value = false;
    }
  }
}
