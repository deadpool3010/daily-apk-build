import 'package:bandhucare_new/core/app_exports.dart';
import 'package:bandhucare_new/presentation/blog_screen/widgets/tiptap/base/node_renderer.dart';
import 'package:bandhucare_new/presentation/blog_screen/widgets/tiptap/renderers/text_span_renderer.dart';
import 'package:flutter/material.dart';

/// Renders TipTap code block nodes
class CodeBlockRenderer implements NodeRenderer {
  @override
  Widget render(Map<String, dynamic> node) {
    final content = node['content'] as List<dynamic>? ?? [];
    final text = TextSpanRenderer.extractPlainText({'content': content});

    return Container(
      margin: const EdgeInsets.only(bottom: 12, top: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: SelectableText(
        text,
        style: GoogleFonts.courierPrime(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.black,
          height: 1.5,
        ),
      ),
    );
  }
}

