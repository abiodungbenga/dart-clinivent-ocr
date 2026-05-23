FROM dart:stable AS build

RUN apt-get update && apt-get install -y \
    tesseract-ocr \
    libtesseract-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY pubspec.* ./
RUN dart pub get
COPY . .

RUN dart_frog build

EXPOSE 8080

CMD ["dart", "run", "build/bin/server.dart"]