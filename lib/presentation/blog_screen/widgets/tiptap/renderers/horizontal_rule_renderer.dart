import 'package:bandhucare_new/presentation/blog_screen/widgets/tiptap/base/node_renderer.dart';
import 'package:flutter/material.dart';

/// Renders TipTap horizontal rule nodes
class HorizontalRuleRenderer implements NodeRenderer {
  @override
  Widget render(Map<String, dynamic> node) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24),
      height: 1,
      color: Colors.grey[300],
    );
  }
}

