import 'package:bandhucare_new/core/app_exports.dart';
import 'package:bandhucare_new/presentation/blog_screen/widgets/tiptap/base/node_renderer.dart';
import 'package:bandhucare_new/presentation/blog_screen/widgets/tiptap/renderers/text_span_renderer.dart';
import 'package:flutter/material.dart';

/// Renders TipTap heading nodes (h1-h6)
class HeadingRenderer implements NodeRenderer {
  @override
  Widget render(Map<String, dynamic> node) {
    final attrs = node['attrs'] as Map<String, dynamic>? ?? {};
    final level = attrs['level'] as int? ?? 1;
    final textAlign = _parseTextAlign(attrs['textAlign']);
    final content = node['content'] as List<dynamic>? ?? [];

    double fontSize;
    FontWeight fontWeight;

    switch (level) {
      case 1:
        fontSize = 28;
        fontWeight = FontWeight.bold;
        break;
      case 2:
        fontSize = 24;
        fontWeight = FontWeight.bold;
        break;
      case 3:
        fontSize = 20;
        fontWeight = FontWeight.w600;
        break;
      case 4:
        fontSize = 18;
        fontWeight = FontWeight.w600;
        break;
      case 5:
        fontSize = 16;
        fontWeight = FontWeight.w600;
        break;
      case 6:
        fontSize = 14;
        fontWeight = FontWeight.w600;
        break;
      default:
        fontSize = 24;
        fontWeight = FontWeight.bold;
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
              GoogleFonts.roboto(
                fontSize: fontSize,
                fontWeight: fontWeight,
                color: AppColors.black,
                height: 1.3,
              ),
            ),
          );
        } else if (type == 'hardBreak') {
          textSpans.add(const TextSpan(text: '\n'));
        }
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12, left: 8, right: 6),
      child: RichText(
        text: TextSpan(children: textSpans),
        textAlign: textAlign ?? TextAlign.left,
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

