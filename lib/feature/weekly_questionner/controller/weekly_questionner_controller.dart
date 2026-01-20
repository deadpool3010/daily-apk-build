import 'package:get/get.dart';

final List<Map<String, String>> weeklyQuestionner = [
  {
    'i sip liqueds to help swellow food':
        'Yes from my past few days liquid is must',
  },
  {'my house feels dry when eating a meal': 'Yes i have dry mouth'},
  {'my throat is sore': 'Yes i have sore throat'},
  {'i have a cough': 'Yes i have cough'},
  {'i have a cold': 'Yes i have cold'},
  {'i have a flu': 'Yes i have flu'},
  {'i have a headache': 'Yes i have headache'},
];

class WeeklyQuestionnerController extends GetxController {
  var filteredQuestionner = <Map<String, String>>[].obs;
  var filteredIndices = <int>[].obs;

  @override
  void onInit() {
    super.onInit();
    filteredQuestionner.value = List.from(weeklyQuestionner);
    filteredIndices.value = List.generate(
      weeklyQuestionner.length,
      (index) => index,
    );
  }

  void searchQuestionner(String query) {
    if (query.isEmpty) {
      filteredQuestionner.value = List.from(weeklyQuestionner);
      filteredIndices.value = List.generate(
        weeklyQuestionner.length,
        (index) => index,
      );
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
}
