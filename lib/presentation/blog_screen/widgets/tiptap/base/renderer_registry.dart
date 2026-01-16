import 'package:bandhucare_new/presentation/blog_screen/widgets/tiptap/base/node_renderer.dart';

/// Centralized registry for TipTap node renderers
/// 
/// This registry allows for extensible rendering of TipTap nodes.
/// Each node type must be registered before use.
class RendererRegistry {
  static final Map<String, NodeRenderer> _renderers = {};

  /// Register a renderer for a specific node type
  static void register(String type, NodeRenderer renderer) {
    _renderers[type] = renderer;
  }

  /// Get a renderer for a specific node type
  /// Returns null if no renderer is registered for the type
  static NodeRenderer? get(String type) {
    return _renderers[type];
  }

  /// Check if a renderer is registered for a node type
  static bool has(String type) {
    return _renderers.containsKey(type);
  }

  /// Clear all registered renderers
  static void clear() {
    _renderers.clear();
  }
}

