import 'package:flutter/material.dart';

/// Base interface for all TipTap node renderers
abstract class NodeRenderer {
  /// Renders a TipTap node into a Flutter widget
  Widget render(Map<String, dynamic> node);
}

