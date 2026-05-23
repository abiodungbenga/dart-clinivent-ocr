import 'package:dart_frog/dart_frog.dart';

import '../../../core/repositories/ocr/ocr_repository.dart';

Middleware _provideOcrRepository() {
  return provider(
    (context) => OcrRepository(),
  );
}

Handler middleware(Handler handler) {
  return handler.use(requestLogger()).use(_provideOcrRepository());
}
