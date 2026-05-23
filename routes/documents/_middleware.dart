import 'package:dart_frog/dart_frog.dart';

import '../../core/repositories/docs/docs_repository.dart';

Middleware _provideDocsRepository() {
  return provider(
    (context) => DocsRepository(),
  );
}

Handler middleware(Handler handler) {
  // TODO: implement middleware
  return handler.use(requestLogger()).use(_provideDocsRepository());
}
