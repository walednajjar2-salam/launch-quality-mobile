import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:launch_quality_mobile/services/api_client.dart';
import 'package:launch_quality_mobile/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('AuthService', () {
    test('login success with valid credentials', () async {
      final api = ApiClient(
        client: MockClient((request) async {
          if (request.url.path.endsWith('/login')) {
            return http.Response(jsonEncode({'ok': true, 'token': 'abc'}), 200);
          }
          if (request.url.path.endsWith('/me')) {
            return http.Response(
              jsonEncode({
                'ok': true,
                'user': {
                  'id': '1',
                  'username': 'najjar',
                  'name': 'Najjar',
                  'role': 'owner',
                  'active': true,
                },
                'permissions': ['all'],
              }),
              200,
            );
          }
          return http.Response(jsonEncode({'ok': true}), 200);
        }),
      );
      final service = AuthService(api);

      final user = await service.login('najjar', 'password');
      final prefs = await SharedPreferences.getInstance();

      expect(user.username, 'najjar');
      expect(api.token, 'abc');
      expect(prefs.getString('jawdah_cloud_token'), 'abc');
    });

    test('login failure with invalid credentials', () async {
      final api = ApiClient(
        client: MockClient(
          (_) async => http.Response(
            jsonEncode({'ok': false, 'error': 'Invalid username or password'}),
            401,
          ),
        ),
      );
      final service = AuthService(api);

      expect(
        () => service.login('wrong', 'wrong'),
        throwsA(
          isA<ApiException>().having(
            (e) => e.message,
            'message',
            'اسم المستخدم أو كلمة المرور غير صحيحة',
          ),
        ),
      );
    });

    test('logout clears token and user', () async {
      final api = ApiClient(
        client: MockClient((request) async {
          if (request.url.path.endsWith('/login')) {
            return http.Response(jsonEncode({'ok': true, 'token': 'abc'}), 200);
          }
          if (request.url.path.endsWith('/me')) {
            return http.Response(
              jsonEncode({
                'ok': true,
                'user': {
                  'id': '1',
                  'username': 'najjar',
                  'name': 'Najjar',
                  'role': 'owner',
                  'active': true,
                },
                'permissions': ['all'],
              }),
              200,
            );
          }
          return http.Response(jsonEncode({'ok': true}), 200);
        }),
      );
      final service = AuthService(api);

      await service.login('najjar', 'password');
      await service.logout();
      final prefs = await SharedPreferences.getInstance();

      expect(api.token, isNull);
      expect(service.user, isNull);
      expect(prefs.getString('jawdah_cloud_token'), isNull);
    });

    test('session persistence restores user from saved token', () async {
      SharedPreferences.setMockInitialValues({'jawdah_cloud_token': 'saved-token'});
      var meCalled = false;
      final api = ApiClient(
        client: MockClient((request) async {
          if (request.url.path.endsWith('/me')) {
            meCalled = true;
            return http.Response(
              jsonEncode({
                'ok': true,
                'user': {
                  'id': '1',
                  'username': 'saved',
                  'name': 'Saved User',
                  'role': 'admin',
                  'active': true,
                },
                'permissions': ['projects:read'],
              }),
              200,
            );
          }
          return http.Response(jsonEncode({'ok': true}), 200);
        }),
      );
      final service = AuthService(api);

      final restored = await service.restoreSession();

      expect(meCalled, isTrue);
      expect(restored, isNotNull);
      expect(restored!.username, 'saved');
      expect(api.token, 'saved-token');
    });

    test('syncFromMe uses me endpoint', () async {
      var meCalled = 0;
      final api = ApiClient(
        client: MockClient((request) async {
          if (request.url.path.endsWith('/me')) {
            meCalled += 1;
            return http.Response(
              jsonEncode({
                'ok': true,
                'user': {
                  'id': '2',
                  'username': 'tester',
                  'name': 'Tester',
                  'role': 'viewer',
                  'active': true,
                },
                'permissions': ['clients:read'],
              }),
              200,
            );
          }
          return http.Response(jsonEncode({'ok': true}), 200);
        }),
      );
      final service = AuthService(api);

      await service.syncFromMe();

      expect(meCalled, 1);
      expect(service.user?.username, 'tester');
    });
  });
}
