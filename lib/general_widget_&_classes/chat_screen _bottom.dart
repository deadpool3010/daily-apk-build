//import 'package:bandhucare_new/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class ChatScreenBottom extends StatefulWidget {
  final TextEditingController messageController;
  final Function(String) onSend;

  const ChatScreenBottom({
    super.key,
    required this.messageController,
    required this.onSend,
  });

  @override
  State<ChatScreenBottom> createState() => _ChatScreenBottomState();
}

class _ChatScreenBottomState extends State<ChatScreenBottom> {
  bool _hasText = false;
  bool _isKeyboardVisible = false;
  late final KeyboardVisibilityController _keyboardVisibilityController;
  @override
  void initState() {
    super.initState();

    // Keyboard visibility listener from flutter_keyboard_visibility
    _keyboardVisibilityController = KeyboardVisibilityController();
    _isKeyboardVisible = _keyboardVisibilityController.isVisible;
    _keyboardVisibilityController.onChange.listen((visible) {
      if (mounted && visible != _isKeyboardVisible) {
        setState(() => _isKeyboardVisible = visible);
      }
    });

    widget.messageController.addListener(() {
      final hasTextNow = widget.messageController.text.trim().isNotEmpty;
      if (hasTextNow != _hasText) {
        setState(() => _hasText = hasTextNow);
      }
    });
  }

  @override
  void dispose() {
    // Do NOT dispose messageController here; it is owned by parent (ChatBotScreen)
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isKeyboardOpen = _isKeyboardVisible;

    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double headerToolbarHeight = isKeyboardOpen ? 70.0 : 94.0;
    final double totalHeaderHeight = statusBarHeight + headerToolbarHeight;

    return Container(
      width: double.infinity,
      height: totalHeaderHeight,
      color: const Color(0xFFEDF2F7),

      /// 🔥 Keyboard open → small padding
      /// 🔥 Keyboard closed → larger padding
      padding: EdgeInsets.fromLTRB(16, 0, 16, isKeyboardOpen ? 10 : 30),

      child: Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          children: [
            // LEFT CIRCLE PLUS BUTTON
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  // TODO: attachments
                },
                borderRadius: BorderRadius.circular(22),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: Color(0xFFCBD5E0),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add,
                    size: 26,
                    color: Color(0xFF4A5568),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // TEXT FIELD + SEND BUTTON
            Expanded(
              child: Container(
                height: 50,
                decoration: ShapeDecoration(
                  color: const Color(0xFFCBD5E0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),

                    // TEXT FIELD
                    Expanded(
                      child: TextField(
                        controller: widget.messageController,
                        textAlignVertical: TextAlignVertical.center,
                        onSubmitted: (text) => widget.onSend(text),
                        decoration: InputDecoration(
                          hintText: 'Hi, How can I help you today?',
                          hintStyle: TextStyle(
                            color: Colors.black.withOpacity(0.32),
                            fontSize: 16,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w400,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    // SEND / MIC BUTTON
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          if (_hasText) {
                            widget.onSend(widget.messageController.text);
                          } else {
                            // TODO: record audio toggle
                          }
                        },
                        borderRadius: BorderRadius.circular(18),
                        child: Container(
                          width: 35,
                          height: 35,
                          padding: const EdgeInsets.all(5),
                          decoration: ShapeDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment(0.41, 1.00),
                              end: Alignment(0.51, 0.04),
                              colors: [Color(0xFF6595FF), Color(0xFF3865FF)],
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(17.50),
                            ),
                          ),
                          child: Center(
                            child: Center(
                              child: _hasText
                                  ? Icon(
                                      Icons.arrow_upward,
                                      color: Colors.white,
                                      size: 24,
                                    )
                                  : Icon(
                                      Icons.mic_none,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
