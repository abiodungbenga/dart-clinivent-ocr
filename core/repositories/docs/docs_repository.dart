import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../../utils/functions.dart';

class DocsRepository {
  // Future<String> extractFromPdf(File file) async {
  //   PDFDoc doc = await PDFDoc.fromFile(file);
  //   return doc.text;
  // }

  Future<String> extractFromDocs(UploadedFile uploadedFile) async {
    try {
      final dirPath = 'uploads/extract';
      await Functions.ensureDirExists(dirPath);

      final tempPath =
          '$dirPath/${DateTime.now().millisecondsSinceEpoch}_${uploadedFile.name}';

      final file = File(tempPath);
      await file.writeAsBytes(await uploadedFile.readAsBytes());
      if (file.path.endsWith('.pdf')) {
        return Future.value('Not available yet!');
      } else {
        return readTxtFile(file.path).whenComplete(() => file.delete());
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<String> readTxtFile(String path) async {
    final file = File(path);

    if (!await file.exists()) {
      throw Exception('File not found');
    }

    return await file.readAsString();
  }
}
