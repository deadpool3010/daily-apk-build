import 'package:bandhucare_new/presentation/blog_screen/widgets/tiptap/base/renderer_registry.dart';
import 'package:bandhucare_new/presentation/blog_screen/widgets/tiptap/renderers/blockquote_renderer.dart';
import 'package:bandhucare_new/presentation/blog_screen/widgets/tiptap/renderers/bullet_list_renderer.dart';
import 'package:bandhucare_new/presentation/blog_screen/widgets/tiptap/renderers/code_block_renderer.dart';
import 'package:bandhucare_new/presentation/blog_screen/widgets/tiptap/renderers/heading_renderer.dart';
import 'package:bandhucare_new/presentation/blog_screen/widgets/tiptap/renderers/horizontal_rule_renderer.dart';
import 'package:bandhucare_new/presentation/blog_screen/widgets/tiptap/renderers/ordered_list_renderer.dart';
import 'package:bandhucare_new/presentation/blog_screen/widgets/tiptap/renderers/paragraph_renderer.dart';
import 'package:bandhucare_new/presentation/blog_screen/widgets/tiptap/renderers/task_list_renderer.dart';

/// Registers all TipTap node renderers
/// 
/// Call this function once during app startup (e.g., in main())
/// to register all available renderers.
void registerTiptapRenderers() {
  // Clear any existing renderers
  RendererRegistry.clear();

  // Register all node renderers
  RendererRegistry.register('paragraph', ParagraphRenderer());
  RendererRegistry.register('heading', HeadingRenderer());
  RendererRegistry.register('bulletList', BulletListRenderer());
  RendererRegistry.register('orderedList', OrderedListRenderer());
  RendererRegistry.register('taskList', TaskListRenderer());
  RendererRegistry.register('codeBlock', CodeBlockRenderer());
  RendererRegistry.register('blockquote', BlockquoteRenderer());
  RendererRegistry.register('horizontalRule', HorizontalRuleRenderer());
}

