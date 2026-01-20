import 'package:bandhucare_new/core/export_file/app_exports.dart';

import 'package:bandhucare_new/presentation/blog_screen/widgets/tiptap/base/node_renderer.dart';
import 'package:bandhucare_new/presentation/blog_screen/widgets/tiptap/renderers/text_span_renderer.dart';
import 'package:flutter/material.dart';

/// Renders TipTap task list nodes (checkboxes)
class TaskListRenderer implements NodeRenderer {
  @override
  Widget render(Map<String, dynamic> node) {
    final content = node['content'] as List<dynamic>? ?? [];

    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 8, right: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: content.map((item) => _buildTaskItem(item)).toList(),
      ),
    );
  }

  Widget _buildTaskItem(Map<String, dynamic> item) {
    final attrs = item['attrs'] as Map<String, dynamic>? ?? {};
    final checked = attrs['checked'] as bool? ?? false;
    final itemContent = item['content'] as List<dynamic>? ?? [];
    final textContent = _extractTextContentFromListItems(itemContent);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4, right: 12),
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: checked ? AppColors.primaryColor : Colors.transparent,
              border: Border.all(
                color: AppColors.primaryColor,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: checked
                ? Icon(
                    Icons.check,
                    size: 14,
                    color: Colors.white,
                  )
                : null,
          ),
          Expanded(
            child: _buildRichText(
              textContent,
              checked: checked,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRichText(List<dynamic> content, {required bool checked}) {
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
                decoration: checked ? TextDecoration.lineThrough : null,
                decorationColor: Colors.grey,
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

