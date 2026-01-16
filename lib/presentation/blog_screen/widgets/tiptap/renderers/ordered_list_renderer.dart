import 'package:bandhucare_new/core/app_exports.dart';
import 'package:bandhucare_new/presentation/blog_screen/widgets/tiptap/base/node_renderer.dart';
import 'package:bandhucare_new/presentation/blog_screen/widgets/tiptap/renderers/text_span_renderer.dart';
import 'package:flutter/material.dart';

/// Renders TipTap ordered list nodes
class OrderedListRenderer implements NodeRenderer {
  @override
  Widget render(Map<String, dynamic> node) {
    final content = node['content'] as List<dynamic>? ?? [];

    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 8, right: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: content.asMap().entries.map((entry) {
          return _buildListItem(entry.value, index: entry.key + 1);
        }).toList(),
      ),
    );
  }

  Widget _buildListItem(Map<String, dynamic> item, {required int index}) {
    final itemContent = item['content'] as List<dynamic>? ?? [];
    final textContent = _extractTextContentFromListItems(itemContent);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, right: 12),
            child: Text(
              '$index.',
              style: GoogleFonts.lato(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
            ),
          ),
          Expanded(
            child: _buildRichText(textContent),
          ),
        ],
      ),
    );
  }

  Widget _buildRichText(List<dynamic> content) {
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

    return RichText(
      text: TextSpan(children: textSpans),
      textAlign: TextAlign.justify,
    );
  }

  List<dynamic> _extractTextContentFromListItems(List<dynamic> itemContent) {
    final textNodes = <dynamic>[];

    for (final node in itemContent) {
      if (node is Map<String, dynamic>) {
        final type = node['type'] as String? ?? '';

        if (type == 'paragraph') {
          final paragraphContent = node['content'] as List<dynamic>? ?? [];
          textNodes.addAll(paragraphContent);
        } else if (type == 'text') {
          textNodes.add(node);
        } else if (node['content'] != null) {
          final nestedContent = _extractTextContentFromListItems(
            node['content'] as List<dynamic>,
          );
          textNodes.addAll(nestedContent);
        }
      }
    }

    return textNodes;
  }
}

