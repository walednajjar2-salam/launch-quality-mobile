import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:launch_quality_mobile/services/api_client.dart';

void main() {
  group('ApiClient', () {
    test('successful GET request', () async {
      final client = ApiClient(
        client: MockClient((request) async {
          expect(request.method, 'GET');
          return http.Response(jsonEncode({'ok': true, 'value': 10}), 200);
        }),
      );

      final response = await client.get('dashboard');
      expect(response['value'], 10);
    });

    test('successful POST request', () async {
      final client = ApiClient(
        client: MockClient((request) async {
          expect(request.method, 'POST');
          expect(request.body, jsonEncode({'name': 'test'}));
          return http.Response(jsonEncode({'ok': true, 'id': '1'}), 200);
        }),
      );

      final response = await client.post('items', body: {'name': 'test'});
      expect(response['id'], '1');
    });

    test('404 error handling', () async {
      final client = ApiClient(
        client: MockClient(
          (_) async => http.Response(jsonEncode({'ok': false, 'error': 'Not Found'}), 404),
        ),
      );

      expect(
        () => client.get('missing'),
        throwsA(
          isA<ApiException>()
              .having((e) => e.statusCode, 'statusCode', 404)
              .having((e) => e.message, 'message', 'Not Found'),
        ),
      );
    });

    test('500 error handling', () async {
      final client = ApiClient(
        client: MockClient(
          (_) async => http.Response(jsonEncode({'ok': false, 'error': 'Server Error'}), 500),
        ),
      );

      expect(
        () => client.get('broken'),
        throwsA(
          isA<ApiException>()
              .having((e) => e.statusCode, 'statusCode', 500)
              .having((e) => e.message, 'message', 'Server Error'),
        ),
      );
    });

    test('timeout handling', () async {
      final client = ApiClient(
        client: MockClient((_) async {
          await Future<void>.delayed(const Duration(milliseconds: 50));
          return http.Response(jsonEncode({'ok': true}), 200);
        }),
      );

      expect(
        () => client.get('slow', timeout: const Duration(milliseconds: 1)),
        throwsA(isA<TimeoutException>()),
      );
    });

    test('request headers include content headers', () async {
      final client = ApiClient(
        client: MockClient((request) async {
          expect(request.headers['Content-Type'], 'application/json');
          expect(request.headers['Accept'], 'application/json');
          return http.Response(jsonEncode({'ok': true}), 200);
        }),
      );

      await client.get('headers');
    });

    test('authentication header added when token exists', () async {
      final client = ApiClient(
        client: MockClient((request) async {
          expect(request.headers['Authorization'], '******');
          return http.Response(jsonEncode({'ok': true}), 200);
        }),
      )..setToken('test-token');

      await client.get('auth');
    });
  });
}
