import 'dart:io';

class OcrRepository {
  // Future<String> ocr(String imagePath) async {
  //   final receivePort = ReceivePort();
  //   final sendPort = receivePort.sendPort;
  //   final args = [sendPort, imagePath];
  //   await Isolate.spawn(_ocrWorker, args);
  //   final result = await receivePort.first as String;
  //   receivePort.close();
  //   return result;
  // }

  // static void _ocrWorker(List<dynamic> args) {
  //   final sendPort = args[0] as SendPort;
  //   final imagePath = args[1] as String;
  //   sendPort.send(_ocr(imagePath));
  // }

  Future<String> generate(String imagePath, String language) async {
    try {
      const outputBase = 'result';

      String getTesseractPath() {
        if (Platform.isWindows) {
          return r'C:\Program Files\Tesseract-OCR\tesseract.exe';
        }
        return 'tesseract';
      }

      final process = await Process.run(
        getTesseractPath(),
        [imagePath, outputBase, "--psm", "6", "-l", language],
      );

      if (process.exitCode != 0) {
        throw Exception(process.stderr);
      }

      return File('$outputBase.txt').readAsString();
    } catch (e) {
      return Future.error(e);
    }
  }
}
