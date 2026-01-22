import 'package:bandhucare_new/core/export_file/app_exports.dart';
import 'package:bandhucare_new/feature/search_function/presentation/common_searchbar.dart';
import 'package:bandhucare_new/feature/weekly_questionner/sections/further_assistance.dart';
import 'package:bandhucare_new/feature/weekly_questionner/sections/weekly_questionner_section.dart';
import 'package:bandhucare_new/feature/weekly_questionner/controller/weekly_questionner_controller.dart';
import 'package:flutter/widgets.dart';

class WeeklyQuestionnerUi extends StatelessWidget {
  const WeeklyQuestionnerUi({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller if not already registered
    if (!Get.isRegistered<WeeklyQuestionnerController>()) {
      Get.put(WeeklyQuestionnerController());
    }
    final controller = Get.find<WeeklyQuestionnerController>();

    return Scaffold(
      appBar: CommonAppBar(title: 'Weekly Questionner'),
      backgroundColor: Colors.white,
      body: Obx(
        () => Column(
          children: [
            AssesmentTitle(),
            SizedBox(height: 20),
            CustomSearchBar(onSearchChanged: controller.searchQuestionner),

            SizedBox(height: 30),

            QuestionText(),
            const SizedBox(height: 10),
            Expanded(
              child: controller.isLoading.value
                  ? Center(child: CircularProgressIndicator())
                  : QuestionAnswerTile(),
            ),
            SizedBox(height: 20),
            FurtherAssistance(),
          ],
        ),
      ),
    );
  }

  Center QuestionText() {
    return Center(
      child: SizedBox(
        width: 350,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Questions',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}

Center AssesmentTitle() {
  return Center(
    child: SizedBox(
      width: 350,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'XEROSTOMIA_v1 Assessment.',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: Colors.black38,
          ),
        ),
      ),
    ),
  );
}
