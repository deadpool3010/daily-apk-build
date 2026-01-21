import 'package:bandhucare_new/core/export_file/app_exports.dart';
import 'package:bandhucare_new/presentation/blog_screen/widgets/tiptap/base/node_renderer.dart';
import 'package:bandhucare_new/presentation/blog_screen/widgets/tiptap/renderers/text_span_renderer.dart';
import 'package:flutter/material.dart';

/// Renders TipTap blockquote nodes
class BlockquoteRenderer implements NodeRenderer {
  @override
  Widget render(Map<String, dynamic> node) {
    final content = node['content'] as List<dynamic>? ?? [];
    final flattenedContent = TextSpanRenderer.flattenContent(content);
    final textSpans = <TextSpan>[];

    for (final item in flattenedContent) {
      if (item is Map<String, dynamic>) {
        final type = item['type'] as String? ?? '';

        if (type == 'text') {
          textSpans.add(
            TextSpanRenderer.renderTextNode(
              item,
              GoogleFonts.lato(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.italic,
                color: AppColors.black,
                height: 1.6,
              ),
            ),
          );
        } else if (type == 'hardBreak') {
          textSpans.add(const TextSpan(text: '\n'));
        }
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12, top: 8, left: 8, right: 6),
      padding: const EdgeInsets.only(left: 16, top: 12, bottom: 12, right: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(
          left: BorderSide(
            color: AppColors.primaryColor,
            width: 4,
          ),
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: RichText(
        text: TextSpan(children: textSpans),
        textAlign: TextAlign.justify,
      ),
    );
  }
}

