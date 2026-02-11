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
  int? editingIndex;

  @override
  void initState() {
    super.initState();
    // Get the controller instance
    controller = Get.find<WeeklyQuestionnerController>();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Show empty state if no questions available
      if (controller.filteredQuestionner.isEmpty) {
        return Center(
          child: Text(
            'No questions available',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        );
      }

      return Center(
        child: SizedBox(
          height: 500,
          width: 380, // Match search bar width
          child: ListView.builder(
            itemCount: controller.filteredQuestionner.length,
            itemBuilder: (context, index) {
              final question = controller.filteredQuestionner[index].keys.first;
              final questionMap = controller.filteredQuestionner[index];
              final data = questionMap[question];
              final ans = data?['response'] ?? '';
              final questionId = data?['questionId'] ?? '';

              final originalIndex = controller.filteredIndices[index];
              final isExpanded = expandedIndex == index;

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
                      maintainState: true,
                      onExpansionChanged: (bool value) {
                        setState(() {
                          if (value == true) {
                            if (editingIndex != index) {
                              editingIndex = null;
                            }
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 5,
                              child: editingIndex == index
                                  ? TextField(
                                      onChanged: (value) {
                                        setState(() {});
                                      },
                                      focusNode: controller.editFocusNode,
                                      controller: controller.editController,
                                      maxLines: null,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                      ),
                                    )
                                  : Text(
                                      ans,
                                      style: TextStyle(
                                        color: isExpanded
                                            ? Colors.black
                                            : Colors.black54,
                                      ),
                                    ),
                            ),

                            if (editingIndex != index) ...{
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    if (editingIndex == index) {
                                      editingIndex = null;
                                    } else {
                                      editingIndex = index;
                                      controller.editController.text = ans;
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                            controller.editFocusNode
                                                .requestFocus();
                                          });
                                    }
                                  });
                                },
                                child: Text(
                                  "Edit",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            } else ...{
                              TextButton(
                                onPressed:
                                    editingIndex == index &&
                                        controller.editController.text.trim() ==
                                            ans.trim()
                                    ? null
                                    : () async {
                                        String newResponse = controller
                                            .editController
                                            .text
                                            .trim();
                                        if (newResponse.isEmpty) {
                                          // Show error message
                                          Get.snackbar(
                                            'Error',
                                            'Response cannot be empty',
                                            snackPosition: SnackPosition.BOTTOM,
                                          );
                                          return;
                                        }

                                        print("newResponse is" + newResponse);
                                        print("sessionId is" + sessionId);
                                        print("questionId is" + questionId);

                                        await controller.updateAnswer(
                                          sessionId: controller
                                              .sessionId!, // Get sessionId from data
                                          questionId: questionId,
                                          newResponse: newResponse,
                                        );

                                        setState(() {
                                          editingIndex = null;
                                        });
                                      },
                                child: Text(
                                  "Save",
                                  style: TextStyle(
                                    color:
                                        editingIndex == index &&
                                            controller.editController.text ==
                                                ans
                                        ? Colors
                                              .grey // Disabled color
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            },
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    });
  }
}
