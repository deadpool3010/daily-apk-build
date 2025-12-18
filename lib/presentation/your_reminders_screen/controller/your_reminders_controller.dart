import 'package:bandhucare_new/core/network/api_services.dart';
import 'package:bandhucare_new/presentation/chat_screen/controller/chat_screeen_controller.dart';
import 'package:bandhucare_new/presentation/chat_screen/chat_bot_screen.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class YourRemindersController extends GetxController {
  final selectedMonth = 'November 2025'.obs;
  final selectedFilter = 'Unfinished'.obs;
  final selectedDate = DateTime(2025, 11, 2).obs;

  // Reminder data from API
  final reminders = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final isContinuing = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFormSessions();
  }

  Future<void> fetchFormSessions() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await getFormSessionsApi();

      if (response['success'] == true && response['data'] != null) {
        final sessions = response['data']['sessions'] as List<dynamic>?;

        if (sessions != null && sessions.isNotEmpty) {
          reminders.value = sessions.map((session) {
            final formId = session['formId'] as Map<String, dynamic>?;
            final sessionStartDate = session['sessionStartDate'] as String?;
            final questionScores = session['questionScores'] as List<dynamic>?;
            final status = session['status'] as String?;

            // Parse date
            DateTime? date;
            String dateDisplay = '';
            if (sessionStartDate != null) {
              try {
                date = DateTime.parse(sessionStartDate);
                final now = DateTime.now();
                final today = DateTime(now.year, now.month, now.day);
                final sessionDate = DateTime(date.year, date.month, date.day);

                if (sessionDate == today) {
                  dateDisplay = 'Today';
                } else {
                  dateDisplay =
                      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year.toString().substring(2)}';
                }
              } catch (e) {
                dateDisplay = sessionStartDate;
              }
            }

            // Calculate completion
            final totalQuestions = formId != null
                ? 1
                : 0; // Assuming 1 form = 1 questionnaire
            final completedQuestions = questionScores?.length ?? 0;
            final isCompleted =
                status == 'completed' ||
                (questionScores != null && questionScores.isNotEmpty);
            final percentage = totalQuestions > 0
                ? ((completedQuestions / totalQuestions) * 100).round()
                : 0;

            return {
              'id': session['_id']?.toString() ?? '',
              'date': dateDisplay,
              'completed': completedQuestions,
              'total': totalQuestions,
              'percentage': percentage,
              'isCompleted': isCompleted,
              'title': formId?['title']?.toString() ?? 'Questionnaire',
              'description':
                  formId?['description']?.toString() ??
                  'Please fill the questionnaire.',
              'formUrl': formId?['formUrl']?.toString() ?? '',
              'sessionStartDate': sessionStartDate,
              'status': status ?? 'active',
            };
          }).toList();
        } else {
          reminders.value = [];
        }
      } else {
        errorMessage.value =
            response['message']?.toString() ?? 'Failed to load reminders';
        reminders.value = [];
      }
    } catch (e) {
      print('Error fetching form sessions: $e');
      errorMessage.value = 'Failed to load reminders: ${e.toString()}';
      reminders.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  void updateFilter(String filter) {
    selectedFilter.value = filter;
    // Filter reminders based on selection
    _filterReminders();
  }

  List<Map<String, dynamic>> get filteredReminders {
    switch (selectedFilter.value) {
      case 'Unfinished':
        return reminders
            .where((r) => !(r['isCompleted'] as bool? ?? false))
            .toList();
      case 'Completed':
        return reminders
            .where((r) => r['isCompleted'] as bool? ?? false)
            .toList();
      case 'All':
      default:
        return reminders.toList();
    }
  }

  void _filterReminders() {
    // Filtering is handled by getter
    update();
  }

  void selectDate(DateTime date) {
    selectedDate.value = date;
    // Load reminders for selected date
  }

  void navigateToNextMonth() {
    // Implement month navigation
    // TODO: Update selectedMonth to next month
  }

  void viewResponse(String reminderId) {
    // Navigate to response view
    print('Viewing response for: $reminderId');
  }

  Future<void> continueQuestionnaire(String sessionId) async {
    try {
      isContinuing.value = true;

      // Call get-question API with session ID
      final response = await getFormQuestionApi(sessionId);

      if (response['success'] == true && response['data'] != null) {
        final messageData =
            response['data']['message'] as Map<String, dynamic>?;

        if (messageData != null) {
          final conversationId = messageData['conversationId']?.toString();
          final content = messageData['content']?.toString() ?? '';

          if (conversationId != null && conversationId.isNotEmpty) {
            // Delete existing controller if it exists to start fresh
            if (Get.isRegistered<ChatScreenController>()) {
              Get.delete<ChatScreenController>();
            }

            // Create new controller instance for this conversation
            final chatController = Get.put(
              ChatScreenController(),
              permanent: false,
            );

            // Set conversation ID before onInit runs
            chatController.conversationId.value = conversationId;

            // Prevent auto-loading chat history by setting flag
            chatController.isInitialLoad.value = false;
            chatController.isLoading.value = false;

            // Clear any existing messages
            chatController.messages.clear();

            // Add the initial bot message to the chat
            if (content.isNotEmpty) {
              chatController.messages.add(
                ChatMessage(
                  text: content,
                  isUser: false,
                  file: messageData['file'] as Map<String, dynamic>?,
                ),
              );
            }

            // Hide suggestions since we have a message
            chatController.showSuggestions.value = false;

            // Navigate to chatbot screen
            Get.to(() => ChatBotScreen());
          } else {
            Get.snackbar(
              'Error',
              'Failed to start questionnaire: No conversation ID received',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        } else {
          Get.snackbar(
            'Error',
            'Failed to start questionnaire: Invalid response format',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        final errorMsg =
            response['message']?.toString() ?? 'Failed to start questionnaire';
        Get.snackbar(
          'Error',
          errorMsg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error continuing questionnaire: $e');
      Get.snackbar(
        'Error',
        'Failed to start questionnaire: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isContinuing.value = false;
    }
  }
}
