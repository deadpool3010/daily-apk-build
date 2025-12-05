import 'package:get/get.dart';

class YourRemindersController extends GetxController {
  final selectedMonth = 'November 2025'.obs;
  final selectedFilter = 'Unfinished'.obs;
  final selectedDate = DateTime(2025, 11, 2).obs;
  
  // Sample reminder data
  final reminders = <Map<String, dynamic>>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    _loadReminders();
  }
  
  void _loadReminders() {
    // Sample data - replace with actual API call
    reminders.value = [
      {
        'date': 'Today',
        'completed': 2,
        'total': 3,
        'percentage': 75,
        'isCompleted': false,
        'doctorName': 'Dr. Raghu',
        'title': 'Questionnaire',
        'description': 'Please fill the questionnaire sent by the doctor.',
      },
      {
        'date': '01/11/25',
        'completed': 3,
        'total': 4,
        'percentage': 100,
        'isCompleted': true,
        'doctorName': 'Dr. Raghu',
        'title': 'Questionnaire',
        'description': 'Please fill the questionnaire sent by the doctor.',
      },
    ];
  }
  
  void updateFilter(String filter) {
    selectedFilter.value = filter;
    // Filter reminders based on selection
    _filterReminders();
  }
  
  void _filterReminders() {
    // Implement filtering logic
    switch (selectedFilter.value) {
      case 'Unfinished':
        // Show only unfinished reminders
        break;
      case 'Completed':
        // Show only completed reminders
        break;
      case 'All':
        // Show all reminders
        break;
    }
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
  
  void continueQuestionnaire(String reminderId) {
    // Navigate to questionnaire
    print('Continue questionnaire: $reminderId');
  }
}

