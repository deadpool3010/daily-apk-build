import 'dart:async';

class TextStreamer {
  static Stream<String> stream(String text, {int speed = 30}) async* {
    String current = '';
    for (int i = 0; i < text.length; i++) {
      current += text[i];
      yield current;
      await Future.delayed(Duration(milliseconds: speed));
    }
  }
}
