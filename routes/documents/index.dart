import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../../core/repositories/docs/docs_repository.dart';
import '../../core/utils/functions.dart';

Future<Response> onRequest(RequestContext context) {
  // TODO: implement route handler
  return switch (context.request.method) {
    HttpMethod.post => _extractText(
        context,
      ),
    _ => Future.value(
        Response(statusCode: HttpStatus.methodNotAllowed),
      ),
  };
}

Future<Response> _extractText(RequestContext context) async {
  final request = context.request;
  final contentType = request.headers['content-type'];
  if (contentType == null || contentType.isEmpty) {
    return Response(
      statusCode: 400,
      body: 'Missing Content-Type header',
    );
  }

  if (!contentType.contains('multipart/form-data')) {
    return Response(
      statusCode: 415,
      body: 'Invalid Content-Type. Use multipart/form-data',
    );
  }
  final formData = await request.formData();

  final uploadedFile = formData.files['file'];

  if (uploadedFile == null) {
    return Response(statusCode: 400, body: 'No image uploaded');
  }

  final extractor = context.read<DocsRepository>();
  final result = await extractor.extractFromDocs(
    uploadedFile,
  );
  return Response.json(
    body: {'result': result},
  );
}
