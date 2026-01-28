import 'package:bandhucare_new/core/export_file/app_exports.dart';

import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

/// Renders text nodes with marks into TextSpan widgets
class TextSpanRenderer {
  /// Renders a text node with its marks into a TextSpan
  static TextSpan renderTextNode(
    Map<String, dynamic> node,
    TextStyle defaultStyle,
  ) {
    final text = node['text'] as String? ?? '';
    final marks = node['marks'] as List<dynamic>? ?? [];

    TextStyle style = defaultStyle;
    GestureTapCallback? onTap;

    // Apply marks to style
    for (final mark in marks) {
      if (mark is Map<String, dynamic>) {
        final markType = mark['type'] as String? ?? '';
        final attrs = mark['attrs'] as Map<String, dynamic>? ?? {};

        switch (markType) {
          case 'bold':
            style = style.copyWith(fontWeight: FontWeight.bold);
            break;
          case 'italic':
            style = style.copyWith(fontStyle: FontStyle.italic);
            break;
          case 'strike':
            style = style.copyWith(decoration: TextDecoration.lineThrough);
            break;
          case 'code':
            style = style.copyWith(
              fontFamily: 'Courier',
              backgroundColor: Colors.grey[200],
              color: Colors.red[700],
            );
            break;
          case 'superscript':
            style = style.copyWith(
              fontSize: (style.fontSize ?? 16) * 0.7,
            );
            break;
          case 'subscript':
            style = style.copyWith(
              fontSize: (style.fontSize ?? 16) * 0.7,
            );
            break;
          case 'highlight':
            final color = attrs['color'] as String? ?? '';
            Color? highlightColor;

            if (color.contains('yellow')) {
              highlightColor = Colors.yellow[300];
            } else if (color.contains('blue')) {
              highlightColor = Colors.blue[200];
            } else {
              highlightColor = Colors.yellow[300];
            }

            style = style.copyWith(backgroundColor: highlightColor);
            break;
          case 'textStyle':
            final colorValue = attrs['color'] as String? ?? '';
            final parsedColor = _colorFromHex(colorValue);
            if (parsedColor != null) {
              style = style.copyWith(color: parsedColor);
            }
            break;
          case 'link':
            final href = attrs['href'] as String? ?? '';
            style = style.copyWith(
              color: AppColors.primaryColor,
              decoration: TextDecoration.underline,
            );
            if (href.isNotEmpty) {
              onTap = () {
                launchUrl(
                  Uri.parse(href),
                  mode: LaunchMode.externalApplication,
                );
              };
            }
            break;
        }
      }
    }

    return TextSpan(
      text: text,
      style: style,
      recognizer: onTap != null
          ? (TapGestureRecognizer()..onTap = onTap)
          : null,
    );
  }

  /// Extracts plain text from a node and its children
  static String extractPlainText(Map<String, dynamic> node) {
    if (node['type'] == 'text') {
      return node['text'] as String? ?? '';
    }

    if (node['content'] == null) return '';

    final buffer = StringBuffer();
    final content = node['content'] as List<dynamic>? ?? [];

    for (final item in content) {
      if (item is Map<String, dynamic>) {
        buffer.write(extractPlainText(item));
      }
    }

    return buffer.toString();
  }

  /// Flattens nested content structure to extract all text nodes
  static List<dynamic> flattenContent(List<dynamic> content) {
    final flattened = <dynamic>[];

    for (final item in content) {
      if (item is Map<String, dynamic>) {
        final type = item['type'] as String? ?? '';

        if (type == 'paragraph' || type == 'heading') {
          final nestedContent = item['content'] as List<dynamic>? ?? [];
          flattened.addAll(flattenContent(nestedContent));
        } else if (type == 'text' || type == 'hardBreak') {
          flattened.add(item);
        } else if (item['content'] != null) {
          final nestedContent = item['content'] as List<dynamic>? ?? [];
          flattened.addAll(flattenContent(nestedContent));
        } else {
          flattened.add(item);
        }
      }
    }

    return flattened;
  }
}

Color? _colorFromHex(String hexColor) {
  if (hexColor.isEmpty) return null;

  var cleaned = hexColor.trim();
  if (cleaned.startsWith('#')) {
    cleaned = cleaned.substring(1);
  }

  if (cleaned.length == 6) {
    cleaned = 'FF$cleaned';
  }

  final colorInt = int.tryParse(cleaned, radix: 16);
  if (colorInt == null) return null;

  return Color(colorInt);
}
