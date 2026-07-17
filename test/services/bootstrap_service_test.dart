import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:launch_quality_mobile/models/app_user.dart';
import 'package:launch_quality_mobile/services/api_client.dart';
import 'package:launch_quality_mobile/services/bootstrap_service.dart';

void main() {
  group('BootstrapService', () {
    test('fetches dashboard bootstrap data', () async {
      final api = ApiClient(
        client: MockClient(
          (_) async => http.Response(
            jsonEncode({
              'ok': true,
              'data': {
                'projects': [
                  {'id': 'p1', 'name': 'Project'}
                ]
              },
              'dashboard': {
                'kpis': {'revenue': 1000}
              },
              'user': {
                'id': '1',
                'username': 'u',
                'name': 'User',
                'role': 'owner',
                'active': true,
              },
            }),
            200,
          ),
        ),
      );
      final service = BootstrapService(api);

      final result = await service.load();

      expect(result.table('projects'), hasLength(1));
      expect(result.kpis['revenue'], 1000);
    });

    test('kpi getter returns dashboard kpis map', () {
      final data = BootstrapData(
        data: const {},
        dashboard: const {
          'kpis': {'occupancy': 92}
        },
        user: AppUser.fromJson(const {
          'id': '1',
          'username': 'u',
          'name': 'User',
          'role': 'viewer',
          'active': true,
        }),
      );

      expect(data.kpis['occupancy'], 92);
    });

    test('throws error when no cache exists', () async {
      final api = ApiClient(
        client: MockClient(
          (_) async => http.Response(jsonEncode({'ok': false, 'error': 'Server down'}), 500),
        ),
      );
      final service = BootstrapService(api);

      expect(
        () => service.load(),
        throwsA(isA<ApiException>()),
      );
    });

    test('returns cached data when request fails after a successful load', () async {
      var call = 0;
      final api = ApiClient(
        client: MockClient((_) async {
          call += 1;
          if (call == 1) {
            return http.Response(
              jsonEncode({
                'ok': true,
                'data': {
                  'projects': [
                    {'id': 'first'}
                  ]
                },
                'dashboard': {
                  'kpis': {'revenue': 500}
                },
                'user': {
                  'id': '1',
                  'username': 'u',
                  'name': 'User',
                  'role': 'owner',
                  'active': true,
                },
              }),
              200,
            );
          }
          return http.Response(jsonEncode({'ok': false, 'error': 'Server down'}), 500);
        }),
      );
      final service = BootstrapService(api);

      final first = await service.load();
      final second = await service.load();

      expect(first.table('projects').first['id'], 'first');
      expect(second.table('projects').first['id'], 'first');
    });
  });
}
