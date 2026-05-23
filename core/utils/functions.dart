import 'dart:io';

class Functions {
  static Future<void> ensureDirExists(String path) async {
    final dir = Directory(path);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
  }
}
