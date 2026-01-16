import 'package:bandhucare_new/core/app_exports.dart';
import 'package:bandhucare_new/presentation/blog_screen/widgets/tiptap/base/node_renderer.dart';
import 'package:bandhucare_new/presentation/blog_screen/widgets/tiptap/renderers/text_span_renderer.dart';
import 'package:flutter/material.dart';

/// Renders TipTap paragraph nodes
class ParagraphRenderer implements NodeRenderer {
  @override
  Widget render(Map<String, dynamic> node) {
    final attrs = node['attrs'] as Map<String, dynamic>? ?? {};
    final textAlign = _parseTextAlign(attrs['textAlign']);
    final content = node['content'] as List<dynamic>? ?? [];

    // Check if paragraph is empty
    if (content.isEmpty) {
      return const SizedBox(height: 16);
    }

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

    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 8, right: 6),
      child: RichText(
        text: TextSpan(children: textSpans),
        textAlign: textAlign ?? TextAlign.justify,
      ),
    );
  }

  TextAlign? _parseTextAlign(dynamic textAlign) {
    if (textAlign == null) return null;

    switch (textAlign.toString().toLowerCase()) {
      case 'left':
        return TextAlign.left;
      case 'center':
        return TextAlign.center;
      case 'right':
        return TextAlign.right;
      case 'justify':
        return TextAlign.justify;
      default:
        return null;
    }
  }
}

