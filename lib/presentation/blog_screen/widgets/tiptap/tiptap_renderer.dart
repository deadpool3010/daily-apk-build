import 'package:bandhucare_new/presentation/blog_screen/widgets/tiptap/base/renderer_registry.dart';
import 'package:flutter/material.dart';

/// Main TipTap renderer that walks the document tree and delegates to registered renderers
class TiptapRenderer extends StatelessWidget {
  final Map<String, dynamic> document;

  const TiptapRenderer({
    super.key,
    required this.document,
  });

  @override
  Widget build(BuildContext context) {
    final content = document['content'] as List<dynamic>? ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: content.map<Widget>((node) {
        return _renderNode(node);
      }).toList(),
    );
  }

  /// Renders a single node by looking up its renderer in the registry
  Widget _renderNode(Map<String, dynamic> node) {
    final type = node['type'] as String? ?? '';
    
    if (type.isEmpty) {
      return const SizedBox.shrink();
    }

    final renderer = RendererRegistry.get(type);
    
    if (renderer != null) {
      return renderer.render(node);
    }

    // Gracefully handle unknown node types
    return const SizedBox.shrink();
  }
}

