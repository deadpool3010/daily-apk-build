import 'dart:convert';
import 'package:bandhucare_new/presentation/blog_screen/data/sample_tiptap_data.dart';
import 'package:bandhucare_new/routes/app_routes.dart';
import 'package:get/get.dart';

/// Example: How to navigate to blog screen with TipTap JSON content
/// 
/// This file demonstrates how to use TipTap JSON data in the blog screen.
class BlogScreenNavigationExample {
  /// Navigate to blog screen with sample TipTap content
  static void navigateWithTiptapContent() {
    Get.toNamed(
      AppRoutes.blogScreen,
      arguments: {
        'title': 'Getting Started with TipTap',
        'author': 'TipTap Team',
        'date': 'Nov 09, 2025',
        'tiptapContent': SampleTiptapData.sampleDocument,
        'tags': ['Tutorial', 'Documentation', 'Getting Started'],
      },
    );
  }

  /// Navigate to blog screen with custom TipTap content
  /// 
  /// [tiptapDocument] should be a Map<String, dynamic> with the TipTap JSON structure
  static void navigateWithCustomTiptapContent({
    required String title,
    required String author,
    required String date,
    required Map<String, dynamic> tiptapDocument,
    List<String>? tags,
  }) {
    Get.toNamed(
      AppRoutes.blogScreen,
      arguments: {
        'title': title,
        'author': author,
        'date': date,
        'tiptapContent': tiptapDocument,
        'tags': tags ?? ['Article'],
      },
    );
  }

  /// Navigate to blog screen with TipTap content from JSON string
  /// 
  /// Useful when receiving TipTap JSON from an API
  static void navigateWithTiptapJsonString({
    required String title,
    required String author,
    required String date,
    required String tiptapJsonString,
    List<String>? tags,
  }) {
    try {
      final tiptapDocument = jsonDecode(tiptapJsonString) as Map<String, dynamic>;
      
      Get.toNamed(
        AppRoutes.blogScreen,
        arguments: {
          'title': title,
          'author': author,
          'date': date,
          'tiptapContent': tiptapDocument,
          'tags': tags ?? ['Article'],
        },
      );
    } catch (e) {
      // Handle JSON parsing error
      print('Error parsing TipTap JSON: $e');
    }
  }
}

