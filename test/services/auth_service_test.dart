import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:launch_quality_mobile/models/app_user.dart';
import 'package:launch_quality_mobile/services/api_client.dart';
import 'package:launch_quality_mobile/services/auth_service.dart';

// Manual mock classes — avoids build_runner code generation.
class MockApiClient extends Mock implements ApiClient {}

Map<String, dynamic> _userJson({
  String id = '1',
  String username = 'testuser',
  String name = 'Test User',
  String role = 'admin',
  bool active = true,
}) =>
    {
      'id': id,
      'username': username,
      'name': name,
      'role': role,
      'active': active,
    };

Map<String, dynamic> _meResponse({List<String> permissions = const []}) => {
      'user': _userJson(),
      'permissions': permissions,
    };

void main() {
  group('AuthService', () {
    late MockApiClient mockApi;
    late AuthService authService;

    setUp(() {
      mockApi = MockApiClient();
      authService = AuthService(mockApi);
      // Initialise SharedPreferences with empty values for every test.
      SharedPreferences.setMockInitialValues({});
    });

    // ─── login ──────────────────────────────────────────────────────────────
    group('login', () {
      test('login success stores token and sets user', () async {
        when(mockApi.post('login', body: anyNamed('body')))
            .thenAnswer((_) async => {'token': 'jwt-abc'});
        when(mockApi.get('me'))
            .thenAnswer((_) async => _meResponse(permissions: ['all']));

        final user = await authService.login('testuser', 'secret');

        expect(user.username, 'testuser');
        expect(authService.user, isNotNull);
        verify(mockApi.setToken('jwt-abc')).called(1);
      });

      test('login throws ApiException when token is empty', () async {
        when(mockApi.post('login', body: anyNamed('body')))
            .thenAnswer((_) async => {'token': ''});

        await expectLater(
          authService.login('user', 'pass'),
          throwsA(isA<ApiException>()),
        );
      });

      test('login propagates ApiException from server', () async {
        when(mockApi.post('login', body: anyNamed('body')))
            .thenThrow(ApiException('Invalid username or password', statusCode: 401));

        await expectLater(
          authService.login('bad', 'creds'),
          throwsA(isA<ApiException>()),
        );
      });

      test('login trims username whitespace', () async {
        when(mockApi.post('login', body: anyNamed('body')))
            .thenAnswer((_) async => {'token': 'tok'});
        when(mockApi.get('me')).thenAnswer((_) async => _meResponse());

        await authService.login('  spaces  ', 'pw');

        final captured =
            verify(mockApi.post('login', body: captureAnyNamed('body')))
                .captured;
        final body = captured.first as Map<String, dynamic>;
        expect(body['username'], 'spaces');
      });
    });

    // ─── logout ─────────────────────────────────────────────────────────────
    group('logout', () {
      test('logout clears user and token', () async {
        // Pre-seed a session.
        when(mockApi.post('login', body: anyNamed('body')))
            .thenAnswer((_) async => {'token': 'tok'});
        when(mockApi.get('me')).thenAnswer((_) async => _meResponse());
        await authService.login('u', 'p');

        when(mockApi.post('logout', body: anyNamed('body')))
            .thenAnswer((_) async => <String, dynamic>{});

        await authService.logout();

        expect(authService.user, isNull);
        verify(mockApi.setToken(null)).called(1);
      });

      test('logout succeeds even if API call throws', () async {
        when(mockApi.post('logout', body: anyNamed('body')))
            .thenThrow(ApiException('Network error'));

        // Should not throw.
        await authService.logout();

        expect(authService.user, isNull);
      });
    });

    // ─── restoreSession ─────────────────────────────────────────────────────
    group('restoreSession', () {
      test('returns null when no saved token', () async {
        SharedPreferences.setMockInitialValues({});
        final user = await authService.restoreSession();
        expect(user, isNull);
      });

      test('restores user when valid token exists', () async {
        SharedPreferences.setMockInitialValues({
          'jawdah_cloud_token': 'saved-token',
        });
        when(mockApi.get('me')).thenAnswer((_) async => _meResponse());

        final user = await authService.restoreSession();

        expect(user, isNotNull);
        verify(mockApi.setToken('saved-token')).called(1);
      });
    });

    // ─── syncFromMe ─────────────────────────────────────────────────────────
    group('syncFromMe', () {
      test('sets user from /me response', () async {
        when(mockApi.get('me')).thenAnswer((_) async =>
            _meResponse(permissions: ['clients:read']));

        await authService.syncFromMe();

        expect(authService.user, isNotNull);
        expect(authService.user!.permissions, contains('clients:read'));
      });
    });

    // ─── userFromMe ─────────────────────────────────────────────────────────
    group('userFromMe', () {
      test('merges user data with permissions', () {
        final me = {
          'user': _userJson(id: '5', role: 'accountant'),
          'permissions': ['finance:read'],
        };

        final user = authService.userFromMe(me);

        expect(user.id, '5');
        expect(user.role, 'accountant');
        expect(user.permissions, ['finance:read']);
      });

      test('uses empty list when permissions key absent', () {
        final me = {'user': _userJson()};

        final user = authService.userFromMe(me);

        expect(user.permissions, isEmpty);
      });
    });
  });
}
