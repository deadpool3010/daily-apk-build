import 'package:flutter/material.dart';

List<String> questions = [
  'Is it okay to take my medicine after food instead of before?',
  'What should I do if I miss a dose of my medicine?',
  'Is it safe to take my medicine at a different time than prescribed?',
  'Can I stop taking my medicine once I start feeling better?',
  'What happens if I accidentally take two doses of my medicine?',
  'Are there any foods I should avoid while taking this medicine?',
  'Can I take my medicine if I have an empty stomach?',
  'Is it normal to feel drowsy or weak after taking this medicine?',
  'Can I take this medicine along with my other regular medicines?',
];

class QuestionSuggestions extends StatelessWidget {
  final Function(String) onQuestionTap;

  const QuestionSuggestions({super.key, required this.onQuestionTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: questions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              onQuestionTap(questions[index]);
            },
            child: Container(
              width: 260,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                questions[index],
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
