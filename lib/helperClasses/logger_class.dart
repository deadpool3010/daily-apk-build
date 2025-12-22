import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileLogger {
  static Future<File> _getLogFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/fcm_logs.txt');
  }

  static Future<void> log(String message) async {
    final file = await _getLogFile();
    final time = DateTime.now().toIso8601String();
    await file.writeAsString(
      '[$time] $message\n',
      mode: FileMode.append,
      flush: true,
    );
  }
}
