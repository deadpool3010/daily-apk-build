import 'package:bandhucare_new/core/export_file/app_exports.dart';
import 'package:bandhucare_new/feature/user_profile/widgets/seperator_line.dart';
import 'package:bandhucare_new/feature/weekly_questionner/controller/weekly_questionner_controller.dart';

class QuestionAnswerTile extends StatefulWidget {
  QuestionAnswerTile({super.key});

  @override
  State<QuestionAnswerTile> createState() => _QuestionAnswerTileState();
}

class _QuestionAnswerTileState extends State<QuestionAnswerTile> {
  late final WeeklyQuestionnerController controller;

  int? expandedIndex;
  int? _closingTileIndex;

  @override
  void initState() {
    super.initState();
    // Get the controller instance
    controller = Get.find<WeeklyQuestionnerController>();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Center(
        child: SizedBox(
          height: 500,
          width: 380, // Match search bar width
          child: ListView.builder(
            itemCount: controller.filteredQuestionner.length,
            itemBuilder: (context, index) {
              final question = controller.filteredQuestionner[index].keys.first;
              final ans = controller.filteredQuestionner[index].values.first;
              final originalIndex = controller.filteredIndices[index];
              final isExpanded = expandedIndex == index;

              // Only change key for tile that's being closed (to force it closed)
              // Keep stable key for opening tile so it can animate naturally
              final tileKey = (_closingTileIndex == index)
                  ? ValueKey(
                      'tile_${index}_close_${DateTime.now().millisecondsSinceEpoch}',
                    )
                  : ValueKey('tile_$index');

              return Container(
                decoration: BoxDecoration(color: Colors.white),
                child: Column(
                  children: [
                    const SeperatorLine(height: 1, horizontalPadding: 15),
                    ExpansionTile(
                      key: tileKey,
                      initiallyExpanded: isExpanded,
                      maintainState: true, // ✅ Helps with animation
                      onExpansionChanged: (bool value) {
                        setState(() {
                          if (value == true) {
                            // If there was a previously expanded tile, mark it for closing
                            if (expandedIndex != null &&
                                expandedIndex != index) {
                              _closingTileIndex = expandedIndex;
                            } else {
                              _closingTileIndex = null;
                            }
                            // Open this tile
                            expandedIndex = index;
                          } else {
                            // Collapse this tile
                            expandedIndex = null;
                            _closingTileIndex = null;
                          }
                        });
                      },
                      tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                      childrenPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      shape: Border(bottom: BorderSide.none),
                      title: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Q${originalIndex + 1}: ',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: question,
                              style: TextStyle(
                                fontSize: 16,
                                color: isExpanded
                                    ? Colors.black
                                    : Colors.black54,
                                fontWeight: isExpanded
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            ans,
                            style: TextStyle(
                              color: isExpanded ? Colors.black : Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
