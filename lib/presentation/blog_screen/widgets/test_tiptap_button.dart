import 'package:bandhucare_new/core/export_file/app_exports.dart';

import 'package:bandhucare_new/presentation/blog_screen/data/blog_screen_navigation_example.dart';

/// A test button widget to quickly navigate to blog screen with TipTap content
/// 
/// Add this widget to any screen for quick testing:
/// ```dart
/// TestTiptapButton()
/// ```
class TestTiptapButton extends StatelessWidget {
  const TestTiptapButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: BlogScreenNavigationExample.navigateWithTiptapContent,
      icon: const Icon(Icons.article),
      label: const Text('View TipTap Blog'),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    );
  }
}

