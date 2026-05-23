FROM dart:stable AS build

# Install Dart Frog CLI
RUN dart pub global activate dart_frog_cli

# Add pub cache to PATH
ENV PATH="$PATH:/root/.pub-cache/bin"

# Install system dependencies (Tesseract)
RUN apt-get update && apt-get install -y \
    tesseract-ocr \
    libtesseract-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY pubspec.* ./
RUN dart pub get

COPY . .

# NOW dart_frog command will work
RUN dart_frog build

EXPOSE 8080

CMD ["dart", "run", "build/bin/server.dart"]