import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class FastLongPress extends StatelessWidget {
  final VoidCallback onStart;
  final VoidCallback onEnd;

  const FastLongPress({super.key, required this.onStart, required this.onEnd});

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      gestures: {
        FastLongPressGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<
              FastLongPressGestureRecognizer
            >(
              () => FastLongPressGestureRecognizer(
                duration: const Duration(milliseconds: 150), // 👈 FAST PRESS
              ),
              (LongPressGestureRecognizer instance) {
                instance.onLongPressStart = (_) => onStart();
                instance.onLongPressEnd = (_) => onEnd();
              },
            ),
      },
      child: CircleAvatar(
        radius: 32,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.mic, color: Colors.white),
      ),
    );
  }
}

class FastLongPressGestureRecognizer extends LongPressGestureRecognizer {
  FastLongPressGestureRecognizer({required Duration duration})
    : super(duration: duration);
}
