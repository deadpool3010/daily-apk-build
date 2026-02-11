import 'package:bandhucare_new/core/api/api_services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class YourRemindersController extends GetxController {
  final headerMonthYear = DateFormat('MMMM yyyy').format(DateTime.now()).obs;
  final selectedFilter = 'all'.obs;
  final selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now()).obs;

  // Reminder data from API
  final reminders = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final isContinuing = false.obs;
  final date = DateFormat('yyyy-MM-dd').format(DateTime.now());
  final percentageOfCompleted = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFormSessions(selectedDate.value, selectedFilter.value);
  }

  Future<void> fetchFormSessions(String date, String status) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await getFormSessionsApi(date, status);

      if (response['success'] == true && response['data'] != null) {
        final sessions = response['data']['sessions'] as List<dynamic>?;

        if (sessions != null && sessions.isNotEmpty) {
          reminders.value = sessions.map((i) {
            final sessionId = i['_id'];
            final formId = i['formId'] as Map<String, dynamic>?;
            final sessionStartDate = i['sessionStartDate'] as String?;
            final status = i['status'] as String?;
            final totalQuestions = i['totalQuestions'] ?? 0 as int?;
            final completedQuestions = i['completedQuestions'] ?? 0 as int?;

            final percentage = calculatePercentageOfCompleted(
              totalQuestions,
              completedQuestions,
            );
            bool isCompleted = false;

            // Parse date

            String dateDisplay = '';
            if (sessionStartDate != null) {
              try {
                dateDisplay = DateFormat(
                  'dd/MM/yyyy',
                ).format(DateTime.parse(sessionStartDate));
                if (dateDisplay ==
                    DateFormat('dd/MM/yyyy').format(DateTime.now())) {
                  dateDisplay = 'Today';
                } else {
                  dateDisplay = DateFormat(
                    'dd/MM/yyyy',
                  ).format(DateTime.parse(sessionStartDate));
                }
              } catch (e) {
                dateDisplay = sessionStartDate;
              }
            }
            if (percentage == 100) {
              isCompleted = true;
            }

            return {
              'id': sessionId,
              'date': dateDisplay,
              'completed': completedQuestions.toString(),
              'total': totalQuestions.toString(),
              'percentage': percentage.toString(),
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

  void updateFilter(String status) {
    selectedFilter.value = status;
    fetchFormSessions(selectedDate.value, status);
  }

  void updateDate(String date) {
    print('updateDate: $date');
    selectedDate.value = date;
    fetchFormSessions(selectedDate.value, selectedFilter.value);
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

  void viewResponse(String reminderId) {
    // Navigate to response view
    print('Viewing response for: $reminderId');
  }

  // Future<void> continueQuestionnaire(String sessionId) async {
  //   try {
  //     isContinuing.value = true;

  //     final response = await getFormQuestionApi(sessionId);

  //     if (response['success'] == true && response['data'] != null) {
  //       final messageData =
  //           response['data']['message'] as Map<String, dynamic>?;

  //       if (messageData != null) {
  //         final conversationId = messageData['conversationId']?.toString();
  //         final content = messageData['content']?.toString() ?? '';

  //         if (conversationId != null && conversationId.isNotEmpty) {
  //           // Delete existing controller if it exists to start fresh
  //           if (Get.isRegistered<ChatScreenController>()) {
  //             Get.delete<ChatScreenController>();
  //           }

  //           // Create new controller instance for this conversation
  //           final chatController = Get.put(
  //             ChatScreenController(),
  //             permanent: false,
  //           );

  //           // Set conversation ID before onInit runs
  //           chatController.conversationId.value = conversationId;

  //           // Prevent auto-loading chat history by setting flag
  //           chatController.isInitialLoad.value = false;
  //           chatController.isLoading.value = false;

  //           // Clear any existing messages
  //           chatController.messages.clear();

  //           // Add the initial bot message to the chat
  //           if (content.isNotEmpty) {
  //             chatController.messages.add(
  //               ChatMessage(
  //                 text: content,
  //                 isUser: false,
  //                 file: messageData['file'] as Map<String, dynamic>?,
  //               ),
  //             );
  //           }

  //           // Hide suggestions since we have a message
  //           chatController.showSuggestions.value = false;

  //           // Navigate to chatbot screen
  //           Get.to(() => ChatBotScreen());
  //         } else {
  //           Get.snackbar(
  //             'Error',
  //             'Failed to start questionnaire: No conversation ID received',
  //             snackPosition: SnackPosition.BOTTOM,
  //             backgroundColor: Colors.red,
  //             colorText: Colors.white,
  //           );
  //         }
  //       } else {
  //         Get.snackbar(
  //           'Error',
  //           'Failed to start questionnaire: Invalid response format',
  //           snackPosition: SnackPosition.BOTTOM,
  //           backgroundColor: Colors.red,
  //           colorText: Colors.white,
  //         );
  //       }
  //     } else {
  //       final errorMsg =
  //           response['message']?.toString() ?? 'Failed to start questionnaire';
  //       Get.snackbar(
  //         'Error',
  //         errorMsg,
  //         snackPosition: SnackPosition.BOTTOM,
  //         backgroundColor: Colors.red,
  //         colorText: Colors.white,
  //       );
  //     }
  //   } catch (e) {
  //     print('Error continuing questionnaire: $e');
  //     Get.snackbar(
  //       'Error',
  //       'Failed to start questionnaire: ${e.toString()}',
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: Colors.red,
  //       colorText: Colors.white,
  //     );
  //   } finally {
  //     isContinuing.value = false;
  //   }
  // }

  int calculatePercentageOfCompleted(
    int totalQuestions,
    int completedQuestions,
  ) {
    if (totalQuestions > 0) {
      return ((completedQuestions / totalQuestions) * 100).round();
    }
    return 0;
  }
}
