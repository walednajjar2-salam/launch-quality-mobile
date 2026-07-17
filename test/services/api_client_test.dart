import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import 'package:launch_quality_mobile/services/api_client.dart';

// Manual mock — no build_runner needed.
class MockHttpClient extends Mock implements http.Client {}

void main() {
  group('ApiClient', () {
    late MockHttpClient mockHttp;
    late ApiClient client;

    setUp(() {
      mockHttp = MockHttpClient();
      client = ApiClient(client: mockHttp);
    });

    tearDown(() {
      client.dispose();
    });

    // ─── GET ────────────────────────────────────────────────────────────────
    group('GET requests', () {
      test('successful GET returns decoded map', () async {
        final responseBody = jsonEncode({'ok': true, 'id': '1', 'name': 'Test'});
        when(mockHttp.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => http.Response(responseBody, 200),
        );

        final result = await client.get('/users/1');
        expect(result['id'], '1');
        expect(result['name'], 'Test');
        verify(mockHttp.get(any, headers: anyNamed('headers'))).called(1);
      });

      test('GET with 4xx status throws ApiException', () async {
        when(mockHttp.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => http.Response(jsonEncode({'error': 'Not Found'}), 404),
        );

        await expectLater(
          client.get('/nonexistent'),
          throwsA(isA<ApiException>()),
        );
      });

      test('GET with 500 throws ApiException', () async {
        when(mockHttp.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async =>
              http.Response(jsonEncode({'error': 'Internal Error'}), 500),
        );

        await expectLater(
          client.get('/error'),
          throwsA(isA<ApiException>()),
        );
      });

      test('GET with ok=false throws ApiException', () async {
        when(mockHttp.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async =>
              http.Response(jsonEncode({'ok': false, 'error': 'Bad'}), 200),
        );

        await expectLater(
          client.get('/bad'),
          throwsA(isA<ApiException>()),
        );
      });

      test('GET with empty body returns empty map', () async {
        when(mockHttp.get(any, headers: anyNamed('headers')))
            .thenAnswer((_) async => http.Response('', 200));

        final result = await client.get('/empty');
        expect(result, isEmpty);
      });

      test('GET includes Authorization header when token is set', () async {
        client.setToken('test-token-abc');
        when(mockHttp.get(any, headers: anyNamed('headers')))
            .thenAnswer((_) async => http.Response('{}', 200));

        await client.get('/protected');

        final captured =
            verify(mockHttp.get(any, headers: captureAnyNamed('headers')))
                .captured;

        final headers = captured.first as Map<String, String>;
        expect(headers['Authorization'], contains('test-token-abc'));
      });

      test('GET omits Authorization header when no token', () async {
        // no token set
        when(mockHttp.get(any, headers: anyNamed('headers')))
            .thenAnswer((_) async => http.Response('{}', 200));

        await client.get('/public');

        final captured =
            verify(mockHttp.get(any, headers: captureAnyNamed('headers')))
                .captured;

        final headers = captured.first as Map<String, String>;
        expect(headers.containsKey('Authorization'), isFalse);
      });
    });

    // ─── POST ───────────────────────────────────────────────────────────────
    group('POST requests', () {
      test('successful POST returns decoded map', () async {
        final responseBody =
            jsonEncode({'ok': true, 'token': 'tok123'});
        when(mockHttp.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response(responseBody, 200));

        final result = await client.post('/login', body: {'user': 'me'});
        expect(result['token'], 'tok123');
        verify(mockHttp.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).called(1);
      });

      test('POST with 400 throws ApiException', () async {
        when(mockHttp.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer(
          (_) async =>
              http.Response(jsonEncode({'error': 'Bad Request'}), 400),
        );

        await expectLater(
          client.post('/users', body: {}),
          throwsA(isA<ApiException>()),
        );
      });

      test('POST sends Content-Type: application/json header', () async {
        when(mockHttp.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response('{}', 200));

        await client.post('/data', body: {'key': 'val'});

        final captured = verify(mockHttp.post(
          any,
          headers: captureAnyNamed('headers'),
          body: anyNamed('body'),
        )).captured;

        final headers = captured.first as Map<String, String>;
        expect(headers['Content-Type'], contains('application/json'));
      });
    });

    // ─── PUT ────────────────────────────────────────────────────────────────
    group('PUT requests', () {
      test('successful PUT returns decoded map', () async {
        when(mockHttp.put(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer(
          (_) async =>
              http.Response(jsonEncode({'ok': true, 'updated': true}), 200),
        );

        final result = await client.put('/item/1', body: {'name': 'New'});
        expect(result['updated'], isTrue);
      });
    });

    // ─── DELETE ─────────────────────────────────────────────────────────────
    group('DELETE requests', () {
      test('successful DELETE returns decoded map', () async {
        when(mockHttp.delete(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => http.Response(jsonEncode({'ok': true}), 200),
        );

        final result = await client.delete('/item/1');
        expect(result['ok'], isTrue);
      });

      test('DELETE with 403 throws ApiException', () async {
        when(mockHttp.delete(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async =>
              http.Response(jsonEncode({'error': 'Permission denied'}), 403),
        );

        await expectLater(
          client.delete('/item/1'),
          throwsA(isA<ApiException>()),
        );
      });
    });

    // ─── Token management ───────────────────────────────────────────────────
    group('token management', () {
      test('setToken stores token', () {
        client.setToken('my-token');
        expect(client.token, 'my-token');
      });

      test('setToken(null) clears token', () {
        client.setToken('some-token');
        client.setToken(null);
        expect(client.token, isNull);
      });
    });

    // ─── Error message mapping ───────────────────────────────────────────────
    group('error message mapping', () {
      test('maps permission denied message', () async {
        when(mockHttp.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => http.Response(
            jsonEncode({'error': 'Permission denied'}),
            403,
          ),
        );

        try {
          await client.get('/restricted');
          fail('Expected ApiException');
        } on ApiException catch (e) {
          expect(e.message, isNotEmpty);
        }
      });

      test('maps invalid credentials message', () async {
        when(mockHttp.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer(
          (_) async => http.Response(
            jsonEncode({'error': 'Invalid username or password'}),
            401,
          ),
        );

        try {
          await client.post('/login', body: {});
          fail('Expected ApiException');
        } on ApiException catch (e) {
          expect(e.message, isNotEmpty);
          expect(e.statusCode, 401);
        }
      });
    });
  });
}
