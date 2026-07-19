FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app

COPY pubspec.yaml pubspec.lock ./
COPY analysis_options.yaml ./
COPY lib ./lib
COPY assets ./assets
COPY web ./web

RUN flutter pub get
RUN flutter build web --release \
  --dart-define=API_BASE_URL=https://web-production-08d73.up.railway.app/api

FROM nginx:alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

COPY --from=build /app/build/web /usr/share/nginx/html

ENV PORT=8080
EXPOSE 8080

ENTRYPOINT ["/docker-entrypoint.sh"]
