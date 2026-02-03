import 'package:bandhucare_new/core/api/api_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class WeeklyQuestionnerController extends GetxController {
  var filteredQuestionner = <Map<String, Map<String, String>>>[].obs;
  var filteredIndices = <int>[].obs;
  final FocusNode editFocusNode = FocusNode();
  final String? sessionId = Get.arguments?['sessionId'] as String?;
  final isLoading = false.obs;
  var weeklyQuestionner = <Map<String, Map<String, String>>>[].obs;
  final TextEditingController editController = TextEditingController(text: "");

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
      print("Session ID in weeklyQuestionnaire: $sessionId");
      final List<Map<String, dynamic>> result = await getFormQuestionAnsApi(
        sessionId,
      );

      // Transform API response from {questionId, question, response}
      // to {question: response} format
      print('API Result: $result');

      final transformedList = result.map((item) {
        final questionId = item['questionId']?.toString() ?? '';
        final question = item['question']?.toString() ?? '';
        final response = item['response']?.toString() ?? '';
        return <String, Map<String, String>>{
          question: {'response': response, 'questionId': questionId},
        };
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

  Future<void> updateAnswer({
    required String sessionId,
    required String questionId,
    required String newResponse,
  }) async {
    print("Update Answer Result: $newResponse");

    print("newResponse is" + newResponse);
    print("sessionId is" + sessionId);
    print("questionId is" + questionId);
    final result = await editAnswerApi(
      sessionId: sessionId,
      questionId: questionId,
      updatedAnswer: newResponse,
    );

    if (result['success'] == true) {
      _updateLocalAnswer(
        questionId: questionId,
        response: result['data']['response'],
      );
    }
  }

  void _updateLocalAnswer({
    required String questionId,
    required String response,
  }) {
    final updatedList = weeklyQuestionner.map((item) {
      final question = item.keys.first;
      final data = item[question];

      if (data?['questionId'] == questionId) {
        return {
          question: {...data!, 'response': response},
        };
      }
      return item;
    }).toList();

    weeklyQuestionner.assignAll(updatedList);
    _updateFilteredLists();
  }
}
