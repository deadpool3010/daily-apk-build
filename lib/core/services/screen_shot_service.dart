import 'package:no_screenshot/no_screenshot.dart';

class ScreenShotService {
  ScreenShotService._();

  static final ScreenShotService screenShotService = ScreenShotService._();

  final _noScreenShot = NoScreenshot.instance;

  Future<void> disable() async {
    _noScreenShot.screenshotOff();
  }

  Future<void> enable() async {
    _noScreenShot.screenshotOn();
  }
}
