import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../../../core/repositories/ocr/ocr_repository.dart';
import '../../../core/utils/functions.dart';

Future<Response> onRequest(RequestContext context) {
  // TODO: implement route handler
  return switch (context.request.method) {
    HttpMethod.post => _generateOcr(
        context,
      ),
    _ => Future.value(
        Response(statusCode: HttpStatus.methodNotAllowed),
      ),
  };
}

Future<Response> _generateOcr(RequestContext context) async {
  final request = context.request;
  final contentType = request.headers['content-type'];
  if (contentType == null || contentType.isEmpty) {
    return Response.json(
      statusCode: 400,
      body: {'message': 'Missing Content-Type header'},
    );
  }

  if (!contentType.contains('multipart/form-data')) {
    return Response.json(
      statusCode: 415,
      body: {'message': 'Invalid Content-Type. Use multipart/form-data'},
    );
  }
  final formData = await request.formData();

  final uploadedFile = formData.files['file'];

  final language = formData.fields['language'] ?? 'eng';

  if (uploadedFile == null) {
    return Response.json(
        statusCode: 400, body: {"message": "No image uploaded"});
  }

  final ocr = context.read<OcrRepository>();

  final dirPath = 'uploads/ocr';
  await Functions.ensureDirExists(dirPath);

  final tempPath =
      '$dirPath/${DateTime.now().millisecondsSinceEpoch}_${uploadedFile.name}';

  if (language.isNotEmpty && language != 'osd' && language != "eng") {
    return Response.json(
        statusCode: 400,
        body: {"message": "Invalid language only osd and eng"});
  }

  final file = File(tempPath);
  await file.writeAsBytes(await uploadedFile.readAsBytes());
  final result = await ocr.generate(tempPath, language);

  await file.delete();
  return Response.json(
    body: {'result': result},
  );
}
