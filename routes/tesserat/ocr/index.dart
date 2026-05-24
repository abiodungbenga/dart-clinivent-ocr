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
  try {
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
    final mimeType = uploadedFile?.contentType.mimeType ?? '';

    if (uploadedFile == null) {
      return Response.json(
          statusCode: 400, body: {"message": "No image uploaded"});
    }

    if (!mimeType.startsWith('image/')) {
      return Response.json(
        statusCode: 400,
        body: {
          "message": "Uploaded file is not an image",
        },
      );
    }

    final ocr = context.read<OcrRepository>();

    if (language.isNotEmpty && language != 'osd' && language != "eng") {
      return Response.json(
          statusCode: 400,
          body: {"message": "Invalid language only osd and eng"});
    }

    final result = await ocr.generate(uploadedFile, language);
    return Response.json(
      body: {'result': result},
    );
  } catch (e) {
    return Response.json(
      statusCode: 400,
      body: {'message': e.toString()},
    );
  }
}
